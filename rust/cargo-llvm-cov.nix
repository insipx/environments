{ pkgsWithRustStable, inputs, system, fenix, ... }:
let
  pkgs = pkgsWithRustStable;
  isDarwin = pkgs.stdenv.isDarwin;
  frameworks = pkgs.darwin.apple_sdk.frameworks;
  rustStable = (fenix.packages.${system}.stable.withComponents [
    "cargo"
    "clippy"
    "rust-src"
    "rustc"
    "rustfmt"
    "llvm-tools-preview"
  ]);
  rustPlatform = (pkgs.makeRustPlatform {
    cargo = rustStable;
    rustc = rustStable;
  });
  version = "0.5.34";
  pname = "cargo-llvm-cov";
in rustPlatform.buildRustPackage {
  pname = pname;
  version = version;
  src = pkgs.fetchCrate {
    inherit pname version;
    sha256 = "sha256-BDFyj6PwIseDB3cJq3z0CmUut5bH6nw8JazBCI8oh5o=";
  };
  cargoSha256 = "sha256-7yV2oa1gHRLaszcZC1iXc6PqyfqBhhiKTpg7H1LxK7Q=";

  nativeBuildInputs = [ pkgs.pkg-config ];
  buildInputs = [
    pkgs.openssl
    pkgs.llvmPackages_16.libcxxClang
    pkgs.llvm
    pkgs.llvmPackages_16.bintools-unwrapped
  ];
  # skip tests which require llvm-tools-preview
  checkFlags = [
    "--skip bin_crate"
    "--skip cargo_config"
    "--skip clean_ws"
    "--skip instantiations"
    "--skip merge"
    "--skip merge_failure_mode_all"
    "--skip no_test"
    "--skip open_report"
    "--skip real1"
    "--skip show_env"
    "--skip virtual1"
  ];
}
