{ withGo, inputs, devenv, fenix, system, ... }:
let
  pkgs = withGo;
  rust-toolchain = with fenix.packages.${system};
    combine [
      minimal.rustc
      minimal.cargo
      complete.clippy
      complete.rustfmt
      targets.wasm32-unknown-unknown.latest.rust-std
    ];
  foundryPkgs = (import ./../pkgs/foundry-rs/foundry {
    inherit pkgs system rust-toolchain;
  });
  goEthereumPkg = (import ./../pkgs/go-ethereum { inherit pkgs; });
  linters = import ./../linters.nix { inherit pkgs; };
  #pinnedNpm = pkgs.nodePackages.npm.overrideAttrs (oldAttrs: {
  #  version = "7.24.2";
  #  src = pkgs.fetchurl {
  #    url = "https://github.com/npm/cli/archive/v7.24.2.tar.gz";
  #    sha256 = "sha256-e3oRWb2OKonYY36LxMJEek0NVBIBI0aCdo3wNuLQwWQ=";
  #  };
  #});
in devenv.lib.mkShell {
  inherit inputs pkgs;
  modules = [{
    packages = with foundryPkgs; [
      rust-toolchain
      (fenix.packages.${system}.rust-analyzer)
      anvil
      cast.default
      chisel.default
      forge.default
      goEthereumPkg.geth
      goEthereumPkg.clef
      pkgs.go_1_21
      pkgs.solc
      pkgs.nodejs
      # make sure to use nodePackages! or it will install yarn irrespective of environmental node.
      pkgs.nodePackages.yarn
      pkgs.wasm-pack
      pkgs.trunk
      pkgs.wasm-bindgen-cli
      pkgs.protobuf
      linters
    ];
    enterShell = ''
      echo "XMTP Solidity/Foundry/Rust Development Environment";
    '';
  }];
}
