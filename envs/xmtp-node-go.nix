{ go
, gopls
, stdenv
, darwin
, shells
, mockgen
, moreutils
, protoc-gen-go
, pkg-config
, lib
, go-mockery
, ...
}:

let
  mkShell =
    top:
    (shells.combineShell {
      otherShells = with shells;
        [
          mkLinters
          mkGrpc
        ];
      extraInputs = top;
    });
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
      go-mockery
    ]
    ++ lib.optionals stdenv.isDarwin [
      frameworks.CoreServices
      frameworks.Carbon
      frameworks.ApplicationServices
      frameworks.AppKit
      darwin.cctools
    ];
}
