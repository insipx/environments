{ withRust, system, fenix, ... }:

let
  pkgs = withRust;
  isDarwin = pkgs.stdenv.isDarwin;
  frameworks = pkgs.darwin.apple_sdk.frameworks;
  fenixPkgs = fenix.packages.${system};
  linters = import ./../linters.nix { inherit pkgs; };
  foundryPkgs =
    import ./../pkgs/foundry-rs/foundry { inherit pkgs rust-toolchain; };
  src = pkgs.fetchFromGitHub {
    owner = "xmtp";
    repo = "libxmtp";
    rev = "main";
    hash = "sha256-0000000000000000000000000000000000000000000=";
  };

  # rust-toolchain = fenixPkgs.fromToolchainFile {
  #   file = "${src}/rust-toolchain";
  #   sha256 = "sha256-0000000000000000000000000000000000000000000=";
  # };

  # fenixPkgs.fromToolchainFile { file = "${src}/rust-toolchain"; };
  rust-toolchain = with fenixPkgs;
    combine [
      minimal.rustc
      minimal.cargo
      complete.clippy
      complete.rustfmt
      complete.llvm-tools-preview
      targets.wasm32-unknown-unknown.latest.rust-std
    ];
in pkgs.mkShell {
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
      diesel-cli
      twiggy
      wasm-bindgen-cli
      binaryen
      linters
      protobuf
      protoc-gen-prost-crate
      tokio-console
      cargo-cache
      protolint
      cargo-nextest
      cargo-udeps
      gource
      cargo-cache
      foundryPkgs.anvil
    ] ++ lib.optionals isDarwin [
      libiconv
      frameworks.CoreServices
      frameworks.Carbon
      frameworks.ApplicationServices
      frameworks.AppKit
      darwin.cctools
    ];
}
