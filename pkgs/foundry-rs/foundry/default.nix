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
    allowBuiltinFetchGit = true;
    #   outputHashes = {
    #     "ethers-2.0.11" = "sha256-ySrCZOiqOcDVH5T7gbimK6Bu7A2OCcU64ZL1RfFPrBc=";
    #     "revm-3.5.0" = "sha256-7pcy005mfdIo3Y0aHtJNqX98Rqf2HY3Jl4XvakHEV2A=";
    #     "alloy-consensus-0.1.0" =
    #       "sha256-tz/3noS0a8uY69U5Ru/dD3m+9AifkMN0wpYdj2mj3C0=";
    #     "revm-inspectors-0.1.0" =
    #       "sha256-yBqeANijUCBRhOU7XjQvo4H8dbFPFFKErzmZ+Lw4OSA=";
    #   };
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
