{
  inputs = {
    #   cargo2nix = {
    #     url = "github:cargo2nix/cargo2nix/release-0.11.0";
    #     inputs = { nixpkgs.follows = "nixpkgs"; };
    #   };
    fenix = {
      url = "github:nix-community/fenix";
      inputs = { nixpkgs.follows = "nixpkgs"; };
    };

    solc = {
      url = "github:hellwolf/solc.nix";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };
    foundry.url = "github:shazow/foundry.nix/monthly"; # Use monthly branch for permanent releases
    flake-utils = { url = "github:numtide/flake-utils"; };
  };

  outputs = { nixpkgs, flake-utils, fenix, foundry, solc, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgBundles =
          import ./pkg-bundles { inherit nixpkgs fenix foundry system; };
      in
      with pkgBundles; {
        devShells = {

          converse =
            import ./envs/converse.nix { inherit pkgs; };

          rust-nightly = (callPackage pkgsRust) ./envs/rust-nightly.nix { inherit fenix system; };
          rust-stable = (callPackage pkgsRust) ./envs/rust-stable.nix { inherit fenix system; };
          libxmtp = (callPackage pkgsRust) ./envs/libxmtp.nix { inherit fenix system; };

          xmtp-js =
            import ./envs/xmtp-js.nix {
              inherit pkgs system;
            };
          xmtp-android =
            import ./envs/xmtp-android.nix { inherit pkgsAndroid system; };

          didethresolver = import ./envs/didethresolver.nix {
            inherit withRust system fenix;
          };

          xps = import ./envs/xps.nix { inherit withRust system fenix; };

          solidityDev = import ./envs/solidityDev.nix {
            inherit withRust fenix solc system;
          };

          luaDev = import ./envs/lua_dev.nix { inherit pkgs; };

          xchat = import ./envs/xchat.nix { inherit withRust system fenix; };

          jsonrpsee =
            import ./envs/jsonrpsee.nix { inherit withRust system fenix; };

          walletconnect-sign =
            import ./envs/walletconnect-sign.nix { inherit pkgs system; };

          xmtpd = import ./envs/xmtpd.nix { inherit pkgs system; };

          xmtp-node-go =
            import ./envs/xmtp-node-go.nix { inherit pkgs system; };

          xmtp-proto = import ./envs/xmtp-proto.nix { inherit pkgs system; };
          wa-sqlite = import ./envs/wa-sqlite.nix { inherit pkgs system; };
          diesel-async =
            import ./envs/diesel-async.nix { inherit withRust system fenix; };
        };
      });
}
