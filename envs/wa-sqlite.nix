{ pkgs, system, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  frameworks = pkgs.darwin.apple_sdk.frameworks;
  linters = import ./../linters.nix { inherit pkgs; };

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
      mktemp
      shellcheck
      buf
      curl
      binaryen
      linters
      protolint
      # make sure to use nodePackages! or it will install yarn irrespective of environmental node.
      nodejs
      yarn-berry
      emscripten
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
