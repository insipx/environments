{ withRust, fenix, solc, system, ... }:
let
  pkgs = withRust;
  rust-toolchain = fenix.packages.${system}.stable.toolchain;
  foundryPkgs =
     (import ./../pkgs/foundry-rs/foundry { inherit pkgs rust-toolchain; });
  # goEthereumPkg = (import ./../pkgs/go-ethereum { inherit pkgs; });
  linters = import ./../linters.nix { inherit pkgs; };
  isDarwin = pkgs.stdenv.isDarwin;

  #pinnedNpm = pkgs.nodePackages.npm.overrideAttrs (oldAttrs: {
  #  version = "7.24.2";
  #  src = pkgs.fetchurl {
  #    url = "https://github.com/npm/cli/archive/v7.24.2.tar.gz";
  #    sha256 = "sha256-e3oRWb2OKonYY36LxMJEek0NVBIBI0aCdo3wNuLQwWQ=";
  #  };
  #});
in pkgs.mkShell {

  buildInputs = with pkgs;
    [
      rust-toolchain
    # foundryPkgs.anvil
    # foundryPkgs.cast
    # foundryPkgs.chisel
    # foundryPkgs.forge
      go-ethereum
      nodejs
      # make sure to use nodePackages! or it will install yarn irrespective of environmental node.
      nodePackages.yarn
      wasm-pack
      linters
      solc-select
    ] ++ pkgs.lib.optionals isDarwin [ libiconv ];

  packages = with pkgs; [
      
  ];
}
