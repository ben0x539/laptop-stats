#![feature(catch_expr)]

use std::{
    path, fs, time, net,

    str::FromStr,
    io::Read,
    sync::{
        Arc,
        Mutex,
    }
};

use failure::Error;

use prometheus::{Opts,
    Registry,
    Gauge,
    GaugeVec,
    TextEncoder,
    Encoder,
};

use structopt::StructOpt;

extern crate prometheus;
extern crate hyper;
#[macro_use]
extern crate failure;
#[macro_use]
extern crate structopt;

fn main() {
    main_().unwrap();
}

struct Metrics {
    updates: Vec<Box<Update>>,
    cpu_hz: GaugeVec,
    cpu_min_hz: GaugeVec,
    cpu_max_hz: GaugeVec,
    // /sys/devices/system/cpu/cpufreq/policy0/scaling_cur_freq:1042327
    // /sys/devices/system/cpu/cpufreq/policy0/scaling_max_freq:3400000
    // /sys/devices/system/cpu/cpufreq/policy0/scaling_min_freq:800000

    last_update_time: time::Instant,
}

trait Update {
    fn update(&mut self) -> Result<(), Error>;
    fn register(&mut self, &Registry) -> Result<(), Error>;
}

struct CpuTemp {
    cores: Vec<(path::PathBuf, Gauge)>,
    registry: Option<Registry>,
}

impl CpuTemp {
    fn drop(&mut self, offset: usize) {
        let registry = self.registry.as_mut().unwrap();
        for core in self.cores.drain(offset..) {
            let _ = registry.unregister(Box::new(core.1));
        }
    }
}

impl Update for CpuTemp {
    fn update(&mut self) -> Result<(), Error> {
        // TODO: what do multi-cpu systems look like?
        let mut hwmon_id = -1;
        for i in 0..999 {
            let path = format!("/sys/class/hwmon/hwmon{}/name", i);
            match read_file(path).as_ref().map(|s| s.trim()) {
                Ok("coretemp") => {
                    hwmon_id = i;
                    break;
                } Ok(_) => {
                    continue;
                } _ => {
                    break;
                }
            }
        }

        if hwmon_id == -1 {
            self.drop(0);
            bail!("cputemp: no cores found");
        }

        let mut cores = 0;
        for temp_id in 1..1000 {
            let path = format!("/sys/class/hwmon/hwmon{}/temp{}_label",
                hwmon_id, temp_id);
            let label = read_file(path);
            if !label.as_ref().map(|s| s.starts_with("Core "))
                    .unwrap_or(false) {
                continue;
            }
            let core_id = usize::from_str(&label?.trim()[5..])?;
            cores = usize::max(core_id + 1, cores);
            while self.cores.len() < cores {
                let path = format!("/sys/class/hwmon/hwmon{}/temp{}_input",
                    hwmon_id, temp_id);
                let gauge = Gauge::with_opts(
                    Opts::new("laptop_temperature_celsius",
                            "component temperature")
                        .const_label("component", "cpu")
                        .const_label("core", &self.cores.len().to_string()))?;
                self.cores.push((path.into(), gauge.clone()));
                self.registry.as_mut().unwrap().register(Box::new(gauge))?;
            }
        }

        if cores < self.cores.len() {
            self.drop(cores);
        }

        if cores == 0 {
            bail!("cputemp: no cores found");
        }

        for &(ref path, ref gauge) in &self.cores {
            gauge.set(f64::from_str(read_file(path)?.trim())? / 1000.0);
        }

        Ok(())
    }

    fn register(&mut self, r: &Registry) -> Result<(), Error> {
        self.registry = Some(r.clone());

        Ok(())
    }
}

struct FileGauge<F: FnMut(String) -> Result<f64, Error>> {
    gauge: Gauge,
    path: path::PathBuf,
    transform: F,
}

impl<F: FnMut(String) -> Result<f64, Error>> Update for FileGauge<F> {
    fn update(&mut self) -> Result<(), Error> {
        let file_contents = read_file(&self.path)?;
        let value = (self.transform)(file_contents)?;
        self.gauge.set(value);

        Ok(())
    }

    fn register(&mut self, r: &Registry) -> Result<(), Error> {
        r.register(Box::new(self.gauge.clone()))?;
        Ok(())
    }
}

fn from_file<P: Into<path::PathBuf>>(gauge: Gauge, p: P)
        -> FileGauge<impl FnMut(String) -> Result<f64, Error>> {
    FileGauge {
        gauge: gauge,
        path: p.into(),
        transform: |s| Ok(f64::from_str(s.trim())?),
    }
}

impl Metrics {
    fn new() -> Result<Metrics, Error> {
        let mut updates: Vec<Box<Update>> = Vec::new();

        for entry in fs::read_dir("/sys/class/backlight")? {
            let entry = entry?;
            match entry.file_name().to_str() {
                Some(name) if !name.starts_with(".") => name,
                _ => continue,
            }
            let file_type = entry.file_type()?;
            let file_type = if file_type.is_symlink() {
                let metadata = fs::metadata(&entry.path())?;
                metadata.file_type()
            } else {
                file_type
            };
            if !file_type.is_dir() {
                continue;
            };

            let path = entry.path();

            // TODO: this is gonna break if a laptop has multiple backlights
            //       but clearly that can never happen
            updates.push(Box::new(from_file(
                Gauge::new(
                    "laptop_backlight_brightness",
                    "current backlight brightness")?,
                path.join("brightness"))));
            updates.push(Box::new(from_file(
                Gauge::new(
                    "laptop_backlight_brightness_max",
                    "maximum backlight brightness")?,
                path.join("max_brightness"))));
        }

        updates.push(Box::new(FileGauge {
            gauge: Gauge::new(
                "laptop_lid_position",
                "whether the lid is open (1) or closed (0)")?,
            path: "/proc/acpi/button/lid/LID0/state".into(),
            transform: |s: String| Ok(match s.trim() {
                "state:      open" => 1.0,
                "state:      closed" => 0.0,
                _ => -1.0,
            }),
        }));

        let f = |s: String| Ok(f64::from_str(s.trim())? * 3600.0 / 1e6);
        updates.push(Box::new(FileGauge {
            gauge: Gauge::new(
                "laptop_battery_full",
                "maximum battery charge")?,
            path: "/sys/class/power_supply/BAT0/charge_full".into(),
            transform: f,
        }));
        updates.push(Box::new(FileGauge {
            gauge: Gauge::new(
                "laptop_battery_full_design",
                "design maximum battery charge")?,
            path: "/sys/class/power_supply/BAT0/charge_full_design".into(),
            transform: f,
        }));
        updates.push(Box::new(FileGauge {
            gauge: Gauge::new(
                "laptop_battery_now",
                "current battery charge")?,
            path: "/sys/class/power_supply/BAT0/charge_now".into(),
            transform: f,
        }));

        updates.push(Box::new(CpuTemp {
            cores: Vec::new(),
            registry: None,
        }));

        let metrics = Metrics {
            updates: updates,
            last_update_time: time::Instant::now(),
            cpu_hz: GaugeVec::new(
                Opts::new("laptop_cpu_hz", "clock frequency"),
                &["thread"])?,
            cpu_min_hz: GaugeVec::new(
                Opts::new("laptop_cpu_min_hz", "minimum clock frequency"),
                &["thread"])?,
            cpu_max_hz: GaugeVec::new(
                Opts::new("laptop_cpu_max_hz", "maximum clock frequency"),
                &["thread"])?,
            // TODO: wifi connectivity?
        };
        Ok(metrics)
    }

    fn register(&mut self, r: &Registry) -> Result<(), Error> {
        for update in &mut self.updates {
            update.register(r)?;
        }
        r.register(Box::new(self.cpu_hz.clone()))?;
        r.register(Box::new(self.cpu_min_hz.clone()))?;
        r.register(Box::new(self.cpu_max_hz.clone()))?;

        Ok(())
    }

    fn update(&mut self) -> Result<(), Error> {
        self.last_update_time = time::Instant::now();

        for update in &mut self.updates {
            if let Err(e) = update.update() {
                eprintln!("error: {:?}", e);
            }
        }

        for entry in fs::read_dir("/sys/devices/system/cpu/cpufreq")? {
            let entry = entry?;
            let file_name = entry.file_name();
            let (num, path) = match file_name.to_str() {
                Some(name) if name.starts_with("policy") => {
                    (&name[6..], entry.path())
                } _ => continue,
            };

            self.cpu_hz.get_metric_with_label_values(&[num])?
                .set(read_num(&path.join("scaling_cur_freq"))? * 1000.0);
            self.cpu_min_hz.get_metric_with_label_values(&[num])?
                .set(read_num(&path.join("scaling_min_freq"))? * 1000.0);
            self.cpu_max_hz.get_metric_with_label_values(&[num])?
                .set(read_num(&path.join("scaling_max_freq"))? * 1000.0);
        }

        Ok(())
    }

    fn maybe_update(&mut self, min_delay: time::Duration)
            -> Result<(), Error> {
        let now = time::Instant::now();
        if now.duration_since(self.last_update_time) < min_delay {
            return Ok(());
        }

        self.update()?;

        return Ok(());
    }
}

fn read_file<P: AsRef<path::Path>>(p: P) -> Result<String, Error> {
    let mut file = fs::File::open(p)?;
    let mut contents = String::new();
    file.read_to_string(&mut contents)?;
    Ok(contents)
}

fn read_num<P: AsRef<path::Path>>(p: P) -> Result<f64, Error> {
    let num = f64::from_str(read_file(p)?.trim())?;
    Ok(num)
}

#[derive(Debug, StructOpt)]
struct Opt {
    #[structopt(long = "bind-address", default_value = "127.0.0.1:24042")]
    bind_address: net::SocketAddr,
}

fn main_() -> Result<(), Error> {
    let opt = Opt::from_args();

    let mut metrics = Metrics::new()?;
    let registry = Registry::new();
    metrics.register(&registry)?;
    metrics.update()?;
    let metrics = Arc::new(Mutex::new(metrics));

    let new_service = move || {
        let registry = registry.clone();
        let metrics = metrics.clone();
        let f = move |_req| -> Result<hyper::server::Response, hyper::Error> {
            let res: Result<_, _> = do catch {
                metrics.lock().unwrap() // XXX
                    .maybe_update(time::Duration::from_secs(5))?;

                let metric_familys = registry.gather();
                let mut buffer = Vec::new();
                let encoder = TextEncoder::new();
                encoder.encode(&metric_familys, &mut buffer)?;

                let content_type =
                    encoder.format_type().parse::<hyper::mime::Mime>()?;

                hyper::server::Response::new()
                    .with_header(hyper::header::ContentType(content_type))
                    .with_body(buffer)
            };
            let resp = res.unwrap_or_else(|e: Error|
                hyper::server::Response::new()
                    .with_status(hyper::StatusCode::InternalServerError)
                    .with_body(e.to_string()));

            return Ok(resp);
        };

        Ok(hyper::server::service_fn(f))
    };

    let server = hyper::server::Http::new()
        .bind(&opt.bind_address, new_service)?;

    server.run()?;

    Ok(())
}
