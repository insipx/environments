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
    hash = "sha256-ecnHE7qZiVjMpidHrs7VtMEvnPDeENYwSVpxtB83ij0=";
  };

  rust-toolchain = fenixPkgs.fromToolchainFile {
    file = "${src}/rust-toolchain";
    sha256 = "sha256-VZZnlyP69+Y3crrLHQyJirqlHrTtGTsyiSnZB8jEvVo=";
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
in
pkgs.mkShell {
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

      # make sure to use nodePackages! or it will install yarn irrespective of environmental node.
      nodejs
      yarn-berry
      # chromedriver
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
