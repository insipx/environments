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
  };

  nixConfig = {
    extra-trusted-public-keys =
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = { self, nixpkgs, devenv, systems, fenix, ... }@inputs:
    let
      go1213Overlay = import ./go/overlay_1_21_3.nix;
      nodejs_14_21_3 = import ./js/overlay_14_21_3.nix;
      # js18181Overlay = import ./js/overlay_18_18_1.nix;
      forEachSystem = nixpkgs.lib.genAttrs (import systems);
      pkgsWithNodejs14 = import nixpkgs {
        overlays = [ go1213Overlay nodejs_14_21_3 fenix.overlays.default ];
      };
      pkgs = import nixpkgs { };
      pkgsWithGo =
        import nixpkgs { overlays = [ go1213Overlay fenix.overlays.default ]; };
      pkgsWithRust = import nixpkgs { overlays = [ fenix.overlays.default ]; };
    in {
      devShells = forEachSystem (system: {
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

        linters = (import ./linters.nix { inherit pkgs; });

        libxmtp = (import ./libxmtp.nix { inherit pkgsWithRust system fenix; });

        didethresolver =
          (import ./didethresolver.nix { inherit pkgsWithRust system fenix; });

        solidityDev = (import ./solidityDev.nix {
          inherit pkgsWithNodejs14 inputs devenv fenix system;
        });

        luaDev = (import ./lua_dev.nix { inherit pkgs; });

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

        solidityAndRust = (import ./solidityAndRustDev.nix {
          inherit pkgsWithGo inputs devenv fenix system;
        });

        xchat = (import ./xchat.nix { inherit pkgsWithRust system fenix; });
      });
    };
}
