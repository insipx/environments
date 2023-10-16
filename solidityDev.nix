{ pkgs, inputs, devenv, fenix, system, ... }:
let
  rustStable = fenix.packages.${system}.stable.toolchain;
  foundryPkgs =
    (import ./pkgs/foundry-rs/foundry { inherit pkgs system rustStable; });
  goEthereumPkg = (import ./pkgs/go-ethereum { inherit pkgs; });
in devenv.lib.mkShell {
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
      echo "XMTP Solidity/Foundry Development Environment"
    '';
  }];
}
