{ pkgsWithRust, system, fenix, ... }:

let
  pkgs = pkgsWithRust;
  isDarwin = pkgs.stdenv.isDarwin;
  frameworks = pkgs.darwin.apple_sdk.frameworks;
  fenixPkgs = fenix.packages.${system};
  linters = import ./linters.nix { inherit pkgs; };
  # foundryPkgs =
  #  (import ./pkgs/foundry-rs/foundry { inherit pkgs system rust-toolchain; });
  src = pkgs.fetchFromGitHub {
    owner = "xmtp";
    repo = "libxmtp";
    rev = "main";
    hash = "sha256-Nt5mJvDQgG9J1pEfQPOxNHB2SW3mJleVAmuDcVWdGa4=";
  };
  rust-toolchain =
    fenixPkgs.fromToolchainFile { file = ./rust-toolchain.toml; };

  # fenixPkgs.fromToolchainFile { file = "${src}/rust-toolchain"; };
  #rust-toolchain = with fenixPkgs;
  #  combine [
  #    stable.rustc
  #    stable.cargo
  #    stable.clippy
  #    stable.rustfmt
  #    stable.llvm-tools-preview
  #    targets.wasm32-unknown-unknown.latest.rust-std
  #  ];
in pkgs.mkShell {
  nativeBuildInputs = with pkgs; [ pkg-config ];
  buildInputs = with pkgs;
    [
      rust-toolchain
      rust-analyzer
      # clang
      # llvmPackages_16.libcxxClang
      mktemp
      jdk21
      kotlin
      markdownlint-cli
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
      protolint
      # cargo-nextest
      cargo-udeps
      # foundryPkgs.anvil
      gource
      cargo-cache
    ] ++ lib.optionals isDarwin [
      libiconv
      frameworks.CoreServices
      frameworks.Carbon
      frameworks.ApplicationServices
      frameworks.AppKit
      darwin.cctools
    ];
}
