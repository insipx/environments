{ pkgs ? import <nixpkgs> { }, applePkgs, rustStable, src, cargoLock, ... }:

let isDarwin = pkgs.hostPlatform.isDarwin;
in (pkgs.makeRustPlatform {
  cargo = rustStable;
  rustc = rustStable;
}).buildRustPackage {
  inherit src cargoLock;
  pname = "anvil";
  version = "0.2.0";
  cargoBuildFlags = "-p anvil";
  doCheck = false;

  buildInputs = with pkgs; [ clang gcc ] ++ lib.optionals isDarwin applePkgs;
}
