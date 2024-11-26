{
  shells,
  stdenv,
  darwin,
  fenix,
  system,
  pkg-config,
  tokio-console,
  curl,
}:
let
  inherit (stdenv) isDarwin;
  inherit (darwin.apple_sdk) frameworks;
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
shells.mkCargo {
  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    with fenixPkgs;
    [
      rust-toolchain
      rust-analyzer

      sqlite
      mktemp
      curl
      tokio-console

      sqlite
      mysql80
      # mariadb_106
    ]
    ++ lib.optionals isDarwin [
      frameworks.CoreServices
      frameworks.Carbon
      frameworks.ApplicationServices
      frameworks.AppKit
      darwin.cctools
    ];
}
