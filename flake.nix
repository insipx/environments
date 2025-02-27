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
            mkshell-util
            ;
        };
        rustShell = dir: (pkgBundles.callPackage pkgBundles.pkgsRust) dir { inherit fenix system; };
      in
      with pkgBundles;
      {
        devShells = {
          rust-nightly = rustShell ./envs/rust-nightly.nix;
          rust-stable = rustShell ./envs/rust-stable.nix;
          libxmtp = rustShell ./envs/libxmtp.nix;
          sqlite-wasm-rs = rustshell ./envs/sqlite-wasm-rs.nix;
          fennel = rustShell ./envs/fennel.nix;
          arduino = rustShell ./envs/arduino.nix;

          foundry = (callPackage pkgs) ./envs/foundry.nix { };
          xmtp-js = (callPackage pkgs) ./envs/xmtp-js.nix { };
          xmtp-node-go = (callPackage pkgs) ./envs/xmtp-node-go.nix { };
          xmtp-android = (callPackage pkgsAndroid) ./envs/xmtp-android.nix { };
          # xmtp-android = import ./envs/xmtp-android.nix { inherit pkgsAndroid system; };

          solidityDev = import ./envs/solidityDev.nix {
            inherit
              withRust
              fenix
              solc
              system
              ;
          };

          luaDev = import ./envs/lua_dev.nix { inherit pkgs; };

          xchat = import ./envs/xchat.nix { inherit withRust system fenix; };

          jsonrpsee = import ./envs/jsonrpsee.nix { inherit withRust system fenix; };

          walletconnect-sign = import ./envs/walletconnect-sign.nix { inherit pkgs system; };

          xmtpd = import ./envs/xmtpd.nix { inherit pkgs system; };

          xmtp-proto = import ./envs/xmtp-proto.nix { inherit pkgs system; };
          wa-sqlite = import ./envs/wa-sqlite.nix { inherit pkgs system; };
          diesel-async = import ./envs/diesel-async.nix { inherit withRust system fenix; };
        };
      }
    );
}
