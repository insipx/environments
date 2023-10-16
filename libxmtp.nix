{ pkgs, inputs, devenv, ... }:

let
  isDarwin = pkgs.hostPlatform.isDarwin;
  frameworks = pkgs.darwin.apple_sdk.frameworks;
in devenv.lib.mkShell {
  inherit inputs pkgs;
  modules = [{
    packages = with pkgs;
      [
        pkg-config
        clang
        gcc
        mktemp
        jdk21
        kotlin
        markdownlint-cli
        shellcheck
        buf
      ] ++ lib.optionals isDarwin [
        libiconv
        frameworks.AppKit
        frameworks.CoreFoundation
        frameworks.Security
        frameworks.SystemConfiguration
      ];
    languages.rust = {
      enable = true;
      channel = "stable";
    };
    enterShell = ''
      echo "LibXMTP Rust Environment"
    '';
  }];
}
