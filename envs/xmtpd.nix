{ go
, gopls
, stdenv
, darwin
, mockgen
, moreutils
, protoc-gen-go
, pkg-config
, lib
, foundry
, mkShell
, ...
}: mkShell {
  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    [
      go
      mockgen
      moreutils
      protoc-gen-go
      gopls
      foundry
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.cctools
    ];
}


