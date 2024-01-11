{ pkgsWithRust, system, fenix, ... }:

let
  pkgs = pkgsWithRust;
  isDarwin = pkgs.stdenv.isDarwin;
  frameworks = pkgs.darwin.apple_sdk.frameworks;
  fenixPkgs = fenix.packages.${system};
  linters = import ./linters.nix { inherit pkgs; };
  foundryPkgs =
    (import ./pkgs/foundry-rs/foundry { inherit pkgs system rust-toolchain; });
  # src = pkgs.fetchFromGitHub {
  #   owner = "xmtp";
  #   repo = "libxmtp";
  #   rev = "main";
  #   hash = "sha256-KJoOSP4rZ9a1/3xi12gp9ig+LZz2gotxfdNOweZ5ZhM=";
  # };

  rust-toolchain = with fenixPkgs;
    combine [
      stable.rustc
      stable.cargo
      stable.clippy
      stable.rustfmt
      targets.wasm32-unknown-unknown.latest.rust-std
    ];
in pkgs.mkShell {
  nativeBuildInputs = with pkgs; [ pkg-config ];
  buildInputs = with pkgs;
    [
      # (fenixPkgs.fromToolchainFile { file = ./rust-toolchain.toml; })
      rust-toolchain
      rust-analyzer
      llvmPackages_16.libcxxClang
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
      cargo-nextest
      foundryPkgs.anvil
    ] ++ lib.optionals isDarwin [
      libiconv
      frameworks.CoreServices
      frameworks.Carbon
      frameworks.ApplicationServices
      frameworks.AppKit
    ];
}
