{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
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
      js18181Overlay = import ./js/overlay_18_18_1.nix;
      forEachSystem = nixpkgs.lib.genAttrs (import systems);
    in {
      devShells = forEachSystem (system:
        let
          pkgs =
            import nixpkgs { overlays = [ go1213Overlay js18181Overlay ]; };
          # pkgs = nixpkgs.legacyPackages.${system}.extend go1213Overlay;
          rustStable = fenix.packages.${system}.stable.toolchain;
          foundryPkgs = (import ./pkgs/foundry-rs/foundry {
            inherit pkgs system rustStable;
          });
          goEthereumPkg = (import ./pkgs/go-ethereum { inherit pkgs; });
          isDarwin = pkgs.hostPlatform.isDarwin;
          frameworks = pkgs.darwin.apple_sdk.frameworks;
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
          rustStable = devenv.lib.mkShell {
            inherit inputs pkgs;
            modules = [{
              packages = with pkgs;
                [
                  pkg-config
                  clang
                  gcc
                  mktemp
                  jdk21
                  kotlin
                  markdownlint-cli
                  shellcheck
                  buf
                ] ++ lib.optionals isDarwin [
                  libiconv
                  frameworks.AppKit
                  frameworks.CoreFoundation
                  frameworks.Security
                  frameworks.SystemConfiguration
                ];
              languages.rust = {
                enable = true;
                channel = "stable";
              };
              enterShell = ''
                echo "LibXMTP Rust Environment"
              '';
            }];
          };
          solidityDev = devenv.lib.mkShell {
            inherit inputs pkgs;
            modules = [{
              packages = with foundryPkgs; [
                anvil
                cast.default
                chisel.default
                forge.default
                goEthereumPkg.geth
                goEthereumPkg.clef
                rustStable
                pkgs.go_1_21
                pkgs.solc
                pkgs.nodejs_18
              ];

              enterShell = ''
                XMTP Solidity/Foundry Development Environment
              '';
            }];
          };
        });
    };
}
