{ pkgs ? import <nixpkgs> { }, system, fenix, ... }:
let
  frameworks = pkgs.darwin.apple_sdk.frameworks;
  applePkgs = [ pkgs.libiconv frameworks.IOKit frameworks.AppKit ];
  toolchain = fenix.packages.${system}.minimal.toolchain;
  src = pkgs.fetchFromGitHub {
    owner = "foundry-rs";
    repo = "foundry";
    rev = "0232ee56a20324af443e69b0c42db7c0b12031d8";
    hash = "sha256-dglYAjcjl7Mqab5sfnxpzlRm5JFhbFdoV85u4FOLj7U=";
  };
  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    outputHashes = {
      "ethers-2.0.10" = "sha256-bfnTG8ab5mRrqnrm9b5UuqN+PfTQbTcMkcNWI2GpH9s=";
    };
  };
in {
  anvil = pkgs.callPackage ./anvil {
    inherit pkgs applePkgs toolchain src cargoLock;
  };
  cast =
    pkgs.callPackage ./cast { inherit pkgs applePkgs toolchain src cargoLock; };
  chisel = pkgs.callPackage ./chisel {
    inherit pkgs applePkgs toolchain src cargoLock;
  };
  forge = pkgs.callPackage ./forge {
    inherit pkgs applePkgs toolchain src cargoLock;
  };
}
