{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    systems.url = "github:nix-systems/default";
    devenv.url = "github:cachix/devenv";
    cargo2nix = {
      url = "github:cargo2nix/cargo2nix/release-0.11.0";
      inputs = { nixpkgs.follows = "nixpkgs"; };
    };
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
    let forEachSystem = nixpkgs.lib.genAttrs (import systems);
    in {
      devShells = forEachSystem (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          foundryPkgs = pkgs.callPackage ./pkgs/foundry-rs/foundry {
            inherit nixpkgs system fenix;
          };
          goEthereumPkg = (import ./pkgs/go-ethereum { inherit nixpkgs; });
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
              packages = with foundryPkgs; [
                anvil.default
                cast.default
                chisel.default
                forge.default
                goEthereumPkg.geth
              ];

              enterShell = ''
                hello
              '';
            }];
          };
        });
    };
}
