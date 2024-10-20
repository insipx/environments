{ withRust, system, fenix, ... }:

let
  pkgs = withRust;
  inherit (pkgs.stdenv) isDarwin;
  inherit (pkgs.darwin.apple_sdk) frameworks;
  fenixPkgs = fenix.packages.${system};
  linters = import ./../linters.nix { inherit pkgs; };
  foundryPkgs =
    import ./../pkgs/foundry-rs/foundry { inherit pkgs rust-toolchain; };

  src = pkgs.fetchFromGitHub {
    owner = "xmtp";
    repo = "libxmtp";
    rev = "main";
    hash = "sha256-NxwSm7s6LhK8WpfTZEVe0749Gf3lIksrCUar72LmAp4=";
  };

  # rust-toolchain = fenixPkgs.fromToolchainFile {
  #   file = "${src}/rust-toolchain";
  #   sha256 = "sha256-VZZnlyP69+Y3crrLHQyJirqlHrTtGTsyiSnZB8jEvVo=";
  # };

  rust-toolchain = fenixPkgs.fromToolchainFile {
    file = ./../rust-toolchain.toml;
    sha256 = "sha256-yMuSb5eQPO/bHv+Bcf/US8LVMbf/G/0MSfiPwBhiPpk=";
  };

  # rust-toolchain = with fenixPkgs;
  #   combine [
  #     minimal.rustc
  #     minimal.cargo
  #     complete.clippy
  #     complete.rustfmt
  #     complete.llvm-tools-preview
  #     targets.wasm32-unknown-unknown.latest.rust-std
  #     targets.wasm32-unknown-emscripten.latest.rust-std
  #   ];

  androidComposition = pkgs.androidenv.composeAndroidPackages {
    includeNDK = true;
    platformToolsVersion = "33.0.3";
    platformVersions = [ "23" "24" "25" "26" "27" "28" "29" "30" "31" "32" "33" "34" ];
    buildToolsVersions = [ "30.0.3" ];
  };
  shellHook = ''
    export OPENSSL_DIR="${pkgs.openssl.dev}"
    export ANDROID_HOME="${androidComposition.androidsdk}/libexec/android-sdk"
    export ANDROID_NDK_ROOT="$ANDROID_HOME/ndk-bundle"
    # export PATH="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/darwin-x86_64/bin $PATH"
  '';
in
pkgs.mkShell {
  inherit shellHook;
  nativeBuildInputs = with pkgs; [ pkg-config ];
  buildInputs = with pkgs;
    [
      rust-toolchain
      rust-analyzer
      # llvmPackages_16.libcxxClang
      mktemp
      jdk21
      kotlin
      shellcheck
      buf
      curl
      wasm-pack
      # wasm-bindgen-cli
      diesel-cli
      twiggy
      binaryen
      linters
      protobuf
      protoc-gen-prost-crate
      tokio-console
      cargo-cache
      protolint
      cargo-nextest
      cargo-udeps
      cargo-sweep
      gource
      cargo-cache
      foundryPkgs.anvil
      gnuplot
      flamegraph
      inferno
      act # GH Actions sim
      wabt
      cargo-wasi
      cargo-expand
      cargo-machete
      cargo-features-manager
      cargo-bloat
      cargo-mutants
      cargo-deny
      cargo-audit
      cargo-cross
      cargo-ndk
      chromedriver
      google-chrome
      geckodriver
        # android-studio-tools
      openssl
      sqlite

      # make sure to use nodePackages! or it will install yarn irrespective of environmental node.
      nodejs
      yarn-berry
      # nodePackages.yarn
    ] ++ lib.optionals isDarwin [
      libiconv
      frameworks.CoreServices
      frameworks.Carbon
      frameworks.ApplicationServices
      frameworks.AppKit
      darwin.cctools
    ];
}
