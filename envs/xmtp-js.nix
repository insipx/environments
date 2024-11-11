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
      geckodriver

      corepack
      go-ethereum
      nodePackages.typescript
    ] ++ lib.optionals isDarwin [
      libiconv
      frameworks.CoreServices
      frameworks.Carbon
      frameworks.ApplicationServices
      frameworks.AppKit
      darwin.cctools
    ];
    shellHook = ''
      export VITE_PROJECT_ID="2ca676e2e5e9322c40c68f10dca637e5"
    '';
}
