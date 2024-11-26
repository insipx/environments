{ pkgs, ... }:

let
  inherit (pkgs.stdenv) isDarwin;
  inherit (pkgs.darwin.apple_sdk) frameworks;
  linters = import ./../linters.nix { inherit pkgs; };
  go-lang = import ./../language-packs/go.nix { inherit pkgs; };
  withGo = import <nixpkgs> {
    overlays = [
      (self: super: {
        go = super.go.overrideAttrs (
          oldAttrs:
          let
            version = "1.20";
          in
          {
            inherit version;
            src = super.fetchurl {
              url = "https://dl.google.com/go/go${version}.src.tar.gz";
              sha256 = "sha256-Oin/BCG+r2MpKSuKRjEcn78GyAAHfO3e9ft/jVsazjM=";
            };
          }
        );
      })
    ];
  };
in
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [ pkg-config ];
  buildInputs =
    with pkgs;
    [
      withGo.go
      mktemp
      buf
      curl
      linters
      go-lang
      protobuf
      protoc-gen-prost-crate
      protolint
      mockgen
      moreutils
      protoc-gen-go
    ]
    ++ lib.optionals isDarwin [
      frameworks.CoreServices
      frameworks.Carbon
      frameworks.ApplicationServices
      frameworks.AppKit
      darwin.cctools
    ];
}
