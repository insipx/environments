{ pkgs ? import <nixpkgs> { }, applePkgs, toolchain, src, cargoLock, ... }:

let isDarwin = pkgs.hostPlatform.isDarwin;
in {
  default = (pkgs.makeRustPlatform {
    cargo = toolchain;
    rustc = toolchain;
  }).buildRustPackage {
    inherit src cargoLock;
    pname = "forge";
    version = "0.2.0";
    cargoBuildFlags = "-p forge";
    doCheck = false;

    nativeBuildInputs = with pkgs;
      [ pkg-config ] ++ lib.optionals isDarwin [ pkgs.darwin.DarwinTools ];

    buildInputs = with pkgs; [ clang gcc ] ++ lib.optionals isDarwin applePkgs;
  };
}
