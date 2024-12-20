{ pkgs, system, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  frameworks = pkgs.darwin.apple_sdk.frameworks;
  linters = import ./../linters.nix { inherit pkgs; };
in
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [ pkg-config ];
  buildInputs =
    with pkgs;
    [
      # llvmPackages_16.libcxxClang
      mktemp
      buf
      curl
      linters
      protobuf
      protoc-gen-prost-crate
      protolint
      go
      gopls
      mockgen
    ]
    ++ lib.optionals isDarwin [
      frameworks.CoreServices
      frameworks.Carbon
      frameworks.ApplicationServices
      frameworks.AppKit
      darwin.cctools
    ];
}
