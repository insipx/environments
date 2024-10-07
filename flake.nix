{
  inputs = {
    devenv.url = "github:cachix/devenv";
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

    flake-utils = { url = "github:numtide/flake-utils"; };
  };

  nixConfig = {
    extra-trusted-public-keys =
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = { nixpkgs, flake-utils, devenv, fenix, solc, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgBundles =
          import ./pkg_bundles.nix { inherit nixpkgs fenix solc system; };

      in
      with pkgBundles; {
        devShells = {
          default = devenv.lib.mkShell {
            inherit pkgs inputs;
            modules = [{
              # https://devenv.sh/reference/options/
              packages = [ pkgs.hello ];
              enterShell = ''
                hello
              '';
            }];
          };


          converse =
            import ./envs/converse.nix { inherit pkgs; };

          rust-nightly =
            import ./envs/rust-nightly.nix { inherit withRust system fenix; };

          rust-stable =
            import ./envs/rust-stable.nix { inherit withRust system fenix; };

          libxmtp =
            import ./envs/libxmtp.nix { inherit withRust system fenix; };

          xmtp-web =
            import ./envs/xmtp-web.nix { inherit withRust system fenix; };

          didethresolver = import ./envs/didethresolver.nix {
            inherit withRust system fenix;
          };

          xps = import ./envs/xps.nix { inherit withRust system fenix; };

          solidityDev = import ./envs/solidityDev.nix {
            inherit withRust fenix solc system;
          };

          luaDev = import ./envs/lua_dev.nix { inherit pkgs; };

          rustStable = devenv.lib.mkShell {
            inherit inputs pkgs;
            modules = [{
              languages.rust = {
                enable = true;
                channel = "stable";
              };
              packages = [ ];
              enterShell = ''
                General Rust Dev Environment with latest stable rust in flake.
              '';
            }];
          };

          #solidityAndRust = (import ./envs/solidityAndRustDev.nix {
          #  inherit withGo1_20 inputs devenv fenix system;
          #});

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
