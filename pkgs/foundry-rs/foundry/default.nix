{ pkgs, rust-toolchain, ... }:
let
  frameworks = pkgs.darwin.apple_sdk.frameworks;
  applePkgs = [ pkgs.libiconv frameworks.IOKit frameworks.AppKit pkgs.libusb1 ];
  src = pkgs.fetchFromGitHub {
    owner = "foundry-rs";
    repo = "foundry";
    rev = "nightly";
    hash = "sha256-fqVrtGXLYdjoJIYqefj2irbLrT1u/kU45DjFRcnbSMU=";
  };
  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    allowBuiltinFetchGit = true;
  };
in {
  anvil =
    (import ./anvil { inherit pkgs applePkgs rust-toolchain src cargoLock; });
  cast =
    (import ./cast { inherit pkgs applePkgs rust-toolchain src cargoLock; });
  chisel =
    (import ./chisel { inherit pkgs applePkgs rust-toolchain src cargoLock; });
  forge =
    (import ./forge { inherit pkgs applePkgs rust-toolchain src cargoLock; });
}
