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
      # llvmPackages_16.libcxxClang
      mktemp
      jdk21
      kotlin
      shellcheck
      buf
      curl
      linters

      # make sure to use nodePackages! or it will install yarn irrespective of environmental node.
      nodejs
      nodePackages.yarn
    ] ++ lib.optionals isDarwin [
      libiconv
      frameworks.CoreServices
      frameworks.Carbon
      frameworks.ApplicationServices
      frameworks.AppKit
      darwin.cctools
    ];
}
