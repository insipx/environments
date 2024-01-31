{ pkgs, rust-toolchain, ... }:
let
  frameworks = pkgs.darwin.apple_sdk.frameworks;
  applePkgs = [ pkgs.libiconv frameworks.IOKit frameworks.AppKit ];
  src = pkgs.fetchFromGitHub {
    owner = "foundry-rs";
    repo = "foundry";
    rev = "nightly";
    hash = "sha256-+V/FFAB2plQOAax2St06dcvSDahf9xe8cW98Rnx0OMo=";
  };
  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    outputHashes = {
      "ethers-2.0.11" = "sha256-ySrCZOiqOcDVH5T7gbimK6Bu7A2OCcU64ZL1RfFPrBc=";
      "revm-3.5.0" = "sha256-odaNHGw7RfJHJInQ/zRQYBev4vsJeyx6pGERgOSD/24=";
    };
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
