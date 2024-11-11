{ stdenv
, darwin
, lib
, system
, fenix
, shells
, androidenv
, pkg-config
, mktemp
, jdk21
, kotlin
, buf
, curl
, diesel-cli
, protobuf
, protoc-gen-prost-crate
, tokio-console
, protolint
, gource
, gnuplot
, flamegraph
, inferno
, act # GH Actions sim
, cargo-ndk
, openssl
, sqlite
, corepack
, libiconv
, ...
}:

let
  inherit (stdenv) isDarwin;
  inherit (darwin.apple_sdk) frameworks;
  inherit (shells) combineShell;
  fenixPkgs = fenix.packages.${system};
  mkShell = top: (combineShell (with shells;
    [ (mkLinters { }) (mkCargo { }) (mkRustWasm { }) top ]));

  rust-toolchain = fenixPkgs.fromToolchainFile {
    file = ./../rust-toolchain.toml;
    sha256 = "sha256-yMuSb5eQPO/bHv+Bcf/US8LVMbf/G/0MSfiPwBhiPpk=";
  };

  androidComposition = androidenv.composeAndroidPackages {
    includeNDK = true;
    platformToolsVersion = "33.0.3";
    platformVersions = [ "23" "24" "25" "26" "27" "28" "29" "30" "31" "32" "33" "34" ];
    buildToolsVersions = [ "30.0.3" ];
  };
in
mkShell {
  OPENSSL_DIR = "${openssl.dev}";
  ANDROID_HOME = "${androidComposition.androidsdk}/libexec/android-sdk";
  ANDROID_NDK_ROOT = "$ANDROID_HOME/ndk-bundle";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    rust-toolchain
    fenixPkgs.rust-analyzer

    mktemp
    jdk21
    kotlin
    buf
    curl
    diesel-cli

    protobuf
    protoc-gen-prost-crate
    tokio-console
    protolint
    gource
    gnuplot
    flamegraph
    inferno
    act # GH Actions sim
    cargo-ndk
    openssl
    sqlite

    # make sure to use nodePackages! or it will install yarn irrespective of environmental node.
    corepack
  ] ++ lib.optionals isDarwin [
    libiconv
    frameworks.CoreServices
    frameworks.Carbon
    frameworks.ApplicationServices
    frameworks.AppKit
    darwin.cctools
  ];

}
