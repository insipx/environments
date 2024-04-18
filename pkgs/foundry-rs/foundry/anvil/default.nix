{ pkgs ? import <nixpkgs> { }, applePkgs, rust-toolchain, src, cargoLock, ... }:
(pkgs.makeRustPlatform {
  cargo = rust-toolchain;
  rustc = rust-toolchain;
}).buildRustPackage {
  inherit src cargoLock;
  pname = "anvil";
  version = "0.2.0";
  cargoBuildFlags = "-p anvil";
  doCheck = false;
  nativeBuildInputs = with pkgs;
    [ pkg-config ] ++ lib.optionals pkgs.stdenv.isDarwin [ darwin.DarwinTools ];
  buildInputs = with pkgs;
    [ clang gcc openssl ] ++ lib.optionals pkgs.stdenv.isDarwin applePkgs;
  preBuild = ''
    export CARGO_LOG=info
  '';
  passthru.updateScript = pkgs.lib.nix-update-script {
    # TODO: Remove this once `foundry` starts providing stable releases.
    extraArgs = [ "--version-regex" "nightly-(.*)" ];
  };
  env = {
    SVM_RELEASES_LIST_JSON = if pkgs.stdenv.isDarwin then
      "${./svm-lists/macosx-amd64.json}"
    else
      "${./svm-lists/linux-amd64.json}";
  };
}

