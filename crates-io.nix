{ lib, buildRustCrate, buildRustCrateHelpers }:
with buildRustCrateHelpers;
let inherit (lib.lists) fold;
    inherit (lib.attrsets) recursiveUpdate;
in
rec {

# ansi_term-0.10.2

  crates.ansi_term."0.10.2" = deps: { features?(features_.ansi_term."0.10.2" deps {}) }: buildRustCrate {
    crateName = "ansi_term";
    version = "0.10.2";
    description = "Library for ANSI terminal colours and styles (bold, underline)";
    authors = [ "ogham@bsago.me" "Ryan Scheel (Havvy) <ryan.havvy@gmail.com>" "Josh Triplett <josh@joshtriplett.org>" ];
    sha256 = "07k0hfmlhv43lihyxb9d81l5mq5zlpqvv30dkfd3knmv2ginasn9";
  };
  features_.ansi_term."0.10.2" = deps: f: updateFeatures f (rec {
    ansi_term."0.10.2".default = (f.ansi_term."0.10.2".default or true);
  }) [];


# end
# atty-0.2.10

  crates.atty."0.2.10" = deps: { features?(features_.atty."0.2.10" deps {}) }: buildRustCrate {
    crateName = "atty";
    version = "0.2.10";
    description = "A simple interface for querying atty";
    authors = [ "softprops <d.tangren@gmail.com>" ];
    sha256 = "1h26lssj8rwaz0xhwwm5a645r49yly211amfmd243m3m0jl49i2c";
    dependencies = (if kernel == "redox" then mapFeatures features ([
      (crates."termion"."${deps."atty"."0.2.10"."termion"}" deps)
    ]) else [])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."atty"."0.2.10"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."atty"."0.2.10"."winapi"}" deps)
    ]) else []);
  };
  features_.atty."0.2.10" = deps: f: updateFeatures f (rec {
    atty."0.2.10".default = (f.atty."0.2.10".default or true);
    libc."${deps.atty."0.2.10".libc}".default = (f.libc."${deps.atty."0.2.10".libc}".default or false);
    termion."${deps.atty."0.2.10".termion}".default = true;
    winapi = fold recursiveUpdate {} [
      { "${deps.atty."0.2.10".winapi}"."consoleapi" = true; }
      { "${deps.atty."0.2.10".winapi}"."minwinbase" = true; }
      { "${deps.atty."0.2.10".winapi}"."minwindef" = true; }
      { "${deps.atty."0.2.10".winapi}"."processenv" = true; }
      { "${deps.atty."0.2.10".winapi}"."winbase" = true; }
      { "${deps.atty."0.2.10".winapi}".default = true; }
    ];
  }) [
    (features_.termion."${deps."atty"."0.2.10"."termion"}" deps)
    (features_.libc."${deps."atty"."0.2.10"."libc"}" deps)
    (features_.winapi."${deps."atty"."0.2.10"."winapi"}" deps)
  ];


# end
# backtrace-0.3.5

  crates.backtrace."0.3.5" = deps: { features?(features_.backtrace."0.3.5" deps {}) }: buildRustCrate {
    crateName = "backtrace";
    version = "0.3.5";
    description = "A library to acquire a stack trace (backtrace) at runtime in a Rust program.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" "The Rust Project Developers" ];
    sha256 = "0vj1dgsivxci5r43w9d56yb98g3r7ff75zr5f592j7yizznshh2r";
    dependencies = mapFeatures features ([
      (crates."cfg_if"."${deps."backtrace"."0.3.5"."cfg_if"}" deps)
      (crates."rustc_demangle"."${deps."backtrace"."0.3.5"."rustc_demangle"}" deps)
    ])
      ++ (if (kernel == "linux" || kernel == "darwin") && !(kernel == "fuchsia") && !(kernel == "emscripten") && !(kernel == "darwin") && !(kernel == "ios") then mapFeatures features ([
    ]
      ++ (if features.backtrace."0.3.5".backtrace-sys or false then [ (crates.backtrace_sys."${deps."backtrace"."0.3.5".backtrace_sys}" deps) ] else [])) else [])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."backtrace"."0.3.5"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
    ]
      ++ (if features.backtrace."0.3.5".winapi or false then [ (crates.winapi."${deps."backtrace"."0.3.5".winapi}" deps) ] else [])) else []);
    features = mkFeatures (features."backtrace"."0.3.5" or {});
  };
  features_.backtrace."0.3.5" = deps: f: updateFeatures f (rec {
    backtrace = fold recursiveUpdate {} [
      { "0.3.5"."addr2line" =
        (f.backtrace."0.3.5"."addr2line" or false) ||
        (f.backtrace."0.3.5".gimli-symbolize or false) ||
        (backtrace."0.3.5"."gimli-symbolize" or false); }
      { "0.3.5"."backtrace-sys" =
        (f.backtrace."0.3.5"."backtrace-sys" or false) ||
        (f.backtrace."0.3.5".libbacktrace or false) ||
        (backtrace."0.3.5"."libbacktrace" or false); }
      { "0.3.5"."coresymbolication" =
        (f.backtrace."0.3.5"."coresymbolication" or false) ||
        (f.backtrace."0.3.5".default or false) ||
        (backtrace."0.3.5"."default" or false); }
      { "0.3.5"."dbghelp" =
        (f.backtrace."0.3.5"."dbghelp" or false) ||
        (f.backtrace."0.3.5".default or false) ||
        (backtrace."0.3.5"."default" or false); }
      { "0.3.5"."dladdr" =
        (f.backtrace."0.3.5"."dladdr" or false) ||
        (f.backtrace."0.3.5".default or false) ||
        (backtrace."0.3.5"."default" or false); }
      { "0.3.5"."findshlibs" =
        (f.backtrace."0.3.5"."findshlibs" or false) ||
        (f.backtrace."0.3.5".gimli-symbolize or false) ||
        (backtrace."0.3.5"."gimli-symbolize" or false); }
      { "0.3.5"."libbacktrace" =
        (f.backtrace."0.3.5"."libbacktrace" or false) ||
        (f.backtrace."0.3.5".default or false) ||
        (backtrace."0.3.5"."default" or false); }
      { "0.3.5"."libunwind" =
        (f.backtrace."0.3.5"."libunwind" or false) ||
        (f.backtrace."0.3.5".default or false) ||
        (backtrace."0.3.5"."default" or false); }
      { "0.3.5"."rustc-serialize" =
        (f.backtrace."0.3.5"."rustc-serialize" or false) ||
        (f.backtrace."0.3.5".serialize-rustc or false) ||
        (backtrace."0.3.5"."serialize-rustc" or false); }
      { "0.3.5"."serde" =
        (f.backtrace."0.3.5"."serde" or false) ||
        (f.backtrace."0.3.5".serialize-serde or false) ||
        (backtrace."0.3.5"."serialize-serde" or false); }
      { "0.3.5"."serde_derive" =
        (f.backtrace."0.3.5"."serde_derive" or false) ||
        (f.backtrace."0.3.5".serialize-serde or false) ||
        (backtrace."0.3.5"."serialize-serde" or false); }
      { "0.3.5"."winapi" =
        (f.backtrace."0.3.5"."winapi" or false) ||
        (f.backtrace."0.3.5".dbghelp or false) ||
        (backtrace."0.3.5"."dbghelp" or false); }
      { "0.3.5".default = (f.backtrace."0.3.5".default or true); }
    ];
    backtrace_sys."${deps.backtrace."0.3.5".backtrace_sys}".default = true;
    cfg_if."${deps.backtrace."0.3.5".cfg_if}".default = true;
    libc."${deps.backtrace."0.3.5".libc}".default = true;
    rustc_demangle."${deps.backtrace."0.3.5".rustc_demangle}".default = true;
    winapi = fold recursiveUpdate {} [
      { "${deps.backtrace."0.3.5".winapi}"."dbghelp" = true; }
      { "${deps.backtrace."0.3.5".winapi}"."minwindef" = true; }
      { "${deps.backtrace."0.3.5".winapi}"."processthreadsapi" = true; }
      { "${deps.backtrace."0.3.5".winapi}"."std" = true; }
      { "${deps.backtrace."0.3.5".winapi}"."winnt" = true; }
      { "${deps.backtrace."0.3.5".winapi}".default = true; }
    ];
  }) [
    (features_.cfg_if."${deps."backtrace"."0.3.5"."cfg_if"}" deps)
    (features_.rustc_demangle."${deps."backtrace"."0.3.5"."rustc_demangle"}" deps)
    (features_.backtrace_sys."${deps."backtrace"."0.3.5"."backtrace_sys"}" deps)
    (features_.libc."${deps."backtrace"."0.3.5"."libc"}" deps)
    (features_.winapi."${deps."backtrace"."0.3.5"."winapi"}" deps)
  ];


# end
# backtrace-sys-0.1.16

  crates.backtrace_sys."0.1.16" = deps: { features?(features_.backtrace_sys."0.1.16" deps {}) }: buildRustCrate {
    crateName = "backtrace-sys";
    version = "0.1.16";
    description = "Bindings to the libbacktrace gcc library\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1cn2c8q3dn06crmnk0p62czkngam4l8nf57wy33nz1y5g25pszwy";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."backtrace_sys"."0.1.16"."libc"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."cc"."${deps."backtrace_sys"."0.1.16"."cc"}" deps)
    ]);
  };
  features_.backtrace_sys."0.1.16" = deps: f: updateFeatures f (rec {
    backtrace_sys."0.1.16".default = (f.backtrace_sys."0.1.16".default or true);
    cc."${deps.backtrace_sys."0.1.16".cc}".default = true;
    libc."${deps.backtrace_sys."0.1.16".libc}".default = true;
  }) [
    (features_.libc."${deps."backtrace_sys"."0.1.16"."libc"}" deps)
    (features_.cc."${deps."backtrace_sys"."0.1.16"."cc"}" deps)
  ];


# end
# base64-0.9.0

  crates.base64."0.9.0" = deps: { features?(features_.base64."0.9.0" deps {}) }: buildRustCrate {
    crateName = "base64";
    version = "0.9.0";
    description = "encodes and decodes base64 as bytes or utf8";
    authors = [ "Alice Maz <alice@alicemaz.com>" "Marshall Pierce <marshall@mpierce.org>" ];
    sha256 = "1hsl1fgjpgl0ssg471m827svlfij8yhax0l6ldaqkrip78049fz3";
    dependencies = mapFeatures features ([
      (crates."byteorder"."${deps."base64"."0.9.0"."byteorder"}" deps)
      (crates."safemem"."${deps."base64"."0.9.0"."safemem"}" deps)
    ]);
  };
  features_.base64."0.9.0" = deps: f: updateFeatures f (rec {
    base64."0.9.0".default = (f.base64."0.9.0".default or true);
    byteorder."${deps.base64."0.9.0".byteorder}".default = true;
    safemem."${deps.base64."0.9.0".safemem}".default = true;
  }) [
    (features_.byteorder."${deps."base64"."0.9.0"."byteorder"}" deps)
    (features_.safemem."${deps."base64"."0.9.0"."safemem"}" deps)
  ];


# end
# bitflags-0.7.0

  crates.bitflags."0.7.0" = deps: { features?(features_.bitflags."0.7.0" deps {}) }: buildRustCrate {
    crateName = "bitflags";
    version = "0.7.0";
    description = "A macro to generate structures which behave like bitflags.\n";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1hr72xg5slm0z4pxs2hiy4wcyx3jva70h58b7mid8l0a4c8f7gn5";
  };
  features_.bitflags."0.7.0" = deps: f: updateFeatures f (rec {
    bitflags."0.7.0".default = (f.bitflags."0.7.0".default or true);
  }) [];


# end
# bitflags-1.0.1

  crates.bitflags."1.0.1" = deps: { features?(features_.bitflags."1.0.1" deps {}) }: buildRustCrate {
    crateName = "bitflags";
    version = "1.0.1";
    description = "A macro to generate structures which behave like bitflags.\n";
    authors = [ "The Rust Project Developers" ];
    sha256 = "0p4b3nr0s5nda2qmm7xdhnvh4lkqk3xd8l9ffmwbvqw137vx7mj1";
    features = mkFeatures (features."bitflags"."1.0.1" or {});
  };
  features_.bitflags."1.0.1" = deps: f: updateFeatures f (rec {
    bitflags = fold recursiveUpdate {} [
      { "1.0.1"."example_generated" =
        (f.bitflags."1.0.1"."example_generated" or false) ||
        (f.bitflags."1.0.1".default or false) ||
        (bitflags."1.0.1"."default" or false); }
      { "1.0.1".default = (f.bitflags."1.0.1".default or true); }
    ];
  }) [];


# end
# byteorder-1.2.1

  crates.byteorder."1.2.1" = deps: { features?(features_.byteorder."1.2.1" deps {}) }: buildRustCrate {
    crateName = "byteorder";
    version = "1.2.1";
    description = "Library for reading/writing numbers in big-endian and little-endian.";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "1wsxnqcscg4gchdmgdbwc78lw2qx2i6bnjd564xq7h7qc4fp2157";
    features = mkFeatures (features."byteorder"."1.2.1" or {});
  };
  features_.byteorder."1.2.1" = deps: f: updateFeatures f (rec {
    byteorder = fold recursiveUpdate {} [
      { "1.2.1"."std" =
        (f.byteorder."1.2.1"."std" or false) ||
        (f.byteorder."1.2.1".default or false) ||
        (byteorder."1.2.1"."default" or false); }
      { "1.2.1".default = (f.byteorder."1.2.1".default or true); }
    ];
  }) [];


# end
# bytes-0.4.5

  crates.bytes."0.4.5" = deps: { features?(features_.bytes."0.4.5" deps {}) }: buildRustCrate {
    crateName = "bytes";
    version = "0.4.5";
    description = "Types and traits for working with bytes";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "09grypiv7wnqbhsmini1i77d5bwcna6nzp3yhh9i02hn37ma58vn";
    dependencies = mapFeatures features ([
      (crates."byteorder"."${deps."bytes"."0.4.5"."byteorder"}" deps)
      (crates."iovec"."${deps."bytes"."0.4.5"."iovec"}" deps)
    ]);
  };
  features_.bytes."0.4.5" = deps: f: updateFeatures f (rec {
    byteorder."${deps.bytes."0.4.5".byteorder}".default = true;
    bytes."0.4.5".default = (f.bytes."0.4.5".default or true);
    iovec."${deps.bytes."0.4.5".iovec}".default = true;
  }) [
    (features_.byteorder."${deps."bytes"."0.4.5"."byteorder"}" deps)
    (features_.iovec."${deps."bytes"."0.4.5"."iovec"}" deps)
  ];


# end
# cc-1.0.3

  crates.cc."1.0.3" = deps: { features?(features_.cc."1.0.3" deps {}) }: buildRustCrate {
    crateName = "cc";
    version = "1.0.3";
    description = "A build-time dependency for Cargo build scripts to assist in invoking the native\nC compiler to compile native C code into a static archive to be linked into Rust\ncode.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "193pwqgh79w6k0k29svyds5nnlrwx44myqyrw605d5jj4yk2zmpr";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."cc"."1.0.3" or {});
  };
  features_.cc."1.0.3" = deps: f: updateFeatures f (rec {
    cc = fold recursiveUpdate {} [
      { "1.0.3"."rayon" =
        (f.cc."1.0.3"."rayon" or false) ||
        (f.cc."1.0.3".parallel or false) ||
        (cc."1.0.3"."parallel" or false); }
      { "1.0.3".default = (f.cc."1.0.3".default or true); }
    ];
  }) [];


# end
# cfg-if-0.1.2

  crates.cfg_if."0.1.2" = deps: { features?(features_.cfg_if."0.1.2" deps {}) }: buildRustCrate {
    crateName = "cfg-if";
    version = "0.1.2";
    description = "A macro to ergonomically define an item depending on a large number of #[cfg]\nparameters. Structured like an if-else chain, the first matching branch is the\nitem that gets emitted.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "0x06hvrrqy96m97593823vvxcgvjaxckghwyy2jcyc8qc7c6cyhi";
  };
  features_.cfg_if."0.1.2" = deps: f: updateFeatures f (rec {
    cfg_if."0.1.2".default = (f.cfg_if."0.1.2".default or true);
  }) [];


# end
# clap-2.30.0

  crates.clap."2.30.0" = deps: { features?(features_.clap."2.30.0" deps {}) }: buildRustCrate {
    crateName = "clap";
    version = "2.30.0";
    description = "A simple to use, efficient, and full featured  Command Line Argument Parser\n";
    authors = [ "Kevin K. <kbknapp@gmail.com>" ];
    sha256 = "1mqakqrlqr127v1whwhv59bsxb6d7f0mi61c00fg8f83paxbs3y5";
    dependencies = mapFeatures features ([
      (crates."bitflags"."${deps."clap"."2.30.0"."bitflags"}" deps)
      (crates."textwrap"."${deps."clap"."2.30.0"."textwrap"}" deps)
      (crates."unicode_width"."${deps."clap"."2.30.0"."unicode_width"}" deps)
    ]
      ++ (if features.clap."2.30.0".atty or false then [ (crates.atty."${deps."clap"."2.30.0".atty}" deps) ] else [])
      ++ (if features.clap."2.30.0".strsim or false then [ (crates.strsim."${deps."clap"."2.30.0".strsim}" deps) ] else [])
      ++ (if features.clap."2.30.0".vec_map or false then [ (crates.vec_map."${deps."clap"."2.30.0".vec_map}" deps) ] else []))
      ++ (if !(kernel == "windows") then mapFeatures features ([
    ]
      ++ (if features.clap."2.30.0".ansi_term or false then [ (crates.ansi_term."${deps."clap"."2.30.0".ansi_term}" deps) ] else [])) else []);
    features = mkFeatures (features."clap"."2.30.0" or {});
  };
  features_.clap."2.30.0" = deps: f: updateFeatures f (rec {
    ansi_term."${deps.clap."2.30.0".ansi_term}".default = true;
    atty."${deps.clap."2.30.0".atty}".default = true;
    bitflags."${deps.clap."2.30.0".bitflags}".default = true;
    clap = fold recursiveUpdate {} [
      { "2.30.0"."ansi_term" =
        (f.clap."2.30.0"."ansi_term" or false) ||
        (f.clap."2.30.0".color or false) ||
        (clap."2.30.0"."color" or false); }
      { "2.30.0"."atty" =
        (f.clap."2.30.0"."atty" or false) ||
        (f.clap."2.30.0".color or false) ||
        (clap."2.30.0"."color" or false); }
      { "2.30.0"."clippy" =
        (f.clap."2.30.0"."clippy" or false) ||
        (f.clap."2.30.0".lints or false) ||
        (clap."2.30.0"."lints" or false); }
      { "2.30.0"."color" =
        (f.clap."2.30.0"."color" or false) ||
        (f.clap."2.30.0".default or false) ||
        (clap."2.30.0"."default" or false); }
      { "2.30.0"."strsim" =
        (f.clap."2.30.0"."strsim" or false) ||
        (f.clap."2.30.0".suggestions or false) ||
        (clap."2.30.0"."suggestions" or false); }
      { "2.30.0"."suggestions" =
        (f.clap."2.30.0"."suggestions" or false) ||
        (f.clap."2.30.0".default or false) ||
        (clap."2.30.0"."default" or false); }
      { "2.30.0"."term_size" =
        (f.clap."2.30.0"."term_size" or false) ||
        (f.clap."2.30.0".wrap_help or false) ||
        (clap."2.30.0"."wrap_help" or false); }
      { "2.30.0"."vec_map" =
        (f.clap."2.30.0"."vec_map" or false) ||
        (f.clap."2.30.0".default or false) ||
        (clap."2.30.0"."default" or false); }
      { "2.30.0"."yaml" =
        (f.clap."2.30.0"."yaml" or false) ||
        (f.clap."2.30.0".doc or false) ||
        (clap."2.30.0"."doc" or false); }
      { "2.30.0"."yaml-rust" =
        (f.clap."2.30.0"."yaml-rust" or false) ||
        (f.clap."2.30.0".yaml or false) ||
        (clap."2.30.0"."yaml" or false); }
      { "2.30.0".default = (f.clap."2.30.0".default or true); }
    ];
    strsim."${deps.clap."2.30.0".strsim}".default = true;
    textwrap = fold recursiveUpdate {} [
      { "${deps.clap."2.30.0".textwrap}"."term_size" =
        (f.textwrap."${deps.clap."2.30.0".textwrap}"."term_size" or false) ||
        (clap."2.30.0"."wrap_help" or false) ||
        (f."clap"."2.30.0"."wrap_help" or false); }
      { "${deps.clap."2.30.0".textwrap}".default = true; }
    ];
    unicode_width."${deps.clap."2.30.0".unicode_width}".default = true;
    vec_map."${deps.clap."2.30.0".vec_map}".default = true;
  }) [
    (features_.atty."${deps."clap"."2.30.0"."atty"}" deps)
    (features_.bitflags."${deps."clap"."2.30.0"."bitflags"}" deps)
    (features_.strsim."${deps."clap"."2.30.0"."strsim"}" deps)
    (features_.textwrap."${deps."clap"."2.30.0"."textwrap"}" deps)
    (features_.unicode_width."${deps."clap"."2.30.0"."unicode_width"}" deps)
    (features_.vec_map."${deps."clap"."2.30.0"."vec_map"}" deps)
    (features_.ansi_term."${deps."clap"."2.30.0"."ansi_term"}" deps)
  ];


# end
# failure-0.1.1

  crates.failure."0.1.1" = deps: { features?(features_.failure."0.1.1" deps {}) }: buildRustCrate {
    crateName = "failure";
    version = "0.1.1";
    description = "Experimental error handling abstraction.";
    authors = [ "Without Boats <boats@mozilla.com>" ];
    sha256 = "0gf9cmkm9kc163sszgjksqp5pcgj689lnf2104nn4h4is18nhigk";
    dependencies = mapFeatures features ([
    ]
      ++ (if features.failure."0.1.1".backtrace or false then [ (crates.backtrace."${deps."failure"."0.1.1".backtrace}" deps) ] else [])
      ++ (if features.failure."0.1.1".failure_derive or false then [ (crates.failure_derive."${deps."failure"."0.1.1".failure_derive}" deps) ] else []));
    features = mkFeatures (features."failure"."0.1.1" or {});
  };
  features_.failure."0.1.1" = deps: f: updateFeatures f (rec {
    backtrace."${deps.failure."0.1.1".backtrace}".default = true;
    failure = fold recursiveUpdate {} [
      { "0.1.1"."backtrace" =
        (f.failure."0.1.1"."backtrace" or false) ||
        (f.failure."0.1.1".std or false) ||
        (failure."0.1.1"."std" or false); }
      { "0.1.1"."derive" =
        (f.failure."0.1.1"."derive" or false) ||
        (f.failure."0.1.1".default or false) ||
        (failure."0.1.1"."default" or false); }
      { "0.1.1"."failure_derive" =
        (f.failure."0.1.1"."failure_derive" or false) ||
        (f.failure."0.1.1".derive or false) ||
        (failure."0.1.1"."derive" or false); }
      { "0.1.1"."std" =
        (f.failure."0.1.1"."std" or false) ||
        (f.failure."0.1.1".default or false) ||
        (failure."0.1.1"."default" or false); }
      { "0.1.1".default = (f.failure."0.1.1".default or true); }
    ];
    failure_derive."${deps.failure."0.1.1".failure_derive}".default = true;
  }) [
    (features_.backtrace."${deps."failure"."0.1.1"."backtrace"}" deps)
    (features_.failure_derive."${deps."failure"."0.1.1"."failure_derive"}" deps)
  ];


# end
# failure_derive-0.1.1

  crates.failure_derive."0.1.1" = deps: { features?(features_.failure_derive."0.1.1" deps {}) }: buildRustCrate {
    crateName = "failure_derive";
    version = "0.1.1";
    description = "derives for the failure crate";
    authors = [ "Without Boats <woboats@gmail.com>" ];
    sha256 = "1w895q4pbyx3rwnhgjwfcayk9ghbi166wc1c3553qh8zkbz52k8i";
    procMacro = true;
    dependencies = mapFeatures features ([
      (crates."quote"."${deps."failure_derive"."0.1.1"."quote"}" deps)
      (crates."syn"."${deps."failure_derive"."0.1.1"."syn"}" deps)
      (crates."synstructure"."${deps."failure_derive"."0.1.1"."synstructure"}" deps)
    ]);
    features = mkFeatures (features."failure_derive"."0.1.1" or {});
  };
  features_.failure_derive."0.1.1" = deps: f: updateFeatures f (rec {
    failure_derive = fold recursiveUpdate {} [
      { "0.1.1"."std" =
        (f.failure_derive."0.1.1"."std" or false) ||
        (f.failure_derive."0.1.1".default or false) ||
        (failure_derive."0.1.1"."default" or false); }
      { "0.1.1".default = (f.failure_derive."0.1.1".default or true); }
    ];
    quote."${deps.failure_derive."0.1.1".quote}".default = true;
    syn."${deps.failure_derive."0.1.1".syn}".default = true;
    synstructure."${deps.failure_derive."0.1.1".synstructure}".default = true;
  }) [
    (features_.quote."${deps."failure_derive"."0.1.1"."quote"}" deps)
    (features_.syn."${deps."failure_derive"."0.1.1"."syn"}" deps)
    (features_.synstructure."${deps."failure_derive"."0.1.1"."synstructure"}" deps)
  ];


# end
# fnv-1.0.6

  crates.fnv."1.0.6" = deps: { features?(features_.fnv."1.0.6" deps {}) }: buildRustCrate {
    crateName = "fnv";
    version = "1.0.6";
    description = "Fowler–Noll–Vo hash function";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "128mlh23y3gg6ag5h8iiqlcbl59smisdzraqy88ldrf75kbw27ip";
    libPath = "lib.rs";
  };
  features_.fnv."1.0.6" = deps: f: updateFeatures f (rec {
    fnv."1.0.6".default = (f.fnv."1.0.6".default or true);
  }) [];


# end
# fuchsia-zircon-0.2.1

  crates.fuchsia_zircon."0.2.1" = deps: { features?(features_.fuchsia_zircon."0.2.1" deps {}) }: buildRustCrate {
    crateName = "fuchsia-zircon";
    version = "0.2.1";
    description = "Rust bindings for the Zircon kernel";
    authors = [ "Raph Levien <raph@google.com>" ];
    sha256 = "0yd4rd7ql1vdr349p6vgq2dnwmpylky1kjp8g1zgvp250jxrhddb";
    dependencies = mapFeatures features ([
      (crates."fuchsia_zircon_sys"."${deps."fuchsia_zircon"."0.2.1"."fuchsia_zircon_sys"}" deps)
    ]);
  };
  features_.fuchsia_zircon."0.2.1" = deps: f: updateFeatures f (rec {
    fuchsia_zircon."0.2.1".default = (f.fuchsia_zircon."0.2.1".default or true);
    fuchsia_zircon_sys."${deps.fuchsia_zircon."0.2.1".fuchsia_zircon_sys}".default = true;
  }) [
    (features_.fuchsia_zircon_sys."${deps."fuchsia_zircon"."0.2.1"."fuchsia_zircon_sys"}" deps)
  ];


# end
# fuchsia-zircon-0.3.2

  crates.fuchsia_zircon."0.3.2" = deps: { features?(features_.fuchsia_zircon."0.3.2" deps {}) }: buildRustCrate {
    crateName = "fuchsia-zircon";
    version = "0.3.2";
    description = "Rust bindings for the Zircon kernel";
    authors = [ "Raph Levien <raph@google.com>" ];
    sha256 = "1zhxksplv52nlqd4j21h8462b5s913ngnhd303qsxsxn8dpaxgkq";
    dependencies = mapFeatures features ([
      (crates."bitflags"."${deps."fuchsia_zircon"."0.3.2"."bitflags"}" deps)
      (crates."fuchsia_zircon_sys"."${deps."fuchsia_zircon"."0.3.2"."fuchsia_zircon_sys"}" deps)
    ]);
  };
  features_.fuchsia_zircon."0.3.2" = deps: f: updateFeatures f (rec {
    bitflags."${deps.fuchsia_zircon."0.3.2".bitflags}".default = true;
    fuchsia_zircon."0.3.2".default = (f.fuchsia_zircon."0.3.2".default or true);
    fuchsia_zircon_sys."${deps.fuchsia_zircon."0.3.2".fuchsia_zircon_sys}".default = true;
  }) [
    (features_.bitflags."${deps."fuchsia_zircon"."0.3.2"."bitflags"}" deps)
    (features_.fuchsia_zircon_sys."${deps."fuchsia_zircon"."0.3.2"."fuchsia_zircon_sys"}" deps)
  ];


# end
# fuchsia-zircon-sys-0.2.0

  crates.fuchsia_zircon_sys."0.2.0" = deps: { features?(features_.fuchsia_zircon_sys."0.2.0" deps {}) }: buildRustCrate {
    crateName = "fuchsia-zircon-sys";
    version = "0.2.0";
    description = "Low-level Rust bindings for the Zircon kernel";
    authors = [ "Raph Levien <raph@google.com>" ];
    sha256 = "1yrqsrjwlhl3di6prxf5xmyd82gyjaysldbka5wwk83z11mpqh4w";
    dependencies = mapFeatures features ([
      (crates."bitflags"."${deps."fuchsia_zircon_sys"."0.2.0"."bitflags"}" deps)
    ]);
  };
  features_.fuchsia_zircon_sys."0.2.0" = deps: f: updateFeatures f (rec {
    bitflags."${deps.fuchsia_zircon_sys."0.2.0".bitflags}".default = true;
    fuchsia_zircon_sys."0.2.0".default = (f.fuchsia_zircon_sys."0.2.0".default or true);
  }) [
    (features_.bitflags."${deps."fuchsia_zircon_sys"."0.2.0"."bitflags"}" deps)
  ];


# end
# fuchsia-zircon-sys-0.3.2

  crates.fuchsia_zircon_sys."0.3.2" = deps: { features?(features_.fuchsia_zircon_sys."0.3.2" deps {}) }: buildRustCrate {
    crateName = "fuchsia-zircon-sys";
    version = "0.3.2";
    description = "Low-level Rust bindings for the Zircon kernel";
    authors = [ "Raph Levien <raph@google.com>" ];
    sha256 = "0p8mrhg8pxk4kpzziv6nlxd8xgkj916gsg2b0x2mvf9dxwzrqhnk";
  };
  features_.fuchsia_zircon_sys."0.3.2" = deps: f: updateFeatures f (rec {
    fuchsia_zircon_sys."0.3.2".default = (f.fuchsia_zircon_sys."0.3.2".default or true);
  }) [];


# end
# futures-0.1.17

  crates.futures."0.1.17" = deps: { features?(features_.futures."0.1.17" deps {}) }: buildRustCrate {
    crateName = "futures";
    version = "0.1.17";
    description = "An implementation of futures and streams featuring zero allocations,\ncomposability, and iterator-like interfaces.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1awrl30p1yqc0l9hbhng0f2873h2wr2244caj20b706plwqmcw0y";
    features = mkFeatures (features."futures"."0.1.17" or {});
  };
  features_.futures."0.1.17" = deps: f: updateFeatures f (rec {
    futures = fold recursiveUpdate {} [
      { "0.1.17"."use_std" =
        (f.futures."0.1.17"."use_std" or false) ||
        (f.futures."0.1.17".default or false) ||
        (futures."0.1.17"."default" or false); }
      { "0.1.17"."with-deprecated" =
        (f.futures."0.1.17"."with-deprecated" or false) ||
        (f.futures."0.1.17".default or false) ||
        (futures."0.1.17"."default" or false); }
      { "0.1.17".default = (f.futures."0.1.17".default or true); }
    ];
  }) [];


# end
# futures-cpupool-0.1.8

  crates.futures_cpupool."0.1.8" = deps: { features?(features_.futures_cpupool."0.1.8" deps {}) }: buildRustCrate {
    crateName = "futures-cpupool";
    version = "0.1.8";
    description = "An implementation of thread pools which hand out futures to the results of the\ncomputation on the threads themselves.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "0ficd31n5ljiixy6x0vjglhq4fp0v1p4qzxm3v6ymsrb3z080l5c";
    dependencies = mapFeatures features ([
      (crates."futures"."${deps."futures_cpupool"."0.1.8"."futures"}" deps)
      (crates."num_cpus"."${deps."futures_cpupool"."0.1.8"."num_cpus"}" deps)
    ]);
    features = mkFeatures (features."futures_cpupool"."0.1.8" or {});
  };
  features_.futures_cpupool."0.1.8" = deps: f: updateFeatures f (rec {
    futures = fold recursiveUpdate {} [
      { "${deps.futures_cpupool."0.1.8".futures}"."use_std" = true; }
      { "${deps.futures_cpupool."0.1.8".futures}"."with-deprecated" =
        (f.futures."${deps.futures_cpupool."0.1.8".futures}"."with-deprecated" or false) ||
        (futures_cpupool."0.1.8"."with-deprecated" or false) ||
        (f."futures_cpupool"."0.1.8"."with-deprecated" or false); }
      { "${deps.futures_cpupool."0.1.8".futures}".default = (f.futures."${deps.futures_cpupool."0.1.8".futures}".default or false); }
    ];
    futures_cpupool = fold recursiveUpdate {} [
      { "0.1.8"."with-deprecated" =
        (f.futures_cpupool."0.1.8"."with-deprecated" or false) ||
        (f.futures_cpupool."0.1.8".default or false) ||
        (futures_cpupool."0.1.8"."default" or false); }
      { "0.1.8".default = (f.futures_cpupool."0.1.8".default or true); }
    ];
    num_cpus."${deps.futures_cpupool."0.1.8".num_cpus}".default = true;
  }) [
    (features_.futures."${deps."futures_cpupool"."0.1.8"."futures"}" deps)
    (features_.num_cpus."${deps."futures_cpupool"."0.1.8"."num_cpus"}" deps)
  ];


# end
# httparse-1.2.3

  crates.httparse."1.2.3" = deps: { features?(features_.httparse."1.2.3" deps {}) }: buildRustCrate {
    crateName = "httparse";
    version = "1.2.3";
    description = "A tiny, safe, speedy, zero-copy HTTP/1.x parser.";
    authors = [ "Sean McArthur <sean.monstar@gmail.com>" ];
    sha256 = "13x17y9bip0bija06y4vwpgh8jdmdi2gsvjq02kyfy0fbp5cqa93";
    features = mkFeatures (features."httparse"."1.2.3" or {});
  };
  features_.httparse."1.2.3" = deps: f: updateFeatures f (rec {
    httparse = fold recursiveUpdate {} [
      { "1.2.3"."std" =
        (f.httparse."1.2.3"."std" or false) ||
        (f.httparse."1.2.3".default or false) ||
        (httparse."1.2.3"."default" or false); }
      { "1.2.3".default = (f.httparse."1.2.3".default or true); }
    ];
  }) [];


# end
# hyper-0.11.10

  crates.hyper."0.11.10" = deps: { features?(features_.hyper."0.11.10" deps {}) }: buildRustCrate {
    crateName = "hyper";
    version = "0.11.10";
    description = "A modern HTTP library.";
    authors = [ "Sean McArthur <sean@seanmonstar.com>" ];
    sha256 = "145rm1w48yqpm1964nc6j1f6h48f17q68li5x0ircn9qm59vq1q1";
    dependencies = mapFeatures features ([
      (crates."base64"."${deps."hyper"."0.11.10"."base64"}" deps)
      (crates."bytes"."${deps."hyper"."0.11.10"."bytes"}" deps)
      (crates."futures"."${deps."hyper"."0.11.10"."futures"}" deps)
      (crates."futures_cpupool"."${deps."hyper"."0.11.10"."futures_cpupool"}" deps)
      (crates."httparse"."${deps."hyper"."0.11.10"."httparse"}" deps)
      (crates."language_tags"."${deps."hyper"."0.11.10"."language_tags"}" deps)
      (crates."log"."${deps."hyper"."0.11.10"."log"}" deps)
      (crates."mime"."${deps."hyper"."0.11.10"."mime"}" deps)
      (crates."percent_encoding"."${deps."hyper"."0.11.10"."percent_encoding"}" deps)
      (crates."relay"."${deps."hyper"."0.11.10"."relay"}" deps)
      (crates."time"."${deps."hyper"."0.11.10"."time"}" deps)
      (crates."tokio_core"."${deps."hyper"."0.11.10"."tokio_core"}" deps)
      (crates."tokio_io"."${deps."hyper"."0.11.10"."tokio_io"}" deps)
      (crates."tokio_proto"."${deps."hyper"."0.11.10"."tokio_proto"}" deps)
      (crates."tokio_service"."${deps."hyper"."0.11.10"."tokio_service"}" deps)
      (crates."unicase"."${deps."hyper"."0.11.10"."unicase"}" deps)
    ]);
    features = mkFeatures (features."hyper"."0.11.10" or {});
  };
  features_.hyper."0.11.10" = deps: f: updateFeatures f (rec {
    base64."${deps.hyper."0.11.10".base64}".default = true;
    bytes."${deps.hyper."0.11.10".bytes}".default = true;
    futures."${deps.hyper."0.11.10".futures}".default = true;
    futures_cpupool."${deps.hyper."0.11.10".futures_cpupool}".default = true;
    httparse."${deps.hyper."0.11.10".httparse}".default = true;
    hyper = fold recursiveUpdate {} [
      { "0.11.10"."http" =
        (f.hyper."0.11.10"."http" or false) ||
        (f.hyper."0.11.10".compat or false) ||
        (hyper."0.11.10"."compat" or false); }
      { "0.11.10"."server-proto" =
        (f.hyper."0.11.10"."server-proto" or false) ||
        (f.hyper."0.11.10".default or false) ||
        (hyper."0.11.10"."default" or false); }
      { "0.11.10".default = (f.hyper."0.11.10".default or true); }
    ];
    language_tags."${deps.hyper."0.11.10".language_tags}".default = true;
    log."${deps.hyper."0.11.10".log}".default = true;
    mime."${deps.hyper."0.11.10".mime}".default = true;
    percent_encoding."${deps.hyper."0.11.10".percent_encoding}".default = true;
    relay."${deps.hyper."0.11.10".relay}".default = true;
    time."${deps.hyper."0.11.10".time}".default = true;
    tokio_core."${deps.hyper."0.11.10".tokio_core}".default = true;
    tokio_io."${deps.hyper."0.11.10".tokio_io}".default = true;
    tokio_proto."${deps.hyper."0.11.10".tokio_proto}".default = true;
    tokio_service."${deps.hyper."0.11.10".tokio_service}".default = true;
    unicase."${deps.hyper."0.11.10".unicase}".default = true;
  }) [
    (features_.base64."${deps."hyper"."0.11.10"."base64"}" deps)
    (features_.bytes."${deps."hyper"."0.11.10"."bytes"}" deps)
    (features_.futures."${deps."hyper"."0.11.10"."futures"}" deps)
    (features_.futures_cpupool."${deps."hyper"."0.11.10"."futures_cpupool"}" deps)
    (features_.httparse."${deps."hyper"."0.11.10"."httparse"}" deps)
    (features_.language_tags."${deps."hyper"."0.11.10"."language_tags"}" deps)
    (features_.log."${deps."hyper"."0.11.10"."log"}" deps)
    (features_.mime."${deps."hyper"."0.11.10"."mime"}" deps)
    (features_.percent_encoding."${deps."hyper"."0.11.10"."percent_encoding"}" deps)
    (features_.relay."${deps."hyper"."0.11.10"."relay"}" deps)
    (features_.time."${deps."hyper"."0.11.10"."time"}" deps)
    (features_.tokio_core."${deps."hyper"."0.11.10"."tokio_core"}" deps)
    (features_.tokio_io."${deps."hyper"."0.11.10"."tokio_io"}" deps)
    (features_.tokio_proto."${deps."hyper"."0.11.10"."tokio_proto"}" deps)
    (features_.tokio_service."${deps."hyper"."0.11.10"."tokio_service"}" deps)
    (features_.unicase."${deps."hyper"."0.11.10"."unicase"}" deps)
  ];


# end
# iovec-0.1.1

  crates.iovec."0.1.1" = deps: { features?(features_.iovec."0.1.1" deps {}) }: buildRustCrate {
    crateName = "iovec";
    version = "0.1.1";
    description = "Portable buffer type for scatter/gather I/O operations\n";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "14fns3g3arbql6lkczf2gbbzaqh22mfv7y1wq5rr2y8jhh5m8jmm";
    dependencies = (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."iovec"."0.1.1"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."iovec"."0.1.1"."winapi"}" deps)
    ]) else []);
  };
  features_.iovec."0.1.1" = deps: f: updateFeatures f (rec {
    iovec."0.1.1".default = (f.iovec."0.1.1".default or true);
    libc."${deps.iovec."0.1.1".libc}".default = true;
    winapi."${deps.iovec."0.1.1".winapi}".default = true;
  }) [
    (features_.libc."${deps."iovec"."0.1.1"."libc"}" deps)
    (features_.winapi."${deps."iovec"."0.1.1"."winapi"}" deps)
  ];


# end
# kernel32-sys-0.2.2

  crates.kernel32_sys."0.2.2" = deps: { features?(features_.kernel32_sys."0.2.2" deps {}) }: buildRustCrate {
    crateName = "kernel32-sys";
    version = "0.2.2";
    description = "Contains function definitions for the Windows API library kernel32. See winapi for types and constants.";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "1lrw1hbinyvr6cp28g60z97w32w8vsk6pahk64pmrv2fmby8srfj";
    libName = "kernel32";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."winapi"."${deps."kernel32_sys"."0.2.2"."winapi"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."winapi_build"."${deps."kernel32_sys"."0.2.2"."winapi_build"}" deps)
    ]);
  };
  features_.kernel32_sys."0.2.2" = deps: f: updateFeatures f (rec {
    kernel32_sys."0.2.2".default = (f.kernel32_sys."0.2.2".default or true);
    winapi."${deps.kernel32_sys."0.2.2".winapi}".default = true;
    winapi_build."${deps.kernel32_sys."0.2.2".winapi_build}".default = true;
  }) [
    (features_.winapi."${deps."kernel32_sys"."0.2.2"."winapi"}" deps)
    (features_.winapi_build."${deps."kernel32_sys"."0.2.2"."winapi_build"}" deps)
  ];


# end
# language-tags-0.2.2

  crates.language_tags."0.2.2" = deps: { features?(features_.language_tags."0.2.2" deps {}) }: buildRustCrate {
    crateName = "language-tags";
    version = "0.2.2";
    description = "Language tags for Rust";
    authors = [ "Pyfisch <pyfisch@gmail.com>" ];
    sha256 = "1zkrdzsqzzc7509kd7nngdwrp461glm2g09kqpzaqksp82frjdvy";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."language_tags"."0.2.2" or {});
  };
  features_.language_tags."0.2.2" = deps: f: updateFeatures f (rec {
    language_tags = fold recursiveUpdate {} [
      { "0.2.2"."heapsize" =
        (f.language_tags."0.2.2"."heapsize" or false) ||
        (f.language_tags."0.2.2".heap_size or false) ||
        (language_tags."0.2.2"."heap_size" or false); }
      { "0.2.2"."heapsize_plugin" =
        (f.language_tags."0.2.2"."heapsize_plugin" or false) ||
        (f.language_tags."0.2.2".heap_size or false) ||
        (language_tags."0.2.2"."heap_size" or false); }
      { "0.2.2".default = (f.language_tags."0.2.2".default or true); }
    ];
  }) [];


# end
# lazy_static-0.2.11

  crates.lazy_static."0.2.11" = deps: { features?(features_.lazy_static."0.2.11" deps {}) }: buildRustCrate {
    crateName = "lazy_static";
    version = "0.2.11";
    description = "A macro for declaring lazily evaluated statics in Rust.";
    authors = [ "Marvin Löbel <loebel.marvin@gmail.com>" ];
    sha256 = "1x6871cvpy5b96yv4c7jvpq316fp5d4609s9py7qk6cd6x9k34vm";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."lazy_static"."0.2.11" or {});
  };
  features_.lazy_static."0.2.11" = deps: f: updateFeatures f (rec {
    lazy_static = fold recursiveUpdate {} [
      { "0.2.11"."compiletest_rs" =
        (f.lazy_static."0.2.11"."compiletest_rs" or false) ||
        (f.lazy_static."0.2.11".compiletest or false) ||
        (lazy_static."0.2.11"."compiletest" or false); }
      { "0.2.11"."nightly" =
        (f.lazy_static."0.2.11"."nightly" or false) ||
        (f.lazy_static."0.2.11".spin_no_std or false) ||
        (lazy_static."0.2.11"."spin_no_std" or false); }
      { "0.2.11"."spin" =
        (f.lazy_static."0.2.11"."spin" or false) ||
        (f.lazy_static."0.2.11".spin_no_std or false) ||
        (lazy_static."0.2.11"."spin_no_std" or false); }
      { "0.2.11".default = (f.lazy_static."0.2.11".default or true); }
    ];
  }) [];


# end
# lazycell-0.5.1

  crates.lazycell."0.5.1" = deps: { features?(features_.lazycell."0.5.1" deps {}) }: buildRustCrate {
    crateName = "lazycell";
    version = "0.5.1";
    description = "A library providing a lazily filled Cell struct";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" "Nikita Pekin <contact@nikitapek.in>" ];
    sha256 = "1ds71sc24vnhfy0ys1v46qn7fkcavi4brsk4jg3dp8d0yli3sd31";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."lazycell"."0.5.1" or {});
  };
  features_.lazycell."0.5.1" = deps: f: updateFeatures f (rec {
    lazycell = fold recursiveUpdate {} [
      { "0.5.1"."clippy" =
        (f.lazycell."0.5.1"."clippy" or false) ||
        (f.lazycell."0.5.1".nightly-testing or false) ||
        (lazycell."0.5.1"."nightly-testing" or false); }
      { "0.5.1"."nightly" =
        (f.lazycell."0.5.1"."nightly" or false) ||
        (f.lazycell."0.5.1".nightly-testing or false) ||
        (lazycell."0.5.1"."nightly-testing" or false); }
      { "0.5.1".default = (f.lazycell."0.5.1".default or true); }
    ];
  }) [];


# end
# libc-0.2.35

  crates.libc."0.2.35" = deps: { features?(features_.libc."0.2.35" deps {}) }: buildRustCrate {
    crateName = "libc";
    version = "0.2.35";
    description = "A library for types and bindings to native C functions often found in libc or\nother common platform libraries.\n";
    authors = [ "The Rust Project Developers" ];
    sha256 = "0hfdh94shvxsdd6jiri0z47v6cyhbsj64w3f39jxvm40zbc4izl4";
    features = mkFeatures (features."libc"."0.2.35" or {});
  };
  features_.libc."0.2.35" = deps: f: updateFeatures f (rec {
    libc = fold recursiveUpdate {} [
      { "0.2.35"."use_std" =
        (f.libc."0.2.35"."use_std" or false) ||
        (f.libc."0.2.35".default or false) ||
        (libc."0.2.35"."default" or false); }
      { "0.2.35".default = (f.libc."0.2.35".default or true); }
    ];
  }) [];


# end
# log-0.3.9

  crates.log."0.3.9" = deps: { features?(features_.log."0.3.9" deps {}) }: buildRustCrate {
    crateName = "log";
    version = "0.3.9";
    description = "A lightweight logging facade for Rust\n";
    authors = [ "The Rust Project Developers" ];
    sha256 = "19i9pwp7lhaqgzangcpw00kc3zsgcqcx84crv07xgz3v7d3kvfa2";
    dependencies = mapFeatures features ([
      (crates."log"."${deps."log"."0.3.9"."log"}" deps)
    ]);
    features = mkFeatures (features."log"."0.3.9" or {});
  };
  features_.log."0.3.9" = deps: f: updateFeatures f (rec {
    log = fold recursiveUpdate {} [
      { "${deps.log."0.3.9".log}"."max_level_debug" =
        (f.log."${deps.log."0.3.9".log}"."max_level_debug" or false) ||
        (log."0.3.9"."max_level_debug" or false) ||
        (f."log"."0.3.9"."max_level_debug" or false); }
      { "${deps.log."0.3.9".log}"."max_level_error" =
        (f.log."${deps.log."0.3.9".log}"."max_level_error" or false) ||
        (log."0.3.9"."max_level_error" or false) ||
        (f."log"."0.3.9"."max_level_error" or false); }
      { "${deps.log."0.3.9".log}"."max_level_info" =
        (f.log."${deps.log."0.3.9".log}"."max_level_info" or false) ||
        (log."0.3.9"."max_level_info" or false) ||
        (f."log"."0.3.9"."max_level_info" or false); }
      { "${deps.log."0.3.9".log}"."max_level_off" =
        (f.log."${deps.log."0.3.9".log}"."max_level_off" or false) ||
        (log."0.3.9"."max_level_off" or false) ||
        (f."log"."0.3.9"."max_level_off" or false); }
      { "${deps.log."0.3.9".log}"."max_level_trace" =
        (f.log."${deps.log."0.3.9".log}"."max_level_trace" or false) ||
        (log."0.3.9"."max_level_trace" or false) ||
        (f."log"."0.3.9"."max_level_trace" or false); }
      { "${deps.log."0.3.9".log}"."max_level_warn" =
        (f.log."${deps.log."0.3.9".log}"."max_level_warn" or false) ||
        (log."0.3.9"."max_level_warn" or false) ||
        (f."log"."0.3.9"."max_level_warn" or false); }
      { "${deps.log."0.3.9".log}"."release_max_level_debug" =
        (f.log."${deps.log."0.3.9".log}"."release_max_level_debug" or false) ||
        (log."0.3.9"."release_max_level_debug" or false) ||
        (f."log"."0.3.9"."release_max_level_debug" or false); }
      { "${deps.log."0.3.9".log}"."release_max_level_error" =
        (f.log."${deps.log."0.3.9".log}"."release_max_level_error" or false) ||
        (log."0.3.9"."release_max_level_error" or false) ||
        (f."log"."0.3.9"."release_max_level_error" or false); }
      { "${deps.log."0.3.9".log}"."release_max_level_info" =
        (f.log."${deps.log."0.3.9".log}"."release_max_level_info" or false) ||
        (log."0.3.9"."release_max_level_info" or false) ||
        (f."log"."0.3.9"."release_max_level_info" or false); }
      { "${deps.log."0.3.9".log}"."release_max_level_off" =
        (f.log."${deps.log."0.3.9".log}"."release_max_level_off" or false) ||
        (log."0.3.9"."release_max_level_off" or false) ||
        (f."log"."0.3.9"."release_max_level_off" or false); }
      { "${deps.log."0.3.9".log}"."release_max_level_trace" =
        (f.log."${deps.log."0.3.9".log}"."release_max_level_trace" or false) ||
        (log."0.3.9"."release_max_level_trace" or false) ||
        (f."log"."0.3.9"."release_max_level_trace" or false); }
      { "${deps.log."0.3.9".log}"."release_max_level_warn" =
        (f.log."${deps.log."0.3.9".log}"."release_max_level_warn" or false) ||
        (log."0.3.9"."release_max_level_warn" or false) ||
        (f."log"."0.3.9"."release_max_level_warn" or false); }
      { "${deps.log."0.3.9".log}"."std" =
        (f.log."${deps.log."0.3.9".log}"."std" or false) ||
        (log."0.3.9"."use_std" or false) ||
        (f."log"."0.3.9"."use_std" or false); }
      { "${deps.log."0.3.9".log}".default = true; }
      { "0.3.9"."use_std" =
        (f.log."0.3.9"."use_std" or false) ||
        (f.log."0.3.9".default or false) ||
        (log."0.3.9"."default" or false); }
      { "0.3.9".default = (f.log."0.3.9".default or true); }
    ];
  }) [
    (features_.log."${deps."log"."0.3.9"."log"}" deps)
  ];


# end
# log-0.4.1

  crates.log."0.4.1" = deps: { features?(features_.log."0.4.1" deps {}) }: buildRustCrate {
    crateName = "log";
    version = "0.4.1";
    description = "A lightweight logging facade for Rust\n";
    authors = [ "The Rust Project Developers" ];
    sha256 = "01vm8yy3wngvyj6qp1x3xpcb4xq7v67yn9l7fsma8kz28mliz90d";
    dependencies = mapFeatures features ([
      (crates."cfg_if"."${deps."log"."0.4.1"."cfg_if"}" deps)
    ]);
    features = mkFeatures (features."log"."0.4.1" or {});
  };
  features_.log."0.4.1" = deps: f: updateFeatures f (rec {
    cfg_if."${deps.log."0.4.1".cfg_if}".default = true;
    log."0.4.1".default = (f.log."0.4.1".default or true);
  }) [
    (features_.cfg_if."${deps."log"."0.4.1"."cfg_if"}" deps)
  ];


# end
# mime-0.3.5

  crates.mime."0.3.5" = deps: { features?(features_.mime."0.3.5" deps {}) }: buildRustCrate {
    crateName = "mime";
    version = "0.3.5";
    description = "Strongly Typed Mimes";
    authors = [ "Sean McArthur <sean@seanmonstar.com>" ];
    sha256 = "032y8q6h7yzmji1cznw04grbi0inbl1m6rcwgsqfwiw8gflcgy0l";
    dependencies = mapFeatures features ([
      (crates."unicase"."${deps."mime"."0.3.5"."unicase"}" deps)
    ]);
  };
  features_.mime."0.3.5" = deps: f: updateFeatures f (rec {
    mime."0.3.5".default = (f.mime."0.3.5".default or true);
    unicase."${deps.mime."0.3.5".unicase}".default = true;
  }) [
    (features_.unicase."${deps."mime"."0.3.5"."unicase"}" deps)
  ];


# end
# mio-0.6.11

  crates.mio."0.6.11" = deps: { features?(features_.mio."0.6.11" deps {}) }: buildRustCrate {
    crateName = "mio";
    version = "0.6.11";
    description = "Lightweight non-blocking IO";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "0maafa27rard6r62rc7iv5mcn2g0vvv6kw5as1kbf7mr4q1ph6sm";
    dependencies = mapFeatures features ([
      (crates."iovec"."${deps."mio"."0.6.11"."iovec"}" deps)
      (crates."lazycell"."${deps."mio"."0.6.11"."lazycell"}" deps)
      (crates."log"."${deps."mio"."0.6.11"."log"}" deps)
      (crates."net2"."${deps."mio"."0.6.11"."net2"}" deps)
      (crates."slab"."${deps."mio"."0.6.11"."slab"}" deps)
    ])
      ++ (if kernel == "fuchsia" then mapFeatures features ([
      (crates."fuchsia_zircon"."${deps."mio"."0.6.11"."fuchsia_zircon"}" deps)
      (crates."fuchsia_zircon_sys"."${deps."mio"."0.6.11"."fuchsia_zircon_sys"}" deps)
    ]) else [])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."mio"."0.6.11"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."kernel32_sys"."${deps."mio"."0.6.11"."kernel32_sys"}" deps)
      (crates."miow"."${deps."mio"."0.6.11"."miow"}" deps)
      (crates."winapi"."${deps."mio"."0.6.11"."winapi"}" deps)
    ]) else []);
    features = mkFeatures (features."mio"."0.6.11" or {});
  };
  features_.mio."0.6.11" = deps: f: updateFeatures f (rec {
    fuchsia_zircon."${deps.mio."0.6.11".fuchsia_zircon}".default = true;
    fuchsia_zircon_sys."${deps.mio."0.6.11".fuchsia_zircon_sys}".default = true;
    iovec."${deps.mio."0.6.11".iovec}".default = true;
    kernel32_sys."${deps.mio."0.6.11".kernel32_sys}".default = true;
    lazycell."${deps.mio."0.6.11".lazycell}".default = true;
    libc."${deps.mio."0.6.11".libc}".default = true;
    log."${deps.mio."0.6.11".log}".default = true;
    mio = fold recursiveUpdate {} [
      { "0.6.11"."with-deprecated" =
        (f.mio."0.6.11"."with-deprecated" or false) ||
        (f.mio."0.6.11".default or false) ||
        (mio."0.6.11"."default" or false); }
      { "0.6.11".default = (f.mio."0.6.11".default or true); }
    ];
    miow."${deps.mio."0.6.11".miow}".default = true;
    net2."${deps.mio."0.6.11".net2}".default = true;
    slab."${deps.mio."0.6.11".slab}".default = true;
    winapi."${deps.mio."0.6.11".winapi}".default = true;
  }) [
    (features_.iovec."${deps."mio"."0.6.11"."iovec"}" deps)
    (features_.lazycell."${deps."mio"."0.6.11"."lazycell"}" deps)
    (features_.log."${deps."mio"."0.6.11"."log"}" deps)
    (features_.net2."${deps."mio"."0.6.11"."net2"}" deps)
    (features_.slab."${deps."mio"."0.6.11"."slab"}" deps)
    (features_.fuchsia_zircon."${deps."mio"."0.6.11"."fuchsia_zircon"}" deps)
    (features_.fuchsia_zircon_sys."${deps."mio"."0.6.11"."fuchsia_zircon_sys"}" deps)
    (features_.libc."${deps."mio"."0.6.11"."libc"}" deps)
    (features_.kernel32_sys."${deps."mio"."0.6.11"."kernel32_sys"}" deps)
    (features_.miow."${deps."mio"."0.6.11"."miow"}" deps)
    (features_.winapi."${deps."mio"."0.6.11"."winapi"}" deps)
  ];


# end
# miow-0.2.1

  crates.miow."0.2.1" = deps: { features?(features_.miow."0.2.1" deps {}) }: buildRustCrate {
    crateName = "miow";
    version = "0.2.1";
    description = "A zero overhead I/O library for Windows, focusing on IOCP and Async I/O\nabstractions.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "14f8zkc6ix7mkyis1vsqnim8m29b6l55abkba3p2yz7j1ibcvrl0";
    dependencies = mapFeatures features ([
      (crates."kernel32_sys"."${deps."miow"."0.2.1"."kernel32_sys"}" deps)
      (crates."net2"."${deps."miow"."0.2.1"."net2"}" deps)
      (crates."winapi"."${deps."miow"."0.2.1"."winapi"}" deps)
      (crates."ws2_32_sys"."${deps."miow"."0.2.1"."ws2_32_sys"}" deps)
    ]);
  };
  features_.miow."0.2.1" = deps: f: updateFeatures f (rec {
    kernel32_sys."${deps.miow."0.2.1".kernel32_sys}".default = true;
    miow."0.2.1".default = (f.miow."0.2.1".default or true);
    net2."${deps.miow."0.2.1".net2}".default = (f.net2."${deps.miow."0.2.1".net2}".default or false);
    winapi."${deps.miow."0.2.1".winapi}".default = true;
    ws2_32_sys."${deps.miow."0.2.1".ws2_32_sys}".default = true;
  }) [
    (features_.kernel32_sys."${deps."miow"."0.2.1"."kernel32_sys"}" deps)
    (features_.net2."${deps."miow"."0.2.1"."net2"}" deps)
    (features_.winapi."${deps."miow"."0.2.1"."winapi"}" deps)
    (features_.ws2_32_sys."${deps."miow"."0.2.1"."ws2_32_sys"}" deps)
  ];


# end
# net2-0.2.31

  crates.net2."0.2.31" = deps: { features?(features_.net2."0.2.31" deps {}) }: buildRustCrate {
    crateName = "net2";
    version = "0.2.31";
    description = "Extensions to the standard library's networking types as proposed in RFC 1158.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "13mphllfcbybsdqyi1jb3kyqx65m8ch07drr59a4wb3yl89awm7y";
    dependencies = mapFeatures features ([
      (crates."cfg_if"."${deps."net2"."0.2.31"."cfg_if"}" deps)
    ])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."net2"."0.2.31"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."kernel32_sys"."${deps."net2"."0.2.31"."kernel32_sys"}" deps)
      (crates."winapi"."${deps."net2"."0.2.31"."winapi"}" deps)
      (crates."ws2_32_sys"."${deps."net2"."0.2.31"."ws2_32_sys"}" deps)
    ]) else [])
      ++ (if kernel == "i686-apple-darwin" then mapFeatures features ([
      (crates."libc"."${deps."net2"."0.2.31"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "i686-unknown-linux-gnu" then mapFeatures features ([
      (crates."libc"."${deps."net2"."0.2.31"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "x86_64-apple-darwin" then mapFeatures features ([
      (crates."libc"."${deps."net2"."0.2.31"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "x86_64-unknown-linux-gnu" then mapFeatures features ([
      (crates."libc"."${deps."net2"."0.2.31"."libc"}" deps)
    ]) else []);
    features = mkFeatures (features."net2"."0.2.31" or {});
  };
  features_.net2."0.2.31" = deps: f: updateFeatures f (rec {
    cfg_if."${deps.net2."0.2.31".cfg_if}".default = true;
    kernel32_sys."${deps.net2."0.2.31".kernel32_sys}".default = true;
    libc."${deps.net2."0.2.31".libc}".default = true;
    net2 = fold recursiveUpdate {} [
      { "0.2.31"."duration" =
        (f.net2."0.2.31"."duration" or false) ||
        (f.net2."0.2.31".default or false) ||
        (net2."0.2.31"."default" or false); }
      { "0.2.31".default = (f.net2."0.2.31".default or true); }
    ];
    winapi."${deps.net2."0.2.31".winapi}".default = true;
    ws2_32_sys."${deps.net2."0.2.31".ws2_32_sys}".default = true;
  }) [
    (features_.cfg_if."${deps."net2"."0.2.31"."cfg_if"}" deps)
    (features_.libc."${deps."net2"."0.2.31"."libc"}" deps)
    (features_.kernel32_sys."${deps."net2"."0.2.31"."kernel32_sys"}" deps)
    (features_.winapi."${deps."net2"."0.2.31"."winapi"}" deps)
    (features_.ws2_32_sys."${deps."net2"."0.2.31"."ws2_32_sys"}" deps)
    (features_.libc."${deps."net2"."0.2.31"."libc"}" deps)
    (features_.libc."${deps."net2"."0.2.31"."libc"}" deps)
    (features_.libc."${deps."net2"."0.2.31"."libc"}" deps)
    (features_.libc."${deps."net2"."0.2.31"."libc"}" deps)
  ];


# end
# num_cpus-1.8.0

  crates.num_cpus."1.8.0" = deps: { features?(features_.num_cpus."1.8.0" deps {}) }: buildRustCrate {
    crateName = "num_cpus";
    version = "1.8.0";
    description = "Get the number of CPUs on a machine.";
    authors = [ "Sean McArthur <sean@seanmonstar.com>" ];
    sha256 = "1y6qnd9r8ga6y8mvlabdrr73nc8cshjjlzbvnanzyj9b8zzkfwk2";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."num_cpus"."1.8.0"."libc"}" deps)
    ]);
  };
  features_.num_cpus."1.8.0" = deps: f: updateFeatures f (rec {
    libc."${deps.num_cpus."1.8.0".libc}".default = true;
    num_cpus."1.8.0".default = (f.num_cpus."1.8.0".default or true);
  }) [
    (features_.libc."${deps."num_cpus"."1.8.0"."libc"}" deps)
  ];


# end
# percent-encoding-1.0.1

  crates.percent_encoding."1.0.1" = deps: { features?(features_.percent_encoding."1.0.1" deps {}) }: buildRustCrate {
    crateName = "percent-encoding";
    version = "1.0.1";
    description = "Percent encoding and decoding";
    authors = [ "The rust-url developers" ];
    sha256 = "04ahrp7aw4ip7fmadb0bknybmkfav0kk0gw4ps3ydq5w6hr0ib5i";
    libPath = "lib.rs";
  };
  features_.percent_encoding."1.0.1" = deps: f: updateFeatures f (rec {
    percent_encoding."1.0.1".default = (f.percent_encoding."1.0.1".default or true);
  }) [];


# end
# proc-macro2-0.4.6

  crates.proc_macro2."0.4.6" = deps: { features?(features_.proc_macro2."0.4.6" deps {}) }: buildRustCrate {
    crateName = "proc-macro2";
    version = "0.4.6";
    description = "A stable implementation of the upcoming new `proc_macro` API. Comes with an\noption, off by default, to also reimplement itself in terms of the upstream\nunstable API.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "0lnxcavz5nqxypjyz6isffqiyxb3h0021nkn8djsl33a4qd4pxv6";
    dependencies = mapFeatures features ([
      (crates."unicode_xid"."${deps."proc_macro2"."0.4.6"."unicode_xid"}" deps)
    ]);
    features = mkFeatures (features."proc_macro2"."0.4.6" or {});
  };
  features_.proc_macro2."0.4.6" = deps: f: updateFeatures f (rec {
    proc_macro2 = fold recursiveUpdate {} [
      { "0.4.6"."proc-macro" =
        (f.proc_macro2."0.4.6"."proc-macro" or false) ||
        (f.proc_macro2."0.4.6".default or false) ||
        (proc_macro2."0.4.6"."default" or false) ||
        (f.proc_macro2."0.4.6".nightly or false) ||
        (proc_macro2."0.4.6"."nightly" or false); }
      { "0.4.6".default = (f.proc_macro2."0.4.6".default or true); }
    ];
    unicode_xid."${deps.proc_macro2."0.4.6".unicode_xid}".default = true;
  }) [
    (features_.unicode_xid."${deps."proc_macro2"."0.4.6"."unicode_xid"}" deps)
  ];


# end
# prometheus-0.3.6

  crates.prometheus."0.3.6" = deps: { features?(features_.prometheus."0.3.6" deps {}) }: buildRustCrate {
    crateName = "prometheus";
    version = "0.3.6";
    description = "Prometheus instrumentation library for Rust applications.";
    authors = [ "overvenus@gmail.com" "siddontang@gmail.com" ];
    sha256 = "19klm7466mrwpml87a4xi5qrwrsbm55ah0xc5d6a2n18d9fxx0wa";
    dependencies = mapFeatures features ([
      (crates."cfg_if"."${deps."prometheus"."0.3.6"."cfg_if"}" deps)
      (crates."fnv"."${deps."prometheus"."0.3.6"."fnv"}" deps)
      (crates."lazy_static"."${deps."prometheus"."0.3.6"."lazy_static"}" deps)
      (crates."protobuf"."${deps."prometheus"."0.3.6"."protobuf"}" deps)
      (crates."quick_error"."${deps."prometheus"."0.3.6"."quick_error"}" deps)
      (crates."spin"."${deps."prometheus"."0.3.6"."spin"}" deps)
    ])
      ++ (if kernel == "linux" then mapFeatures features ([
]) else []);
    features = mkFeatures (features."prometheus"."0.3.6" or {});
  };
  features_.prometheus."0.3.6" = deps: f: updateFeatures f (rec {
    cfg_if."${deps.prometheus."0.3.6".cfg_if}".default = true;
    fnv."${deps.prometheus."0.3.6".fnv}".default = true;
    lazy_static."${deps.prometheus."0.3.6".lazy_static}".default = true;
    prometheus = fold recursiveUpdate {} [
      { "0.3.6"."clippy" =
        (f.prometheus."0.3.6"."clippy" or false) ||
        (f.prometheus."0.3.6".dev or false) ||
        (prometheus."0.3.6"."dev" or false); }
      { "0.3.6"."hyper" =
        (f.prometheus."0.3.6"."hyper" or false) ||
        (f.prometheus."0.3.6".push or false) ||
        (prometheus."0.3.6"."push" or false); }
      { "0.3.6"."libc" =
        (f.prometheus."0.3.6"."libc" or false) ||
        (f.prometheus."0.3.6".nightly or false) ||
        (prometheus."0.3.6"."nightly" or false) ||
        (f.prometheus."0.3.6".process or false) ||
        (prometheus."0.3.6"."process" or false) ||
        (f.prometheus."0.3.6".push or false) ||
        (prometheus."0.3.6"."push" or false); }
      { "0.3.6"."procinfo" =
        (f.prometheus."0.3.6"."procinfo" or false) ||
        (f.prometheus."0.3.6".process or false) ||
        (prometheus."0.3.6"."process" or false); }
      { "0.3.6".default = (f.prometheus."0.3.6".default or true); }
    ];
    protobuf."${deps.prometheus."0.3.6".protobuf}".default = true;
    quick_error."${deps.prometheus."0.3.6".quick_error}".default = true;
    spin = fold recursiveUpdate {} [
      { "${deps.prometheus."0.3.6".spin}"."unstable" =
        (f.spin."${deps.prometheus."0.3.6".spin}"."unstable" or false) ||
        (prometheus."0.3.6"."nightly" or false) ||
        (f."prometheus"."0.3.6"."nightly" or false); }
      { "${deps.prometheus."0.3.6".spin}".default = (f.spin."${deps.prometheus."0.3.6".spin}".default or false); }
    ];
  }) [
    (features_.cfg_if."${deps."prometheus"."0.3.6"."cfg_if"}" deps)
    (features_.fnv."${deps."prometheus"."0.3.6"."fnv"}" deps)
    (features_.lazy_static."${deps."prometheus"."0.3.6"."lazy_static"}" deps)
    (features_.protobuf."${deps."prometheus"."0.3.6"."protobuf"}" deps)
    (features_.quick_error."${deps."prometheus"."0.3.6"."quick_error"}" deps)
    (features_.spin."${deps."prometheus"."0.3.6"."spin"}" deps)
  ];


# end
# protobuf-1.4.3

  crates.protobuf."1.4.3" = deps: { features?(features_.protobuf."1.4.3" deps {}) }: buildRustCrate {
    crateName = "protobuf";
    version = "1.4.3";
    description = "Rust implementation of Google protocol buffers\n";
    authors = [ "Stepan Koltsov <stepan.koltsov@gmail.com>" ];
    sha256 = "093fczpx523lm6d7xr5d4mqs88891ay6wk951yck3cavsz35z00b";
    crateBin =
      [{  name = "protoc-gen-rust";  path = "protoc-gen-rust.rs"; }] ++
      [{  name = "protobuf-bin-gen-rust-do-not-use";  path = "protobuf-bin-gen-rust-do-not-use.rs"; }];
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."protobuf"."1.4.3" or {});
  };
  features_.protobuf."1.4.3" = deps: f: updateFeatures f (rec {
    protobuf = fold recursiveUpdate {} [
      { "1.4.3"."bytes" =
        (f.protobuf."1.4.3"."bytes" or false) ||
        (f.protobuf."1.4.3".with-bytes or false) ||
        (protobuf."1.4.3"."with-bytes" or false); }
      { "1.4.3".default = (f.protobuf."1.4.3".default or true); }
    ];
  }) [];


# end
# quick-error-0.2.2

  crates.quick_error."0.2.2" = deps: { features?(features_.quick_error."0.2.2" deps {}) }: buildRustCrate {
    crateName = "quick-error";
    version = "0.2.2";
    description = "    A macro which makes error types pleasant to write.\n";
    authors = [ "Paul Colomiets <paul@colomiets.name>" "Colin Kiegel <kiegel@gmx.de>" ];
    sha256 = "0r1f4ps998y779qwvnmmxhjq00qh5wxg3m5inswfawg0vr2732db";
  };
  features_.quick_error."0.2.2" = deps: f: updateFeatures f (rec {
    quick_error."0.2.2".default = (f.quick_error."0.2.2".default or true);
  }) [];


# end
# quote-0.3.15

  crates.quote."0.3.15" = deps: { features?(features_.quote."0.3.15" deps {}) }: buildRustCrate {
    crateName = "quote";
    version = "0.3.15";
    description = "Quasi-quoting macro quote!(...)";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "09il61jv4kd1360spaj46qwyl21fv1qz18fsv2jra8wdnlgl5jsg";
  };
  features_.quote."0.3.15" = deps: f: updateFeatures f (rec {
    quote."0.3.15".default = (f.quote."0.3.15".default or true);
  }) [];


# end
# quote-0.6.3

  crates.quote."0.6.3" = deps: { features?(features_.quote."0.6.3" deps {}) }: buildRustCrate {
    crateName = "quote";
    version = "0.6.3";
    description = "Quasi-quoting macro quote!(...)";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "1bqm3fjww2ivnshzxg54nnn1dxrx1cmvpjc5d50xjvjfg9xjb4b5";
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."quote"."0.6.3"."proc_macro2"}" deps)
    ]);
    features = mkFeatures (features."quote"."0.6.3" or {});
  };
  features_.quote."0.6.3" = deps: f: updateFeatures f (rec {
    proc_macro2 = fold recursiveUpdate {} [
      { "${deps.quote."0.6.3".proc_macro2}"."proc-macro" =
        (f.proc_macro2."${deps.quote."0.6.3".proc_macro2}"."proc-macro" or false) ||
        (quote."0.6.3"."proc-macro" or false) ||
        (f."quote"."0.6.3"."proc-macro" or false); }
      { "${deps.quote."0.6.3".proc_macro2}".default = (f.proc_macro2."${deps.quote."0.6.3".proc_macro2}".default or false); }
    ];
    quote = fold recursiveUpdate {} [
      { "0.6.3"."proc-macro" =
        (f.quote."0.6.3"."proc-macro" or false) ||
        (f.quote."0.6.3".default or false) ||
        (quote."0.6.3"."default" or false); }
      { "0.6.3".default = (f.quote."0.6.3".default or true); }
    ];
  }) [
    (features_.proc_macro2."${deps."quote"."0.6.3"."proc_macro2"}" deps)
  ];


# end
# rand-0.3.19

  crates.rand."0.3.19" = deps: { features?(features_.rand."0.3.19" deps {}) }: buildRustCrate {
    crateName = "rand";
    version = "0.3.19";
    description = "Random number generators and other randomness functionality.\n";
    authors = [ "The Rust Project Developers" ];
    sha256 = "19zx65w7rrrfnjifmjp2i80w9bc6ld7pcwnk5hmr9xszmmvhk8zp";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."rand"."0.3.19"."libc"}" deps)
    ])
      ++ (if kernel == "fuchsia" then mapFeatures features ([
      (crates."fuchsia_zircon"."${deps."rand"."0.3.19"."fuchsia_zircon"}" deps)
    ]) else []);
    features = mkFeatures (features."rand"."0.3.19" or {});
  };
  features_.rand."0.3.19" = deps: f: updateFeatures f (rec {
    fuchsia_zircon."${deps.rand."0.3.19".fuchsia_zircon}".default = true;
    libc."${deps.rand."0.3.19".libc}".default = true;
    rand = fold recursiveUpdate {} [
      { "0.3.19"."i128_support" =
        (f.rand."0.3.19"."i128_support" or false) ||
        (f.rand."0.3.19".nightly or false) ||
        (rand."0.3.19"."nightly" or false); }
      { "0.3.19".default = (f.rand."0.3.19".default or true); }
    ];
  }) [
    (features_.libc."${deps."rand"."0.3.19"."libc"}" deps)
    (features_.fuchsia_zircon."${deps."rand"."0.3.19"."fuchsia_zircon"}" deps)
  ];


# end
# redox_syscall-0.1.34

  crates.redox_syscall."0.1.34" = deps: { features?(features_.redox_syscall."0.1.34" deps {}) }: buildRustCrate {
    crateName = "redox_syscall";
    version = "0.1.34";
    description = "A Rust library to access raw Redox system calls";
    authors = [ "Jeremy Soller <jackpot51@gmail.com>" ];
    sha256 = "1n8dny2iw79igcqb1dmckq9q078sg4p5mn4wgjsfhfkdkhc196yq";
    libName = "syscall";
  };
  features_.redox_syscall."0.1.34" = deps: f: updateFeatures f (rec {
    redox_syscall."0.1.34".default = (f.redox_syscall."0.1.34".default or true);
  }) [];


# end
# redox_termios-0.1.1

  crates.redox_termios."0.1.1" = deps: { features?(features_.redox_termios."0.1.1" deps {}) }: buildRustCrate {
    crateName = "redox_termios";
    version = "0.1.1";
    description = "A Rust library to access Redox termios functions";
    authors = [ "Jeremy Soller <jackpot51@gmail.com>" ];
    sha256 = "04s6yyzjca552hdaqlvqhp3vw0zqbc304md5czyd3axh56iry8wh";
    libPath = "src/lib.rs";
    dependencies = mapFeatures features ([
      (crates."redox_syscall"."${deps."redox_termios"."0.1.1"."redox_syscall"}" deps)
    ]);
  };
  features_.redox_termios."0.1.1" = deps: f: updateFeatures f (rec {
    redox_syscall."${deps.redox_termios."0.1.1".redox_syscall}".default = true;
    redox_termios."0.1.1".default = (f.redox_termios."0.1.1".default or true);
  }) [
    (features_.redox_syscall."${deps."redox_termios"."0.1.1"."redox_syscall"}" deps)
  ];


# end
# relay-0.1.0

  crates.relay."0.1.0" = deps: { features?(features_.relay."0.1.0" deps {}) }: buildRustCrate {
    crateName = "relay";
    version = "0.1.0";
    description = "A lightweight oneshot Future channel.";
    authors = [ "Sean McArthur <sean.monstar@gmail.com>" ];
    sha256 = "1gp2qdclrphnkig7sg4ydyf3mwvdb5vgp2sijmbk115qs8lj6h6g";
    dependencies = mapFeatures features ([
      (crates."futures"."${deps."relay"."0.1.0"."futures"}" deps)
    ]);
  };
  features_.relay."0.1.0" = deps: f: updateFeatures f (rec {
    futures."${deps.relay."0.1.0".futures}".default = true;
    relay."0.1.0".default = (f.relay."0.1.0".default or true);
  }) [
    (features_.futures."${deps."relay"."0.1.0"."futures"}" deps)
  ];


# end
# rustc-demangle-0.1.5

  crates.rustc_demangle."0.1.5" = deps: { features?(features_.rustc_demangle."0.1.5" deps {}) }: buildRustCrate {
    crateName = "rustc-demangle";
    version = "0.1.5";
    description = "Rust compiler symbol demangling.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "096kkcx9j747700fhxj1s4rlwkj21pqjmvj64psdj6bakb2q13nc";
  };
  features_.rustc_demangle."0.1.5" = deps: f: updateFeatures f (rec {
    rustc_demangle."0.1.5".default = (f.rustc_demangle."0.1.5".default or true);
  }) [];


# end
# safemem-0.2.0

  crates.safemem."0.2.0" = deps: { features?(features_.safemem."0.2.0" deps {}) }: buildRustCrate {
    crateName = "safemem";
    version = "0.2.0";
    description = "Safe wrappers for memory-accessing functions, like `std::ptr::copy()`.";
    authors = [ "Austin Bonander <austin.bonander@gmail.com>" ];
    sha256 = "058m251q202n479ip1h6s91yw3plg66vsk5mpaflssn6rs5hijdm";
  };
  features_.safemem."0.2.0" = deps: f: updateFeatures f (rec {
    safemem."0.2.0".default = (f.safemem."0.2.0".default or true);
  }) [];


# end
# scoped-tls-0.1.0

  crates.scoped_tls."0.1.0" = deps: { features?(features_.scoped_tls."0.1.0" deps {}) }: buildRustCrate {
    crateName = "scoped-tls";
    version = "0.1.0";
    description = "Library implementation of the standard library's old `scoped_thread_local!`\nmacro for providing scoped access to thread local storage (TLS) so any type can\nbe stored into TLS.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1j8azxa15srljafrg7wc221npvxb3700sbfk6jjav0rw2zclsnf5";
  };
  features_.scoped_tls."0.1.0" = deps: f: updateFeatures f (rec {
    scoped_tls."0.1.0".default = (f.scoped_tls."0.1.0".default or true);
  }) [];


# end
# slab-0.3.0

  crates.slab."0.3.0" = deps: { features?(features_.slab."0.3.0" deps {}) }: buildRustCrate {
    crateName = "slab";
    version = "0.3.0";
    description = "Simple slab allocator";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "0y6lhjggksh57hyfd3l6p9wgv5nhvw9c6djrysq7jnalz8fih21k";
  };
  features_.slab."0.3.0" = deps: f: updateFeatures f (rec {
    slab."0.3.0".default = (f.slab."0.3.0".default or true);
  }) [];


# end
# slab-0.4.0

  crates.slab."0.4.0" = deps: { features?(features_.slab."0.4.0" deps {}) }: buildRustCrate {
    crateName = "slab";
    version = "0.4.0";
    description = "Pre-allocated storage for a uniform data type";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "1qy2vkgwqgj5z4ygdkh040n9yh1vz80v5flxb1xrvw3i4wxs7yx0";
  };
  features_.slab."0.4.0" = deps: f: updateFeatures f (rec {
    slab."0.4.0".default = (f.slab."0.4.0".default or true);
  }) [];


# end
# smallvec-0.2.1

  crates.smallvec."0.2.1" = deps: { features?(features_.smallvec."0.2.1" deps {}) }: buildRustCrate {
    crateName = "smallvec";
    version = "0.2.1";
    description = "'Small vector' optimization: store up to a small number of items on the stack";
    authors = [ "Simon Sapin <simon.sapin@exyr.org>" ];
    sha256 = "0rnsll9af52bpjngz0067dpm1ndqmh76i64a58fc118l4lvnjxw2";
    libPath = "lib.rs";
  };
  features_.smallvec."0.2.1" = deps: f: updateFeatures f (rec {
    smallvec."0.2.1".default = (f.smallvec."0.2.1".default or true);
  }) [];


# end
# spin-0.4.6

  crates.spin."0.4.6" = deps: { features?(features_.spin."0.4.6" deps {}) }: buildRustCrate {
    crateName = "spin";
    version = "0.4.6";
    description = "Synchronization primitives based on spinning.\nThey may contain data,\nThey are usable without `std`\nand static initializers are available.\n";
    authors = [ "Mathijs van de Nes <git@mathijs.vd-nes.nl>" "John Ericson <John_Ericson@Yahoo.com>" ];
    sha256 = "1mp30r3pxb38m6mszcgn6136d1r162fwcidg3y4d9rym21hmialj";
    features = mkFeatures (features."spin"."0.4.6" or {});
  };
  features_.spin."0.4.6" = deps: f: updateFeatures f (rec {
    spin = fold recursiveUpdate {} [
      { "0.4.6"."asm" =
        (f.spin."0.4.6"."asm" or false) ||
        (f.spin."0.4.6".unstable or false) ||
        (spin."0.4.6"."unstable" or false); }
      { "0.4.6"."const_fn" =
        (f.spin."0.4.6"."const_fn" or false) ||
        (f.spin."0.4.6".once or false) ||
        (spin."0.4.6"."once" or false) ||
        (f.spin."0.4.6".unstable or false) ||
        (spin."0.4.6"."unstable" or false); }
      { "0.4.6"."core_intrinsics" =
        (f.spin."0.4.6"."core_intrinsics" or false) ||
        (f.spin."0.4.6".unstable or false) ||
        (spin."0.4.6"."unstable" or false); }
      { "0.4.6"."once" =
        (f.spin."0.4.6"."once" or false) ||
        (f.spin."0.4.6".unstable or false) ||
        (spin."0.4.6"."unstable" or false); }
      { "0.4.6"."unstable" =
        (f.spin."0.4.6"."unstable" or false) ||
        (f.spin."0.4.6".default or false) ||
        (spin."0.4.6"."default" or false); }
      { "0.4.6".default = (f.spin."0.4.6".default or true); }
    ];
  }) [];


# end
# strsim-0.7.0

  crates.strsim."0.7.0" = deps: { features?(features_.strsim."0.7.0" deps {}) }: buildRustCrate {
    crateName = "strsim";
    version = "0.7.0";
    description = "Implementations of string similarity metrics.\nIncludes Hamming, Levenshtein, OSA, Damerau-Levenshtein, Jaro, and Jaro-Winkler.\n";
    authors = [ "Danny Guo <dannyguo91@gmail.com>" ];
    sha256 = "0fy0k5f2705z73mb3x9459bpcvrx4ky8jpr4zikcbiwan4bnm0iv";
  };
  features_.strsim."0.7.0" = deps: f: updateFeatures f (rec {
    strsim."0.7.0".default = (f.strsim."0.7.0".default or true);
  }) [];


# end
# structopt-0.2.10

  crates.structopt."0.2.10" = deps: { features?(features_.structopt."0.2.10" deps {}) }: buildRustCrate {
    crateName = "structopt";
    version = "0.2.10";
    description = "Parse command line argument by defining a struct.";
    authors = [ "Guillaume Pinot <texitoi@texitoi.eu>" "others" ];
    sha256 = "0bnhmx7i23a65vn0wp0rrll0rxlznlnia5kn20rip2870agmjfm8";
    dependencies = mapFeatures features ([
      (crates."clap"."${deps."structopt"."0.2.10"."clap"}" deps)
      (crates."structopt_derive"."${deps."structopt"."0.2.10"."structopt_derive"}" deps)
    ]);
    features = mkFeatures (features."structopt"."0.2.10" or {});
  };
  features_.structopt."0.2.10" = deps: f: updateFeatures f (rec {
    clap = fold recursiveUpdate {} [
      { "${deps.structopt."0.2.10".clap}"."color" =
        (f.clap."${deps.structopt."0.2.10".clap}"."color" or false) ||
        (structopt."0.2.10"."color" or false) ||
        (f."structopt"."0.2.10"."color" or false); }
      { "${deps.structopt."0.2.10".clap}"."debug" =
        (f.clap."${deps.structopt."0.2.10".clap}"."debug" or false) ||
        (structopt."0.2.10"."debug" or false) ||
        (f."structopt"."0.2.10"."debug" or false); }
      { "${deps.structopt."0.2.10".clap}"."default" =
        (f.clap."${deps.structopt."0.2.10".clap}"."default" or false) ||
        (structopt."0.2.10"."default" or false) ||
        (f."structopt"."0.2.10"."default" or false); }
      { "${deps.structopt."0.2.10".clap}"."doc" =
        (f.clap."${deps.structopt."0.2.10".clap}"."doc" or false) ||
        (structopt."0.2.10"."doc" or false) ||
        (f."structopt"."0.2.10"."doc" or false); }
      { "${deps.structopt."0.2.10".clap}"."lints" =
        (f.clap."${deps.structopt."0.2.10".clap}"."lints" or false) ||
        (structopt."0.2.10"."lints" or false) ||
        (f."structopt"."0.2.10"."lints" or false); }
      { "${deps.structopt."0.2.10".clap}"."no_cargo" =
        (f.clap."${deps.structopt."0.2.10".clap}"."no_cargo" or false) ||
        (structopt."0.2.10"."no_cargo" or false) ||
        (f."structopt"."0.2.10"."no_cargo" or false); }
      { "${deps.structopt."0.2.10".clap}"."suggestions" =
        (f.clap."${deps.structopt."0.2.10".clap}"."suggestions" or false) ||
        (structopt."0.2.10"."suggestions" or false) ||
        (f."structopt"."0.2.10"."suggestions" or false); }
      { "${deps.structopt."0.2.10".clap}"."wrap_help" =
        (f.clap."${deps.structopt."0.2.10".clap}"."wrap_help" or false) ||
        (structopt."0.2.10"."wrap_help" or false) ||
        (f."structopt"."0.2.10"."wrap_help" or false); }
      { "${deps.structopt."0.2.10".clap}"."yaml" =
        (f.clap."${deps.structopt."0.2.10".clap}"."yaml" or false) ||
        (structopt."0.2.10"."yaml" or false) ||
        (f."structopt"."0.2.10"."yaml" or false); }
      { "${deps.structopt."0.2.10".clap}".default = (f.clap."${deps.structopt."0.2.10".clap}".default or false); }
    ];
    structopt."0.2.10".default = (f.structopt."0.2.10".default or true);
    structopt_derive = fold recursiveUpdate {} [
      { "${deps.structopt."0.2.10".structopt_derive}"."nightly" =
        (f.structopt_derive."${deps.structopt."0.2.10".structopt_derive}"."nightly" or false) ||
        (structopt."0.2.10"."nightly" or false) ||
        (f."structopt"."0.2.10"."nightly" or false); }
      { "${deps.structopt."0.2.10".structopt_derive}".default = true; }
    ];
  }) [
    (features_.clap."${deps."structopt"."0.2.10"."clap"}" deps)
    (features_.structopt_derive."${deps."structopt"."0.2.10"."structopt_derive"}" deps)
  ];


# end
# structopt-derive-0.2.10

  crates.structopt_derive."0.2.10" = deps: { features?(features_.structopt_derive."0.2.10" deps {}) }: buildRustCrate {
    crateName = "structopt-derive";
    version = "0.2.10";
    description = "Parse command line argument by defining a struct, derive crate.";
    authors = [ "Guillaume Pinot <texitoi@texitoi.eu>" ];
    sha256 = "1sck1szr077c2sb7ri896gyhycicbwzi2x7yx3zmy6r1m42l39n0";
    procMacro = true;
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."structopt_derive"."0.2.10"."proc_macro2"}" deps)
      (crates."quote"."${deps."structopt_derive"."0.2.10"."quote"}" deps)
      (crates."syn"."${deps."structopt_derive"."0.2.10"."syn"}" deps)
    ]);
    features = mkFeatures (features."structopt_derive"."0.2.10" or {});
  };
  features_.structopt_derive."0.2.10" = deps: f: updateFeatures f (rec {
    proc_macro2 = fold recursiveUpdate {} [
      { "${deps.structopt_derive."0.2.10".proc_macro2}"."nightly" =
        (f.proc_macro2."${deps.structopt_derive."0.2.10".proc_macro2}"."nightly" or false) ||
        (structopt_derive."0.2.10"."nightly" or false) ||
        (f."structopt_derive"."0.2.10"."nightly" or false); }
      { "${deps.structopt_derive."0.2.10".proc_macro2}".default = true; }
    ];
    quote."${deps.structopt_derive."0.2.10".quote}".default = true;
    structopt_derive."0.2.10".default = (f.structopt_derive."0.2.10".default or true);
    syn."${deps.structopt_derive."0.2.10".syn}".default = true;
  }) [
    (features_.proc_macro2."${deps."structopt_derive"."0.2.10"."proc_macro2"}" deps)
    (features_.quote."${deps."structopt_derive"."0.2.10"."quote"}" deps)
    (features_.syn."${deps."structopt_derive"."0.2.10"."syn"}" deps)
  ];


# end
# syn-0.11.11

  crates.syn."0.11.11" = deps: { features?(features_.syn."0.11.11" deps {}) }: buildRustCrate {
    crateName = "syn";
    version = "0.11.11";
    description = "Nom parser for Rust source code";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "0yw8ng7x1dn5a6ykg0ib49y7r9nhzgpiq2989rqdp7rdz3n85502";
    dependencies = mapFeatures features ([
    ]
      ++ (if features.syn."0.11.11".quote or false then [ (crates.quote."${deps."syn"."0.11.11".quote}" deps) ] else [])
      ++ (if features.syn."0.11.11".synom or false then [ (crates.synom."${deps."syn"."0.11.11".synom}" deps) ] else [])
      ++ (if features.syn."0.11.11".unicode-xid or false then [ (crates.unicode_xid."${deps."syn"."0.11.11".unicode_xid}" deps) ] else []));
    features = mkFeatures (features."syn"."0.11.11" or {});
  };
  features_.syn."0.11.11" = deps: f: updateFeatures f (rec {
    quote."${deps.syn."0.11.11".quote}".default = true;
    syn = fold recursiveUpdate {} [
      { "0.11.11"."parsing" =
        (f.syn."0.11.11"."parsing" or false) ||
        (f.syn."0.11.11".default or false) ||
        (syn."0.11.11"."default" or false); }
      { "0.11.11"."printing" =
        (f.syn."0.11.11"."printing" or false) ||
        (f.syn."0.11.11".default or false) ||
        (syn."0.11.11"."default" or false); }
      { "0.11.11"."quote" =
        (f.syn."0.11.11"."quote" or false) ||
        (f.syn."0.11.11".printing or false) ||
        (syn."0.11.11"."printing" or false); }
      { "0.11.11"."synom" =
        (f.syn."0.11.11"."synom" or false) ||
        (f.syn."0.11.11".parsing or false) ||
        (syn."0.11.11"."parsing" or false); }
      { "0.11.11"."unicode-xid" =
        (f.syn."0.11.11"."unicode-xid" or false) ||
        (f.syn."0.11.11".parsing or false) ||
        (syn."0.11.11"."parsing" or false); }
      { "0.11.11".default = (f.syn."0.11.11".default or true); }
    ];
    synom."${deps.syn."0.11.11".synom}".default = true;
    unicode_xid."${deps.syn."0.11.11".unicode_xid}".default = true;
  }) [
    (features_.quote."${deps."syn"."0.11.11"."quote"}" deps)
    (features_.synom."${deps."syn"."0.11.11"."synom"}" deps)
    (features_.unicode_xid."${deps."syn"."0.11.11"."unicode_xid"}" deps)
  ];


# end
# syn-0.14.2

  crates.syn."0.14.2" = deps: { features?(features_.syn."0.14.2" deps {}) }: buildRustCrate {
    crateName = "syn";
    version = "0.14.2";
    description = "Nom parser for Rust source code";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "1p9wa5h8p3djkhjrjc5bsbmkpylig3h5r0kkrkgv7rpfb4rpzvmp";
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."syn"."0.14.2"."proc_macro2"}" deps)
      (crates."unicode_xid"."${deps."syn"."0.14.2"."unicode_xid"}" deps)
    ]
      ++ (if features.syn."0.14.2".quote or false then [ (crates.quote."${deps."syn"."0.14.2".quote}" deps) ] else []));
    features = mkFeatures (features."syn"."0.14.2" or {});
  };
  features_.syn."0.14.2" = deps: f: updateFeatures f (rec {
    proc_macro2 = fold recursiveUpdate {} [
      { "${deps.syn."0.14.2".proc_macro2}"."proc-macro" =
        (f.proc_macro2."${deps.syn."0.14.2".proc_macro2}"."proc-macro" or false) ||
        (syn."0.14.2"."proc-macro" or false) ||
        (f."syn"."0.14.2"."proc-macro" or false); }
      { "${deps.syn."0.14.2".proc_macro2}".default = (f.proc_macro2."${deps.syn."0.14.2".proc_macro2}".default or false); }
    ];
    quote = fold recursiveUpdate {} [
      { "${deps.syn."0.14.2".quote}"."proc-macro" =
        (f.quote."${deps.syn."0.14.2".quote}"."proc-macro" or false) ||
        (syn."0.14.2"."proc-macro" or false) ||
        (f."syn"."0.14.2"."proc-macro" or false); }
      { "${deps.syn."0.14.2".quote}".default = (f.quote."${deps.syn."0.14.2".quote}".default or false); }
    ];
    syn = fold recursiveUpdate {} [
      { "0.14.2"."clone-impls" =
        (f.syn."0.14.2"."clone-impls" or false) ||
        (f.syn."0.14.2".default or false) ||
        (syn."0.14.2"."default" or false); }
      { "0.14.2"."derive" =
        (f.syn."0.14.2"."derive" or false) ||
        (f.syn."0.14.2".default or false) ||
        (syn."0.14.2"."default" or false); }
      { "0.14.2"."parsing" =
        (f.syn."0.14.2"."parsing" or false) ||
        (f.syn."0.14.2".default or false) ||
        (syn."0.14.2"."default" or false); }
      { "0.14.2"."printing" =
        (f.syn."0.14.2"."printing" or false) ||
        (f.syn."0.14.2".default or false) ||
        (syn."0.14.2"."default" or false); }
      { "0.14.2"."proc-macro" =
        (f.syn."0.14.2"."proc-macro" or false) ||
        (f.syn."0.14.2".default or false) ||
        (syn."0.14.2"."default" or false); }
      { "0.14.2"."quote" =
        (f.syn."0.14.2"."quote" or false) ||
        (f.syn."0.14.2".printing or false) ||
        (syn."0.14.2"."printing" or false); }
      { "0.14.2".default = (f.syn."0.14.2".default or true); }
    ];
    unicode_xid."${deps.syn."0.14.2".unicode_xid}".default = true;
  }) [
    (features_.proc_macro2."${deps."syn"."0.14.2"."proc_macro2"}" deps)
    (features_.quote."${deps."syn"."0.14.2"."quote"}" deps)
    (features_.unicode_xid."${deps."syn"."0.14.2"."unicode_xid"}" deps)
  ];


# end
# synom-0.11.3

  crates.synom."0.11.3" = deps: { features?(features_.synom."0.11.3" deps {}) }: buildRustCrate {
    crateName = "synom";
    version = "0.11.3";
    description = "Stripped-down Nom parser used by Syn";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "1l6d1s9qjfp6ng2s2z8219igvlv7gyk8gby97sdykqc1r93d8rhc";
    dependencies = mapFeatures features ([
      (crates."unicode_xid"."${deps."synom"."0.11.3"."unicode_xid"}" deps)
    ]);
  };
  features_.synom."0.11.3" = deps: f: updateFeatures f (rec {
    synom."0.11.3".default = (f.synom."0.11.3".default or true);
    unicode_xid."${deps.synom."0.11.3".unicode_xid}".default = true;
  }) [
    (features_.unicode_xid."${deps."synom"."0.11.3"."unicode_xid"}" deps)
  ];


# end
# synstructure-0.6.1

  crates.synstructure."0.6.1" = deps: { features?(features_.synstructure."0.6.1" deps {}) }: buildRustCrate {
    crateName = "synstructure";
    version = "0.6.1";
    description = "expand_substructure-like helpers for syn macros 1.1 derive macros";
    authors = [ "Michael Layzell <michael@thelayzells.com>" ];
    sha256 = "1xnyw58va9zcqi4vvpnmpllacdj2a0mvy0cbd698izmr4qs92xlk";
    dependencies = mapFeatures features ([
      (crates."quote"."${deps."synstructure"."0.6.1"."quote"}" deps)
      (crates."syn"."${deps."synstructure"."0.6.1"."syn"}" deps)
    ]);
    features = mkFeatures (features."synstructure"."0.6.1" or {});
  };
  features_.synstructure."0.6.1" = deps: f: updateFeatures f (rec {
    quote."${deps.synstructure."0.6.1".quote}".default = true;
    syn = fold recursiveUpdate {} [
      { "${deps.synstructure."0.6.1".syn}"."visit" = true; }
      { "${deps.synstructure."0.6.1".syn}".default = true; }
    ];
    synstructure."0.6.1".default = (f.synstructure."0.6.1".default or true);
  }) [
    (features_.quote."${deps."synstructure"."0.6.1"."quote"}" deps)
    (features_.syn."${deps."synstructure"."0.6.1"."syn"}" deps)
  ];


# end
# take-0.1.0

  crates.take."0.1.0" = deps: { features?(features_.take."0.1.0" deps {}) }: buildRustCrate {
    crateName = "take";
    version = "0.1.0";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "17rfh39di5n8w9aghpic2r94cndi3dr04l60nkjylmxfxr3iwlhd";
  };
  features_.take."0.1.0" = deps: f: updateFeatures f (rec {
    take."0.1.0".default = (f.take."0.1.0".default or true);
  }) [];


# end
# termion-1.5.1

  crates.termion."1.5.1" = deps: { features?(features_.termion."1.5.1" deps {}) }: buildRustCrate {
    crateName = "termion";
    version = "1.5.1";
    description = "A bindless library for manipulating terminals.";
    authors = [ "ticki <Ticki@users.noreply.github.com>" "gycos <alexandre.bury@gmail.com>" "IGI-111 <igi-111@protonmail.com>" ];
    sha256 = "02gq4vd8iws1f3gjrgrgpajsk2bk43nds5acbbb4s8dvrdvr8nf1";
    dependencies = (if !(kernel == "redox") then mapFeatures features ([
      (crates."libc"."${deps."termion"."1.5.1"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "redox" then mapFeatures features ([
      (crates."redox_syscall"."${deps."termion"."1.5.1"."redox_syscall"}" deps)
      (crates."redox_termios"."${deps."termion"."1.5.1"."redox_termios"}" deps)
    ]) else []);
  };
  features_.termion."1.5.1" = deps: f: updateFeatures f (rec {
    libc."${deps.termion."1.5.1".libc}".default = true;
    redox_syscall."${deps.termion."1.5.1".redox_syscall}".default = true;
    redox_termios."${deps.termion."1.5.1".redox_termios}".default = true;
    termion."1.5.1".default = (f.termion."1.5.1".default or true);
  }) [
    (features_.libc."${deps."termion"."1.5.1"."libc"}" deps)
    (features_.redox_syscall."${deps."termion"."1.5.1"."redox_syscall"}" deps)
    (features_.redox_termios."${deps."termion"."1.5.1"."redox_termios"}" deps)
  ];


# end
# textwrap-0.9.0

  crates.textwrap."0.9.0" = deps: { features?(features_.textwrap."0.9.0" deps {}) }: buildRustCrate {
    crateName = "textwrap";
    version = "0.9.0";
    description = "Textwrap is a small library for word wrapping, indenting, and\ndedenting strings.\n\nYou can use it to format strings (such as help and error messages) for\ndisplay in commandline applications. It is designed to be efficient\nand handle Unicode characters correctly.\n";
    authors = [ "Martin Geisler <martin@geisler.net>" ];
    sha256 = "18jg79ndjlwndz01mlbh82kkr2arqm658yn5kwp65l5n1hz8w4yb";
    dependencies = mapFeatures features ([
      (crates."unicode_width"."${deps."textwrap"."0.9.0"."unicode_width"}" deps)
    ]);
  };
  features_.textwrap."0.9.0" = deps: f: updateFeatures f (rec {
    textwrap."0.9.0".default = (f.textwrap."0.9.0".default or true);
    unicode_width."${deps.textwrap."0.9.0".unicode_width}".default = true;
  }) [
    (features_.unicode_width."${deps."textwrap"."0.9.0"."unicode_width"}" deps)
  ];


# end
# time-0.1.39

  crates.time."0.1.39" = deps: { features?(features_.time."0.1.39" deps {}) }: buildRustCrate {
    crateName = "time";
    version = "0.1.39";
    description = "Utilities for working with time-related functions in Rust.\n";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1ryy3bwhvyzj6fym123il38mk9ranm4vradj2a47l5ij8jd7w5if";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."time"."0.1.39"."libc"}" deps)
    ])
      ++ (if kernel == "redox" then mapFeatures features ([
      (crates."redox_syscall"."${deps."time"."0.1.39"."redox_syscall"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."time"."0.1.39"."winapi"}" deps)
    ]) else []);
  };
  features_.time."0.1.39" = deps: f: updateFeatures f (rec {
    libc."${deps.time."0.1.39".libc}".default = true;
    redox_syscall."${deps.time."0.1.39".redox_syscall}".default = true;
    time."0.1.39".default = (f.time."0.1.39".default or true);
    winapi = fold recursiveUpdate {} [
      { "${deps.time."0.1.39".winapi}"."minwinbase" = true; }
      { "${deps.time."0.1.39".winapi}"."minwindef" = true; }
      { "${deps.time."0.1.39".winapi}"."ntdef" = true; }
      { "${deps.time."0.1.39".winapi}"."profileapi" = true; }
      { "${deps.time."0.1.39".winapi}"."std" = true; }
      { "${deps.time."0.1.39".winapi}"."sysinfoapi" = true; }
      { "${deps.time."0.1.39".winapi}"."timezoneapi" = true; }
      { "${deps.time."0.1.39".winapi}".default = true; }
    ];
  }) [
    (features_.libc."${deps."time"."0.1.39"."libc"}" deps)
    (features_.redox_syscall."${deps."time"."0.1.39"."redox_syscall"}" deps)
    (features_.winapi."${deps."time"."0.1.39"."winapi"}" deps)
  ];


# end
# tokio-core-0.1.11

  crates.tokio_core."0.1.11" = deps: { features?(features_.tokio_core."0.1.11" deps {}) }: buildRustCrate {
    crateName = "tokio-core";
    version = "0.1.11";
    description = "Core I/O and event loop primitives for asynchronous I/O in Rust. Foundation for\nthe rest of the tokio crates.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1fa740i9pb3f3sw8mxilr2milgb5sh2rp1lgq1w0zpvr5vkx154d";
    dependencies = mapFeatures features ([
      (crates."bytes"."${deps."tokio_core"."0.1.11"."bytes"}" deps)
      (crates."futures"."${deps."tokio_core"."0.1.11"."futures"}" deps)
      (crates."iovec"."${deps."tokio_core"."0.1.11"."iovec"}" deps)
      (crates."log"."${deps."tokio_core"."0.1.11"."log"}" deps)
      (crates."mio"."${deps."tokio_core"."0.1.11"."mio"}" deps)
      (crates."scoped_tls"."${deps."tokio_core"."0.1.11"."scoped_tls"}" deps)
      (crates."slab"."${deps."tokio_core"."0.1.11"."slab"}" deps)
      (crates."tokio_io"."${deps."tokio_core"."0.1.11"."tokio_io"}" deps)
    ]);
  };
  features_.tokio_core."0.1.11" = deps: f: updateFeatures f (rec {
    bytes."${deps.tokio_core."0.1.11".bytes}".default = true;
    futures."${deps.tokio_core."0.1.11".futures}".default = true;
    iovec."${deps.tokio_core."0.1.11".iovec}".default = true;
    log."${deps.tokio_core."0.1.11".log}".default = true;
    mio."${deps.tokio_core."0.1.11".mio}".default = true;
    scoped_tls."${deps.tokio_core."0.1.11".scoped_tls}".default = true;
    slab."${deps.tokio_core."0.1.11".slab}".default = true;
    tokio_core."0.1.11".default = (f.tokio_core."0.1.11".default or true);
    tokio_io."${deps.tokio_core."0.1.11".tokio_io}".default = true;
  }) [
    (features_.bytes."${deps."tokio_core"."0.1.11"."bytes"}" deps)
    (features_.futures."${deps."tokio_core"."0.1.11"."futures"}" deps)
    (features_.iovec."${deps."tokio_core"."0.1.11"."iovec"}" deps)
    (features_.log."${deps."tokio_core"."0.1.11"."log"}" deps)
    (features_.mio."${deps."tokio_core"."0.1.11"."mio"}" deps)
    (features_.scoped_tls."${deps."tokio_core"."0.1.11"."scoped_tls"}" deps)
    (features_.slab."${deps."tokio_core"."0.1.11"."slab"}" deps)
    (features_.tokio_io."${deps."tokio_core"."0.1.11"."tokio_io"}" deps)
  ];


# end
# tokio-io-0.1.4

  crates.tokio_io."0.1.4" = deps: { features?(features_.tokio_io."0.1.4" deps {}) }: buildRustCrate {
    crateName = "tokio-io";
    version = "0.1.4";
    description = "Core I/O primitives for asynchronous I/O in Rust.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" "Carl Lerche <me@carllerche.com>" ];
    sha256 = "0cq5m0mvkn6kxqw7qnwliq3yimxdbcqfdlwn7xkrik8w8xlb3m6p";
    dependencies = mapFeatures features ([
      (crates."bytes"."${deps."tokio_io"."0.1.4"."bytes"}" deps)
      (crates."futures"."${deps."tokio_io"."0.1.4"."futures"}" deps)
      (crates."log"."${deps."tokio_io"."0.1.4"."log"}" deps)
    ]);
  };
  features_.tokio_io."0.1.4" = deps: f: updateFeatures f (rec {
    bytes."${deps.tokio_io."0.1.4".bytes}".default = true;
    futures."${deps.tokio_io."0.1.4".futures}".default = true;
    log."${deps.tokio_io."0.1.4".log}".default = true;
    tokio_io."0.1.4".default = (f.tokio_io."0.1.4".default or true);
  }) [
    (features_.bytes."${deps."tokio_io"."0.1.4"."bytes"}" deps)
    (features_.futures."${deps."tokio_io"."0.1.4"."futures"}" deps)
    (features_.log."${deps."tokio_io"."0.1.4"."log"}" deps)
  ];


# end
# tokio-proto-0.1.1

  crates.tokio_proto."0.1.1" = deps: { features?(features_.tokio_proto."0.1.1" deps {}) }: buildRustCrate {
    crateName = "tokio-proto";
    version = "0.1.1";
    description = "A network application framework for rapid development and highly scalable\nproduction deployments of clients and servers.\n";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "030q9h8pn1ngm80klff5irglxxki60hf5maw0mppmmr46k773z66";
    dependencies = mapFeatures features ([
      (crates."futures"."${deps."tokio_proto"."0.1.1"."futures"}" deps)
      (crates."log"."${deps."tokio_proto"."0.1.1"."log"}" deps)
      (crates."net2"."${deps."tokio_proto"."0.1.1"."net2"}" deps)
      (crates."rand"."${deps."tokio_proto"."0.1.1"."rand"}" deps)
      (crates."slab"."${deps."tokio_proto"."0.1.1"."slab"}" deps)
      (crates."smallvec"."${deps."tokio_proto"."0.1.1"."smallvec"}" deps)
      (crates."take"."${deps."tokio_proto"."0.1.1"."take"}" deps)
      (crates."tokio_core"."${deps."tokio_proto"."0.1.1"."tokio_core"}" deps)
      (crates."tokio_io"."${deps."tokio_proto"."0.1.1"."tokio_io"}" deps)
      (crates."tokio_service"."${deps."tokio_proto"."0.1.1"."tokio_service"}" deps)
    ]);
  };
  features_.tokio_proto."0.1.1" = deps: f: updateFeatures f (rec {
    futures."${deps.tokio_proto."0.1.1".futures}".default = true;
    log."${deps.tokio_proto."0.1.1".log}".default = true;
    net2."${deps.tokio_proto."0.1.1".net2}".default = true;
    rand."${deps.tokio_proto."0.1.1".rand}".default = true;
    slab."${deps.tokio_proto."0.1.1".slab}".default = true;
    smallvec."${deps.tokio_proto."0.1.1".smallvec}".default = true;
    take."${deps.tokio_proto."0.1.1".take}".default = true;
    tokio_core."${deps.tokio_proto."0.1.1".tokio_core}".default = true;
    tokio_io."${deps.tokio_proto."0.1.1".tokio_io}".default = true;
    tokio_proto."0.1.1".default = (f.tokio_proto."0.1.1".default or true);
    tokio_service."${deps.tokio_proto."0.1.1".tokio_service}".default = true;
  }) [
    (features_.futures."${deps."tokio_proto"."0.1.1"."futures"}" deps)
    (features_.log."${deps."tokio_proto"."0.1.1"."log"}" deps)
    (features_.net2."${deps."tokio_proto"."0.1.1"."net2"}" deps)
    (features_.rand."${deps."tokio_proto"."0.1.1"."rand"}" deps)
    (features_.slab."${deps."tokio_proto"."0.1.1"."slab"}" deps)
    (features_.smallvec."${deps."tokio_proto"."0.1.1"."smallvec"}" deps)
    (features_.take."${deps."tokio_proto"."0.1.1"."take"}" deps)
    (features_.tokio_core."${deps."tokio_proto"."0.1.1"."tokio_core"}" deps)
    (features_.tokio_io."${deps."tokio_proto"."0.1.1"."tokio_io"}" deps)
    (features_.tokio_service."${deps."tokio_proto"."0.1.1"."tokio_service"}" deps)
  ];


# end
# tokio-service-0.1.0

  crates.tokio_service."0.1.0" = deps: { features?(features_.tokio_service."0.1.0" deps {}) }: buildRustCrate {
    crateName = "tokio-service";
    version = "0.1.0";
    description = "The core `Service` trait for Tokio.\n";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "0c85wm5qz9fabg0k6k763j89m43n6max72d3a8sxcs940id6qmih";
    dependencies = mapFeatures features ([
      (crates."futures"."${deps."tokio_service"."0.1.0"."futures"}" deps)
    ]);
  };
  features_.tokio_service."0.1.0" = deps: f: updateFeatures f (rec {
    futures."${deps.tokio_service."0.1.0".futures}".default = true;
    tokio_service."0.1.0".default = (f.tokio_service."0.1.0".default or true);
  }) [
    (features_.futures."${deps."tokio_service"."0.1.0"."futures"}" deps)
  ];


# end
# unicase-2.1.0

  crates.unicase."2.1.0" = deps: { features?(features_.unicase."2.1.0" deps {}) }: buildRustCrate {
    crateName = "unicase";
    version = "2.1.0";
    description = "A case-insensitive wrapper around strings.";
    authors = [ "Sean McArthur <sean@seanmonstar.com>" ];
    sha256 = "1zzn16hh8fdx5pnbbnl32q8m2mh4vpd1jm9pdcv969ik83dw4byp";
    build = "build.rs";

    buildDependencies = mapFeatures features ([
      (crates."version_check"."${deps."unicase"."2.1.0"."version_check"}" deps)
    ]);
    features = mkFeatures (features."unicase"."2.1.0" or {});
  };
  features_.unicase."2.1.0" = deps: f: updateFeatures f (rec {
    unicase."2.1.0".default = (f.unicase."2.1.0".default or true);
    version_check."${deps.unicase."2.1.0".version_check}".default = true;
  }) [
    (features_.version_check."${deps."unicase"."2.1.0"."version_check"}" deps)
  ];


# end
# unicode-width-0.1.5

  crates.unicode_width."0.1.5" = deps: { features?(features_.unicode_width."0.1.5" deps {}) }: buildRustCrate {
    crateName = "unicode-width";
    version = "0.1.5";
    description = "Determine displayed width of `char` and `str` types\naccording to Unicode Standard Annex #11 rules.\n";
    authors = [ "kwantam <kwantam@gmail.com>" ];
    sha256 = "0886lc2aymwgy0lhavwn6s48ik3c61ykzzd3za6prgnw51j7bi4w";
    features = mkFeatures (features."unicode_width"."0.1.5" or {});
  };
  features_.unicode_width."0.1.5" = deps: f: updateFeatures f (rec {
    unicode_width."0.1.5".default = (f.unicode_width."0.1.5".default or true);
  }) [];


# end
# unicode-xid-0.0.4

  crates.unicode_xid."0.0.4" = deps: { features?(features_.unicode_xid."0.0.4" deps {}) }: buildRustCrate {
    crateName = "unicode-xid";
    version = "0.0.4";
    description = "Determine whether characters have the XID_Start\nor XID_Continue properties according to\nUnicode Standard Annex #31.\n";
    authors = [ "erick.tryzelaar <erick.tryzelaar@gmail.com>" "kwantam <kwantam@gmail.com>" ];
    sha256 = "1dc8wkkcd3s6534s5aw4lbjn8m67flkkbnajp5bl8408wdg8rh9v";
    features = mkFeatures (features."unicode_xid"."0.0.4" or {});
  };
  features_.unicode_xid."0.0.4" = deps: f: updateFeatures f (rec {
    unicode_xid."0.0.4".default = (f.unicode_xid."0.0.4".default or true);
  }) [];


# end
# unicode-xid-0.1.0

  crates.unicode_xid."0.1.0" = deps: { features?(features_.unicode_xid."0.1.0" deps {}) }: buildRustCrate {
    crateName = "unicode-xid";
    version = "0.1.0";
    description = "Determine whether characters have the XID_Start\nor XID_Continue properties according to\nUnicode Standard Annex #31.\n";
    authors = [ "erick.tryzelaar <erick.tryzelaar@gmail.com>" "kwantam <kwantam@gmail.com>" ];
    sha256 = "05wdmwlfzxhq3nhsxn6wx4q8dhxzzfb9szsz6wiw092m1rjj01zj";
    features = mkFeatures (features."unicode_xid"."0.1.0" or {});
  };
  features_.unicode_xid."0.1.0" = deps: f: updateFeatures f (rec {
    unicode_xid."0.1.0".default = (f.unicode_xid."0.1.0".default or true);
  }) [];


# end
# vec_map-0.8.1

  crates.vec_map."0.8.1" = deps: { features?(features_.vec_map."0.8.1" deps {}) }: buildRustCrate {
    crateName = "vec_map";
    version = "0.8.1";
    description = "A simple map based on a vector for small integer keys";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" "Jorge Aparicio <japaricious@gmail.com>" "Alexis Beingessner <a.beingessner@gmail.com>" "Brian Anderson <>" "tbu- <>" "Manish Goregaokar <>" "Aaron Turon <aturon@mozilla.com>" "Adolfo Ochagavía <>" "Niko Matsakis <>" "Steven Fackler <>" "Chase Southwood <csouth3@illinois.edu>" "Eduard Burtescu <>" "Florian Wilkens <>" "Félix Raimundo <>" "Tibor Benke <>" "Markus Siemens <markus@m-siemens.de>" "Josh Branchaud <jbranchaud@gmail.com>" "Huon Wilson <dbau.pp@gmail.com>" "Corey Farwell <coref@rwell.org>" "Aaron Liblong <>" "Nick Cameron <nrc@ncameron.org>" "Patrick Walton <pcwalton@mimiga.net>" "Felix S Klock II <>" "Andrew Paseltiner <apaseltiner@gmail.com>" "Sean McArthur <sean.monstar@gmail.com>" "Vadim Petrochenkov <>" ];
    sha256 = "1jj2nrg8h3l53d43rwkpkikq5a5x15ms4rf1rw92hp5lrqhi8mpi";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."vec_map"."0.8.1" or {});
  };
  features_.vec_map."0.8.1" = deps: f: updateFeatures f (rec {
    vec_map = fold recursiveUpdate {} [
      { "0.8.1"."serde" =
        (f.vec_map."0.8.1"."serde" or false) ||
        (f.vec_map."0.8.1".eders or false) ||
        (vec_map."0.8.1"."eders" or false); }
      { "0.8.1".default = (f.vec_map."0.8.1".default or true); }
    ];
  }) [];


# end
# version_check-0.1.3

  crates.version_check."0.1.3" = deps: { features?(features_.version_check."0.1.3" deps {}) }: buildRustCrate {
    crateName = "version_check";
    version = "0.1.3";
    description = "Tiny crate to check the version of the installed/running rustc.";
    authors = [ "Sergio Benitez <sb@sergio.bz>" ];
    sha256 = "0z635wdclv9bvafj11fpgndn7y79ibpsnc364pm61i1m4wwg8msg";
  };
  features_.version_check."0.1.3" = deps: f: updateFeatures f (rec {
    version_check."0.1.3".default = (f.version_check."0.1.3".default or true);
  }) [];


# end
# winapi-0.2.8

  crates.winapi."0.2.8" = deps: { features?(features_.winapi."0.2.8" deps {}) }: buildRustCrate {
    crateName = "winapi";
    version = "0.2.8";
    description = "Types and constants for WinAPI bindings. See README for list of crates providing function bindings.";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "0a45b58ywf12vb7gvj6h3j264nydynmzyqz8d8rqxsj6icqv82as";
  };
  features_.winapi."0.2.8" = deps: f: updateFeatures f (rec {
    winapi."0.2.8".default = (f.winapi."0.2.8".default or true);
  }) [];


# end
# winapi-0.3.3

  crates.winapi."0.3.3" = deps: { features?(features_.winapi."0.3.3" deps {}) }: buildRustCrate {
    crateName = "winapi";
    version = "0.3.3";
    description = "Raw FFI bindings for all of Windows API.";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "0f49a8dxxbh16s9n9q7sckdzyprqpdm62nh6w9cj5h3cdfmrsvrn";
    build = "build.rs";
    dependencies = (if kernel == "i686-pc-windows-gnu" then mapFeatures features ([
      (crates."winapi_i686_pc_windows_gnu"."${deps."winapi"."0.3.3"."winapi_i686_pc_windows_gnu"}" deps)
    ]) else [])
      ++ (if kernel == "x86_64-pc-windows-gnu" then mapFeatures features ([
      (crates."winapi_x86_64_pc_windows_gnu"."${deps."winapi"."0.3.3"."winapi_x86_64_pc_windows_gnu"}" deps)
    ]) else []);
    features = mkFeatures (features."winapi"."0.3.3" or {});
  };
  features_.winapi."0.3.3" = deps: f: updateFeatures f (rec {
    winapi."0.3.3".default = (f.winapi."0.3.3".default or true);
    winapi_i686_pc_windows_gnu."${deps.winapi."0.3.3".winapi_i686_pc_windows_gnu}".default = true;
    winapi_x86_64_pc_windows_gnu."${deps.winapi."0.3.3".winapi_x86_64_pc_windows_gnu}".default = true;
  }) [
    (features_.winapi_i686_pc_windows_gnu."${deps."winapi"."0.3.3"."winapi_i686_pc_windows_gnu"}" deps)
    (features_.winapi_x86_64_pc_windows_gnu."${deps."winapi"."0.3.3"."winapi_x86_64_pc_windows_gnu"}" deps)
  ];


# end
# winapi-build-0.1.1

  crates.winapi_build."0.1.1" = deps: { features?(features_.winapi_build."0.1.1" deps {}) }: buildRustCrate {
    crateName = "winapi-build";
    version = "0.1.1";
    description = "Common code for build.rs in WinAPI -sys crates.";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "1lxlpi87rkhxcwp2ykf1ldw3p108hwm24nywf3jfrvmff4rjhqga";
    libName = "build";
  };
  features_.winapi_build."0.1.1" = deps: f: updateFeatures f (rec {
    winapi_build."0.1.1".default = (f.winapi_build."0.1.1".default or true);
  }) [];


# end
# winapi-i686-pc-windows-gnu-0.3.2

  crates.winapi_i686_pc_windows_gnu."0.3.2" = deps: { features?(features_.winapi_i686_pc_windows_gnu."0.3.2" deps {}) }: buildRustCrate {
    crateName = "winapi-i686-pc-windows-gnu";
    version = "0.3.2";
    description = "Import libraries for the i686-pc-windows-gnu target. Please don't use this crate directly, depend on winapi instead.";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "1q9xhkhv1pd5kixnh1qkbim4196khywh63avv77z0j4394dq6vns";
    build = "build.rs";
  };
  features_.winapi_i686_pc_windows_gnu."0.3.2" = deps: f: updateFeatures f (rec {
    winapi_i686_pc_windows_gnu."0.3.2".default = (f.winapi_i686_pc_windows_gnu."0.3.2".default or true);
  }) [];


# end
# winapi-x86_64-pc-windows-gnu-0.3.2

  crates.winapi_x86_64_pc_windows_gnu."0.3.2" = deps: { features?(features_.winapi_x86_64_pc_windows_gnu."0.3.2" deps {}) }: buildRustCrate {
    crateName = "winapi-x86_64-pc-windows-gnu";
    version = "0.3.2";
    description = "Import libraries for the x86_64-pc-windows-gnu target. Please don't use this crate directly, depend on winapi instead.";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "052jwc587hijmcyb6bwplkibv76bihqvc1pphxypy123yga2wiy3";
    build = "build.rs";
  };
  features_.winapi_x86_64_pc_windows_gnu."0.3.2" = deps: f: updateFeatures f (rec {
    winapi_x86_64_pc_windows_gnu."0.3.2".default = (f.winapi_x86_64_pc_windows_gnu."0.3.2".default or true);
  }) [];


# end
# ws2_32-sys-0.2.1

  crates.ws2_32_sys."0.2.1" = deps: { features?(features_.ws2_32_sys."0.2.1" deps {}) }: buildRustCrate {
    crateName = "ws2_32-sys";
    version = "0.2.1";
    description = "Contains function definitions for the Windows API library ws2_32. See winapi for types and constants.";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "1zpy9d9wk11sj17fczfngcj28w4xxjs3b4n036yzpy38dxp4f7kc";
    libName = "ws2_32";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."winapi"."${deps."ws2_32_sys"."0.2.1"."winapi"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."winapi_build"."${deps."ws2_32_sys"."0.2.1"."winapi_build"}" deps)
    ]);
  };
  features_.ws2_32_sys."0.2.1" = deps: f: updateFeatures f (rec {
    winapi."${deps.ws2_32_sys."0.2.1".winapi}".default = true;
    winapi_build."${deps.ws2_32_sys."0.2.1".winapi_build}".default = true;
    ws2_32_sys."0.2.1".default = (f.ws2_32_sys."0.2.1".default or true);
  }) [
    (features_.winapi."${deps."ws2_32_sys"."0.2.1"."winapi"}" deps)
    (features_.winapi_build."${deps."ws2_32_sys"."0.2.1"."winapi_build"}" deps)
  ];


# end
}
