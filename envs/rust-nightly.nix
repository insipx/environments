{ stdenv
, darwin
, fenix
, system
, pkg-config
, mkShell
, sqlite
, mktemp
, curl
, lib
}:
let
  inherit (stdenv) isDarwin;
  fenixPkgs = fenix.packages.${system};

  rust-toolchain =
    with fenixPkgs;
    combine [
      minimal.rustc
      minimal.cargo
      complete.clippy
      complete.rustfmt
      complete.llvm-tools-preview
      targets.wasm32-unknown-unknown.latest.rust-std
      targets.wasm32-wasi.latest.rust-std
    ];
in
mkShell {
  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    with fenixPkgs;
    [
      rust-toolchain
      rust-analyzer

      sqlite
      mktemp
      curl
    ]
    ++ lib.optionals isDarwin [
      darwin.cctools
    ];
}
