{ pkgs, system, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  frameworks = pkgs.darwin.apple_sdk.frameworks;
  linters = import ./../linters.nix { inherit pkgs; };

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
      protobuf
      protoc-gen-prost-crate
      protolint
    ] ++ lib.optionals isDarwin [
      libiconv
      frameworks.CoreServices
      frameworks.Carbon
      frameworks.ApplicationServices
      frameworks.AppKit
      darwin.cctools
    ];
}
