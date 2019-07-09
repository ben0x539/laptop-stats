{ pkgs' ? import <nixpkgs> {} }:

let
  mozilla = pkgs'.fetchFromGitHub {
    owner = "mozilla";
    repo = "nixpkgs-mozilla";
    rev = "200cf0640fd8fdff0e1a342db98c9e31e6f13cd7";
    sha256 = "1am353ims43ylvay263alchzy3y87r1khnwr0x2fp35qr347bvxi";
  };
  pkgs = import <nixpkgs> {
    overlays = [
      (import "${mozilla}/rust-overlay.nix")
    ];
  };
  rustNightly = pkgs.rustChannelOf {
    date = "2019-07-04";
    channel = "nightly";
  };

  buildRustCrate = pkgs.callPackage <nixpkgs/pkgs/build-support/rust/build-rust-crate> {
    rustc = rustNightly.rust;
  };

  laptop-stats-src = ./.;

  cratesIO = pkgs.callPackage "${laptop-stats-src}/crates-io.nix" {};

  crates = pkgs.callPackage "${laptop-stats-src}/Cargo.nix" {
    inherit buildRustCrate cratesIO;
  };

in

crates.laptop_stats {}
