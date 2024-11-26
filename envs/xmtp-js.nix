{
  shells,
  stdenv,
  darwin,
  mktemp,
  buf,
  curl,
  geckodriver,
  corepack,
  pkg-config,
  lib,
}:

let
  inherit (darwin.apple_sdk) frameworks;
  # linters = import ./../linters.nix { inherit pkgs; };
  mkShell =
    top:
    (shells.combineShell (with shells; [
      mkLinters
    ]) top);
in
mkShell {
  name = "xmtp-js environment";
  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    [
      mktemp
      buf
      curl
      geckodriver

      corepack
    ]
    ++ lib.optionals stdenv.isDarwin [
      frameworks.CoreServices
      frameworks.Carbon
      frameworks.ApplicationServices
      frameworks.AppKit
      darwin.cctools
    ];
  VITE_PROJECT_ID = "2ca676e2e5e9322c40c68f10dca637e5";
}
