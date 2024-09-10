{
  # Flake to test out packages
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    fenix = {
      url = "github:nix-community/fenix";
      inputs = { nixpkgs.follows = "nixpkgs"; };
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, fenix, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        fenixPkgs = fenix.packages.${system};
        rust-toolchain = with fenixPkgs;
          combine [
            minimal.rustc
            minimal.cargo
            complete.clippy
            complete.rustfmt
            targets.wasm32-unknown-unknown.latest.rust-std
          ];
        buildInputs = [ foundry.anvil foundry.cast ];
        foundry = import ./default.nix { inherit pkgs rust-toolchain; };
      in
      with pkgs; { devShells.default = mkShell { inherit buildInputs; }; });
}
