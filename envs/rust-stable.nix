{ mkCargo
, fenix
, system
, curl
, stdenv
, darwin
, pkg-config
, libiconv
}:

let
  inherit (stdenv) isDarwin;
  inherit (darwin.apple_sdk) frameworks;
  fenixPkgs = fenix.packages.${system};

  rust-toolchain = with fenixPkgs;
    combine [
      stable.rustc
      stable.cargo
      stable.clippy
      stable.rustfmt
      stable.llvm-tools-preview
      targets.wasm32-unknown-unknown.latest.rust-std
    ];
in
mkCargo {
  nativeBuildInputs = [ pkg-config ];
  buildInputs = with fenixPkgs; [
    rust-toolchain
    rust-analyzer
    curl
  ] ++ lib.optionals isDarwin [
    libiconv
    frameworks.CoreServices
    frameworks.Carbon
    frameworks.ApplicationServices
    frameworks.AppKit
    darwin.cctools
  ];
}
