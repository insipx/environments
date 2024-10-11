{ pkgs, ... }:

let
  inherit (pkgs.stdenv) isDarwin;
  inherit (pkgs.darwin.apple_sdk) frameworks;
  linters = import ./../linters.nix { inherit pkgs; };
in
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [ pkg-config ];
  buildInputs = with pkgs;
    [
      mktemp
      shellcheck
      buf
      curl
      linters
        # chromedriver
        # google-chrome
      geckodriver

      # make sure to use nodePackages! or it will install yarn irrespective of environmental node.
      nodejs
      yarn-berry
      # nodePackages.yarn
    ] ++ lib.optionals isDarwin [
      libiconv
      frameworks.CoreServices
      frameworks.Carbon
      frameworks.ApplicationServices
      frameworks.AppKit
      darwin.cctools
    ];
}
