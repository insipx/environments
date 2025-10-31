{ nixpkgs, fenix, foundry, system, mkshell-util, ... }:
let
  mkPkgs = extraConfig: import nixpkgs
    ({
      inherit system;
      overlays = [ foundry.overlay ];
    } // extraConfig);
  # https://nix.dev/tutorials/callpackage
  callPackage = pkgs: pkgs.lib.callPackageWith ((mkShellWrappers pkgs) // pkgs);
  mkShellWrappers = pkgs: mkshell-util callPackage pkgs;
in
{
  inherit callPackage;
  pkgs = mkPkgs { };
  pkgsUnfree = mkPkgs {
    config.allowUnfree = true;
  };
  pkgsAndroid = mkPkgs {
    config = {
      android_sdk.accept_license = true;
      allowUnfree = true;
    };
  };
  pkgsRust = mkPkgs {
    overlays = [ fenix.overlays.default ];
    config = {
      allowUnfree = true;
      android_sdk.accept_license = true;
    };
  };
}
