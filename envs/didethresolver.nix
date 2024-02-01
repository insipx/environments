{ pkgsWithRust, system, fenix, ... }:

let
  pkgs = pkgsWithRust;
  isDarwin = pkgs.stdenv.isDarwin;
  frameworks = pkgs.darwin.apple_sdk.frameworks;
  fenixPkgs = fenix.packages.${system};
  linters = import ./../linters.nix { inherit pkgs; };
  foundryPkgs =
    import ./../pkgs/foundry-rs/foundry { inherit pkgs rust-toolchain; };
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
      rust-toolchain
      rust-analyzer
      llvmPackages_17.libcxxClang
      mktemp
      shellcheck
      curl
      linters
      tokio-console
      cargo-nextest
      foundryPkgs.anvil
      go-ethereum
    ] ++ lib.optionals isDarwin [
      libiconv
      frameworks.CoreServices
      frameworks.Carbon
      frameworks.ApplicationServices
      frameworks.AppKit
    ];
}
