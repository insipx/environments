{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    systems.url = "github:nix-systems/default";
    devenv.url = "github:cachix/devenv";
    naersk.url = "github:nix-community/naersk";
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

  outputs = { self, nixpkgs, devenv, systems, naersk, ... }@inputs:
    let forEachSystem = nixpkgs.lib.genAttrs (import systems);
    in {
      devShells = forEachSystem (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          frameworks = pkgs.darwin.apple_sdk.frameworks;
          isDarwin = pkgs.hostPlatform.isDarwin;
          foundry = pkgs.callPackage ./foundry-rs/foundry {
            inherit nixpkgs system naersk;
          };
        in {
          default = devenv.lib.mkShell {
            inherit inputs pkgs;
            modules = [{
              # https://devenv.sh/reference/options/
              packages = [ pkgs.hello ];

              enterShell = ''
                hello
              '';
            }];
          };
          libxmtp = devenv.lib.mkShell {
            inherit inputs pkgs;
            modules = [{
              packages = [ ];
              languages.rust = {
                enable = true;
                channel = "stable";
              };
              enterShell = ''
                echo "LibXMTP Rust Environment"
              '';
            }];
          };
          foundry = devenv.lib.mkShell {
            inherit inputs pkgs;
            modules = [{
              packages = with pkgs;
                [
                  clang
                  libusb
                  gcc
                  frameworks.CoreFoundation
                  frameworks.IOKit
                  frameworks.SystemConfiguration
                  frameworks.AppKit
                  frameworks.Security
                  frameworks.CoreServices
                ] ++ lib.optionals isDarwin [ ];
              languages.rust = {
                enable = true;
                channel = "stable";
              };
              enterShell = ''
                echo "Foundry Rust Environment"
              '';
            }];
          };
          foundryPackages = devenv.lib.mkShell {
            inherit inputs pkgs;
            modules = [{
              # https://devenv.sh/reference/options/
              packages = [ foundry.anvil ];

              enterShell = ''
                hello
              '';
            }];
          };
        });
    };
}
