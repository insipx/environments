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

    flake-utils = { url = "github:numtide/flake-utils"; };
  };

  nixConfig = {
    extra-trusted-public-keys =
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = { self, nixpkgs, flake-utils, devenv, fenix, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        # Overlays
        overlays = import ./overlays;
        pkgsWithNodejs14 = import nixpkgs {
          inherit system;
          overlays = with overlays; [
            go_1_21_3
            nodejs_14_21_3
            fenix.overlays.default
          ];
        };
        pkgsWithGo = import nixpkgs {
          inherit system;
          overlays = with overlays; [ go_1_21_3 fenix.overlays.default ];
        };
        pkgsWithRust = import nixpkgs {
          inherit system;
          overlays = [ fenix.overlays.default ];
        };

      in {
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

          libxmtp =
            (import ./envs/libxmtp.nix { inherit pkgsWithRust system fenix; });

          didethresolver = (import ./envs/didethresolver.nix {
            inherit pkgsWithRust system fenix;
          });

          xps = (import ./envs/xps.nix { inherit pkgsWithRust system fenix; });

          solidityDev = (import ./envs/solidityDev.nix {
            inherit pkgsWithNodejs14 inputs devenv fenix system;
          });

          luaDev = (import ./envs/lua_dev.nix { inherit pkgs; });

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

          solidityAndRust = (import ./envs/solidityAndRustDev.nix {
            inherit pkgsWithGo inputs devenv fenix system;
          });

          xchat =
            (import ./envs/xchat.nix { inherit pkgsWithRust system fenix; });
        };
      });
}
