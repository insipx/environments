{ pkgsAndroid, system, ... }:

let
  pkgs = pkgsAndroid;
  inherit (pkgs.stdenv) isDarwin;
  inherit (pkgs.darwin.apple_sdk) frameworks;
  linters = import ./../linters.nix { inherit pkgs; };
  androidComposition = pkgs.androidenv.composeAndroidPackages {
    includeNDK = true;
    platformToolsVersion = "33.0.3";
    platformVersions = [ "23" "24" "25" "26" "27" "28" "29" "30" "31" "32" "33" "34" ];
    buildToolsVersions = [ "30.0.3" ];
  };
  shellHook = ''
    export ANDROID_HOME="${androidComposition.androidsdk}/libexec/android-sdk"
    export ANDROID_NDK_ROOT="$ANDROID_HOME/ndk-bundle"
  '';
  #shellHook = ''
 #  export OPENSSL_DIR="${pkgs.openssl.dev}"
 #'';
in
pkgs.mkShell {
  inherit shellHook;
  nativeBuildInputs = with pkgs; [ pkg-config ];
  buildInputs = with pkgs;
    [
      androidComposition.androidsdk
      mktemp
      jdk17
      kotlin
      shellcheck
      buf
      curl
      android-studio-tools
      openssl
      sqlite
    ] ++ lib.optionals isDarwin [
      libiconv
      frameworks.CoreServices
      frameworks.Carbon
      frameworks.ApplicationServices
      frameworks.AppKit
      darwin.cctools
    ];
}
