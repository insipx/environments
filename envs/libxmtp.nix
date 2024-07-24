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
    hash = "sha256-da33gxlEe/hHHqoGYyDy9htYl5WvvcOVHdVFHvyCmfs=";
  };

  rust-toolchain = fenixPkgs.fromToolchainFile {
    file = "${src}/rust-toolchain";
    sha256 = "sha256-Ngiz76YP4HTY75GGdH2P+APE/DEIx2R/Dn+BwwOyzZU=";
  };

  #rust-toolchain = with fenixPkgs;
  #  combine [
  #    minimal.rustc
  #    minimal.cargo
  #    complete.clippy
  #    complete.rustfmt
  #    complete.llvm-tools-preview
  #    targets.wasm32-unknown-unknown.latest.rust-std
  #  ];
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
