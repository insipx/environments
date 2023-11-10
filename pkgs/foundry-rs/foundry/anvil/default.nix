{ pkgs ? import <nixpkgs> { }, applePkgs, rust-toolchain, src, cargoLock, ... }:

let isDarwin = pkgs.hostPlatform.isDarwin;
in (pkgs.makeRustPlatform {
  cargo = rust-toolchain;
  rustc = rust-toolchain;
}).buildRustPackage {
  inherit src cargoLock;
  pname = "anvil";
  version = "0.2.0";
  cargoBuildFlags = "-p anvil";
  doCheck = false;

  buildInputs = with pkgs; [ clang gcc ] ++ lib.optionals isDarwin applePkgs;
}
