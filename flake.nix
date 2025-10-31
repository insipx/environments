{
  inputs = {
    #   cargo2nix = {
    #     url = "github:cargo2nix/cargo2nix/release-0.11.0";
    #     inputs = { nixpkgs.follows = "nixpkgs"; };
    #   };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    fenix = {
      url = "github:nix-community/fenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    solc = {
      url = "github:hellwolf/solc.nix";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };
    foundry.url = "github:shazow/foundry.nix/monthly"; # Use monthly branch for permanent releases
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    mkshell-util = { url = "github:insipx/mkShell-util.nix"; };
  };

  outputs =
    inputs@{ nixpkgs
    , flake-utils
    , fenix
    , foundry
    , solc
    , ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        mkshell-util = import inputs.mkshell-util;
        pkgBundles = import ./pkg-bundles {
          inherit
            nixpkgs
            fenix
            foundry
            system
            mkshell-util;
        };
        rustShell = dir: (pkgBundles.callPackage pkgBundles.pkgsRust) dir { inherit fenix system; };
        rustWithSolc = dir: (pkgBundles.callPackage pkgBundles.pkgsRust) dir { inherit fenix system solc; };

      in
      with pkgBundles;
      {
        devShells = {
          rust-nightly = rustShell ./envs/rust-nightly.nix;
          rust-stable = rustShell ./envs/rust-stable.nix;
          arduino = rustShell ./envs/arduino.nix;
          solidityDev = rustWithSolc ./envs/solidityDev.nix;
          infrastructure = (callPackage pkgsUnfree) ./envs/infrastructure.nix { };
          xmtp-js = (callPackage pkgs) ./envs/xmtp-js.nix { };
          xmtp-node-go = (callPackage pkgs) ./envs/xmtp-node-go.nix { };
          xmtpd = (callPackage pkgs) ./envs/xmtpd.nix { };

          luaDev = import ./envs/lua-dev.nix { inherit pkgs; };
          xchat = import ./envs/xchat.nix { inherit withRust system fenix; };
          jsonrpsee = import ./envs/jsonrpsee.nix { inherit withRust system fenix; };
          walletconnect-sign = import ./envs/walletconnect-sign.nix { inherit pkgs system; };
          xmtp-proto = import ./envs/xmtp-proto.nix { inherit pkgs system; };
        };
        packages = {
          jj-stack = pkgs.callPackage ./pkgs/jj-stack { };
        };
      }
    );
}
