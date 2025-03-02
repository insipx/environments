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
, gource
, gnuplot
, flamegraph
, cargo-flamegraph
, inferno
, openssl
, sqlite
, corepack
, lnav
, zstd
, llvmPackages_19
, wasm-bindgen-cli
, jq
, ...
}:

let
  inherit (stdenv) isDarwin;
  inherit (darwin.apple_sdk) frameworks;
  inherit (shells) combineShell;
  fenixPkgs = fenix.packages.${system};
  mkShell =
    top:
    (
      combineShell
        {
          otherShells = with shells;
            [
              mkLinters
              mkCargo
              mkRustWasm
              mkGrpc
            ];
          extraInputs = top;
          inherit (llvmPackages_19) stdenv;
        });

  rust-toolchain = fenixPkgs.fromToolchainFile {
    file = ./../rust-toolchain.toml;
    sha256 = "sha256-AJ6LX/Q/Er9kS15bn9iflkUwcgYqRQxiOIL2ToVAXaU=";
  };

  # androidComposition = androidenv.composeAndroidPackages {
  #   includeNDK = true;
  #   platformToolsVersion = "33.0.3";
  #   platformVersions = [ "34" ];
  #   buildToolsVersions = [ "30.0.3" ];
  # };
  # ANDROID_HOME = "${androidComposition.androidsdk}/libexec/android-sdk";
  # ANDROID_NDK_ROOT = "${ANDROID_HOME}/ndk-bundle";
in
mkShell {
  # inherit ANDROID_HOME ANDROID_NDK_ROOT;
  OPENSSL_DIR = "${openssl.dev}";
  LLVM_PATH = "${llvmPackages_19.stdenv}";
  # CC_wasm32_unknown_unknown = "${llvmPackages_19.clang-unwrapped}/bin/clang";
  # CXX_wasm32_unknown_unknown = "${llvmPackages_19.clang-unwrapped}/bin/clang++";
  # AS_wasm32_unknown_unknown = "${llvmPackages_19.clang-unwrapped}/bin/llvm-as";
  # AR_wasm32_unknown_unknown = "${llvmPackages_19.clang-unwrapped}/bin/llvm-ar";
  # STRIP_wasm32_unknown_unknown = "${llvmPackages_19.clang-unwrapped}/bin/llvm-strip";
  # CARGO_TARGET_WASM32_UNKNOWN_UNKNOWN_RUSTFLAGS = "-C target-feature=-zero-call-used-regs";
  # disable -fzerocallusedregs in clang
  hardeningDisable = [ "zerocallusedregs" ];
  OPENSSL_LIB_DIR = "${lib.getLib openssl}/lib";
  OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    [
      rust-toolchain
      wasm-bindgen-cli
      fenixPkgs.rust-analyzer
      zstd
      # llvmPackages_19.stdenv

      mktemp
      jdk21
      kotlin
      diesel-cli
      jq

      # Random devtools
      # tokio-console
      gource
      gnuplot
      flamegraph
      cargo-flamegraph
      inferno
      # cargo-ndk
      openssl
      sqlite

      lnav

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
