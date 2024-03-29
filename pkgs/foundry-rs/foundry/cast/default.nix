{ pkgs ? import <nixpkgs> { }, applePkgs, rust-toolchain, src, cargoLock, ... }:

let isDarwin = pkgs.hostPlatform.isDarwin;
in (pkgs.makeRustPlatform {
  cargo = rust-toolchain;
  rustc = rust-toolchain;
}).buildRustPackage {
  inherit src cargoLock;
  pname = "cast";
  version = "0.2.0";
  cargoBuildFlags = "-p cast@0.2.0";
  doCheck = false;

  nativeBuildInputs = with pkgs;
    [ pkg-config ] ++ lib.optionals isDarwin [ pkgs.darwin.DarwinTools ];

  buildInputs = with pkgs;
    [ clang gcc libusb1 ] ++ lib.optionals isDarwin applePkgs;
}
