{ pkgs ? import <nixpkgs> { }, applePkgs, toolchain, src, cargoLock, ... }:

let isDarwin = pkgs.hostPlatform.isDarwin;
in {
  default = (pkgs.makeRustPlatform {
    cargo = toolchain;
    rustc = toolchain;
  }).buildRustPackage {
    inherit src cargoLock;
    pname = "chisel";
    version = "0.2.0";
    cargoBuildFlags = "-p chisel";
    doCheck = false;

    nativeBuildInputs = with pkgs;
      [ pkg-config ] ++ lib.optionals isDarwin [ pkgs.darwin.DarwinTools ];

    buildInputs = with pkgs;
      [ clang gcc libusb1 ] ++ lib.optionals isDarwin applePkgs;
  };
}
