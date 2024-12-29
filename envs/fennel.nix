{ shells
, stdenv
, darwin
, lib
, system
, fenix
, pkg-config
, mktemp
, jdk21
, kotlin
, diesel-cli
, tokio-console
, gource
, gnuplot
, flamegraph
, cargo-flamegraph
, inferno
, cargo-ndk
, openssl
, sqlite
, corepack
, fblog
, samply
, fetchFromGitHub
, ...
}:

let
  inherit (stdenv) isDarwin;
  inherit (darwin.apple_sdk) frameworks;
  inherit (shells) combineShell;
  fenixPkgs = fenix.packages.${system};
  mkShell =
    top:
    (combineShell
      (with shells; [
        mkLinters
        mkCargo
        mkRustWasm
        mkGrpc
      ])
      top);

  src = fetchFromGitHub {
    owner = "fennelLabs";
    repo = "fennel-solonet";
    rev = "main";
    hash = "sha256-3MJj1JqGl3ETGASHB4E+pR+qZ5jmnpejPBmAPXcqvLk=";
  };

  rust-toolchain = fenixPkgs.fromToolchainFile {
    file = "${src}/rust-toolchain.toml";
    sha256 = "sha256-s1RPtyvDGJaX/BisLT+ifVfuhDT1nZkZ1NcK8sbwELM=";
  };

in
mkShell {
  OPENSSL_DIR = "${openssl.dev}";

  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    [
      rust-toolchain
      fenixPkgs.rust-analyzer

      mktemp

      tokio-console
      gource
      gnuplot
      flamegraph
      cargo-flamegraph
      inferno
      cargo-ndk
      samply
      openssl

      fblog

      # make sure to use nodePackages! or it will install yarn irrespective of environmental node.
      corepack
    ]
    ++ lib.optionals isDarwin [
      frameworks.CoreServices
      frameworks.Carbon
      frameworks.ApplicationServices
      frameworks.AppKit
      darwin.cctools
    ];
}
