{ shells
, stdenv
, darwin
, lib
, system
, fenix
, androidenv
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

  rust-toolchain = fenixPkgs.fromToolchainFile {
    file = ./../rust-toolchain.toml;
    sha256 = "sha256-s1RPtyvDGJaX/BisLT+ifVfuhDT1nZkZ1NcK8sbwELM=";
  };

  androidComposition = androidenv.composeAndroidPackages {
    includeNDK = true;
    platformToolsVersion = "33.0.3";
    platformVersions = [ "34" ];
    buildToolsVersions = [ "30.0.3" ];
  };
  ANDROID_HOME = "${androidComposition.androidsdk}/libexec/android-sdk";
  ANDROID_NDK_ROOT = "${ANDROID_HOME}/ndk-bundle";
in
mkShell {
  inherit ANDROID_HOME ANDROID_NDK_ROOT;
  OPENSSL_DIR = "${openssl.dev}";

  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    [
      rust-toolchain
      fenixPkgs.rust-analyzer

      mktemp
      jdk21
      kotlin
      diesel-cli

      tokio-console
      gource
      gnuplot
      flamegraph
      cargo-flamegraph
      inferno
      cargo-ndk
      samply
      openssl
      sqlite

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
