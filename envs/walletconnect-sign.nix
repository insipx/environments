{ pkgs, system, ... }:
let
  linters = import ./../linters.nix { inherit pkgs; };
  isDarwin = pkgs.stdenv.isDarwin;
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    nodejs_21
    nodePackages.typescript-language-server
    # make sure to use nodePackages! or it will install yarn irrespective of environmental node.
    nodePackages.yarn
    linters
  ];
}
