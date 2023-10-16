{ pkgs ? import <nixpkgs> { }, applePkgs, toolchain, src, cargoLock, ... }:

let isDarwin = pkgs.hostPlatform.isDarwin;
in {
  default = (pkgs.makeRustPlatform {
    cargo = toolchain;
    rustc = toolchain;
  }).buildRustPackage {
    inherit src cargoLock;
    pname = "anvil";
    version = "0.2.0";
    cargoBuildFlags = "-p anvil";
    doCheck = false;

    buildInputs = with pkgs; [ clang gcc ] ++ lib.optionals isDarwin applePkgs;
  };
}
