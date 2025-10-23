{ stdenv
, darwin
, pkg-config
, lib
, swift
, swiftpm
, swiftlint
, mkShell
, ...
}: mkShell {
  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    [
      swift
      swiftpm
      swiftlint
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.cctools
    ];
}

