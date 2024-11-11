# Custom mkShells/CallPackages that include useful default packages
# Meant to be called with `callPackageWith`
# These packages may depend on each other
# tutorial: https://nix.dev/tutorials/callpackage
callPackage: pkgs: {
  shells = {
    mkLinters = extraInputs: (callPackage pkgs ./mkLinters.nix {
      inherit extraInputs;
    });

    mkCargo = extraInputs: (callPackage pkgs ./mkCargo.nix {
      inherit extraInputs;
    });

    mkRustWasm = extraInputs: (callPackage pkgs ./mkRustWasm.nix { inherit extraInputs; });

    combineShell = otherShells: (callPackage pkgs ./combineShell.nix { inherit otherShells; });
  };
}