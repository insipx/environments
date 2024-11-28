{
  go,
  gopls,
  stdenv,
  darwin,
  shells,
  mockgen,
  moreutils,
  protoc-gen-go,
  pkg-config,
  lib,
  ...
}:

let
  mkShell =
    top:
    (shells.combineShell (with shells; [
      mkLinters
      mkGrpc
    ]) top);
  inherit (darwin.apple_sdk) frameworks;
in
mkShell {
  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    [
      go
      mockgen
      moreutils
      protoc-gen-go
      gopls
    ]
    ++ lib.optionals stdenv.isDarwin [
      frameworks.CoreServices
      frameworks.Carbon
      frameworks.ApplicationServices
      frameworks.AppKit
      darwin.cctools
    ];
}
