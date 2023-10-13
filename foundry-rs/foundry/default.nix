{ pkgs ? import <nixpkgs> { } }:
# let manifest = (pkgs.lib.importTOML ./Cargo.toml).package;

let naerskLib = pkgs.callPackage naersk { };
in {
  anvil = naerskLib.buildPackage {
    name = "anvil";
    # version = "0.2.0";
    cargoBuildOptions = x: x ++ [ "-p anvil" ];
    src = pkgs.fetchFromGitHub {
      owner = "foundry-rs";
      repo = "foundry";
      rev = version;
      # hash = "";
    };
    doCheck = false;
    # cargoSha256 = "sha256-4rLjjOGxUBlBP4/iZpV5VSnJ+fvwF5TCRd4s4lgaZXg=";
  };
}
