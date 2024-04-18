{ pkgs, rust-toolchain, ... }:
let
  frameworks = pkgs.darwin.apple_sdk.frameworks;
  applePkgs = [ pkgs.libiconv frameworks.Security ];
  isDarwin = pkgs.hostPlatform.isDarwin;
  src = pkgs.fetchFromGitHub {
    owner = "alloy-rs";
    repo = "svm-rs";
    rev = "v0.5.1";
    sha256 = "sha256-0Q7eFvERe1qb4cRZ0as9JVSimsg7LTLIboIx2OGhjuc=";
  };
  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    allowBuiltinFetchGit = true;
  };
in (pkgs.makeRustPlatform {
  cargo = rust-toolchain;
  rustc = rust-toolchain;
}).buildRustPackage {
  inherit src cargoLock;
  pname = "svm";
  version = "0.5.1";
  cargoBuildFlags = "-p svm-rs";
  doCheck = false;
  buildInputs = with pkgs; [ clang gcc ] ++ lib.optionals isDarwin applePkgs;
}
