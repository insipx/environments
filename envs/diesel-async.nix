{ withRust, system, fenix, ... }:

let
  pkgs = withRust;
  isDarwin = pkgs.stdenv.isDarwin;
  frameworks = pkgs.darwin.apple_sdk.frameworks;
  fenixPkgs = fenix.packages.${system};
  linters = import ./../linters.nix { inherit pkgs; };

  rust-toolchain = with fenixPkgs;
    combine [
      beta.rustc
      beta.cargo
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
      wasm-bindgen-cli
      diesel-cli
      twiggy
      binaryen
      linters
      cargo-cache
      protolint
      cargo-nextest
      cargo-udeps
      cargo-sweep
      act # GH Actions sim
    ] ++ lib.optionals isDarwin [
      libiconv
      frameworks.CoreServices
      frameworks.Carbon
      frameworks.ApplicationServices
      frameworks.AppKit
      darwin.cctools
    ];
}
