{ pkgs ? import <nixpkgs> { }, ... }:

let
  # A list of binaries to put into separate outputs
  bins = [ "geth" "clef" ];

in pkgs.buildGoModule rec {
  pname = "go-ethereum";
  version = "1.13.2";

  frameworks = pkgs.darwin.apple_sdk.frameworks;

  src = pkgs.fetchFromGitHub {
    owner = "ethereum";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-tomzF0jM1tcxnnBHLfNWcR1XGECxU8Q/SQAWQBRAFW8=";
  };

  vendorHash = "sha256-VX2S7yjdcconPd8wisV+Cl6FVuEUGU7smIBKfTxpUVY=";

  doCheck = false;

  outputs = [ "out" ] ++ bins;

  # Move binaries to separate outputs and symlink them back to $out
  postInstall = pkgs.lib.concatStringsSep "\n" (builtins.map (bin:
    "mkdir -p \$${bin}/bin && mv $out/bin/${bin} \$${bin}/bin/ && ln -s \$${bin}/bin/${bin} $out/bin/")
    bins);

  subPackages = [
    "cmd/abidump"
    "cmd/abigen"
    "cmd/bootnode"
    "cmd/clef"
    "cmd/devp2p"
    "cmd/ethkey"
    "cmd/evm"
    "cmd/faucet"
    "cmd/geth"
    "cmd/p2psim"
    "cmd/rlpdump"
    "cmd/utils"
  ];

  # Following upstream: https://github.com/ethereum/go-ethereum/blob/v1.11.6/build/ci.go#L218
  tags = [ "urfave_cli_no_docs" ];

  # Fix for usb-related segmentation faults on darwin
  propagatedBuildInputs = pkgs.lib.optionals pkgs.stdenv.isDarwin [
    pkgs.darwin.libobjc
    frameworks.IOKit
  ];

  passthru.tests = { inherit (pkgs.nixosTests) geth; };

}
