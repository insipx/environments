{ go
, gopls
, stdenv
, darwin
, mockgen
, moreutils
, protoc-gen-go
, pkg-config
, lib
, go-mockery
, mkShell
, ...
}:

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
      darwin.cctools
    ];
}
