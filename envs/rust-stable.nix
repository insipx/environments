{ withRust, system, fenix, ... }:

let
  pkgs = withRust;
  inherit (pkgs.stdenv) isDarwin;
  inherit (pkgs.darwin.apple_sdk) frameworks;
  fenixPkgs = fenix.packages.${system};
  linters = import ./../linters.nix { inherit pkgs; };

  rust-toolchain = with fenixPkgs;
    combine [
     stable.rustc
     stable.cargo
     stable.clippy
     stable.rustfmt
     stable.llvm-tools-preview
     targets.wasm32-unknown-unknown.latest.rust-std
    ];
in
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [ pkg-config ];
  buildInputs = with pkgs;
    [
      rust-toolchain
      rust-analyzer
      # llvmPackages_16.libcxxClang
      sqlite
      mktemp
      shellcheck
      buf
      curl
      linters
      tokio-console
      cargo-cache
      cargo-nextest
      cargo-udeps
      cargo-sweep
      cargo-cache
      cargo-wasi

      sqlite
      mysql80
      # mariadb_106
    ] ++ lib.optionals isDarwin [
      libiconv
      frameworks.CoreServices
      frameworks.Carbon
      frameworks.ApplicationServices
      frameworks.AppKit
      darwin.cctools
    ];

  shellHook = ''
    export MYSQLCLIENT_LIB_DIR=${pkgs.mysql84.out}/lib
    export MYSQLCLIENT_VERSION="21"
  '';
}
