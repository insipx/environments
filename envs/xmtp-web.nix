{ withRust, system, fenix, ... }:

let
  pkgs = withRust;
  isDarwin = pkgs.stdenv.isDarwin;
  frameworks = pkgs.darwin.apple_sdk.frameworks;
  fenixPkgs = fenix.packages.${system};
  linters = import ./../linters.nix { inherit pkgs; };
  foundryPkgs =
    import ./../pkgs/foundry-rs/foundry { inherit pkgs rust-toolchain; };
  src = pkgs.fetchFromGitHub {
    owner = "xmtp";
    repo = "libxmtp";
    rev = "main";
    hash = "sha256-XhZVQEPYS8i/Gk89ax0JIf0pOt88/pGHlej6+phUWQg=";
  };

  rust-toolchain = fenixPkgs.fromToolchainFile {
    file = "${src}/rust-toolchain";
    sha256 = "sha256-opUgs6ckUQCyDxcB9Wy51pqhd0MPGHUVbwRKKPGiwZU=";
  };

in pkgs.mkShell {
  nativeBuildInputs = with pkgs; [ pkg-config ];
  buildInputs = with pkgs;
    [
      rust-toolchain
      rust-analyzer
      # llvmPackages_16.libcxxClang
      mktemp
      jdk21
      kotlin
      shellcheck
      buf
      curl
      twiggy
      wasm-bindgen-cli
      binaryen
      linters
      inferno

      # make sure to use nodePackages! or it will install yarn irrespective of environmental node.
      nodejs
      nodePackages.yarn
    ] ++ lib.optionals isDarwin [
      libiconv
      frameworks.CoreServices
      frameworks.Carbon
      frameworks.ApplicationServices
      frameworks.AppKit
      darwin.cctools
    ];
}
