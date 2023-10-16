{ pkgs, ... }:

let
  # A list of binaries to put into separate outputs
  bins = [ "geth" "clef" ];
  frameworks = pkgs.darwin.apple_sdk.frameworks;
in pkgs.buildGoModule rec {
  pname = "go-ethereum";
  version = "1.13.2";

  go = pkgs.go_1_21;

  src = pkgs.fetchFromGitHub {
    owner = "ethereum";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-iWNt2cCrjf8eaEay8zLu0GmnAhwVbzsYAfWBHuNSiDs=";
  };

  vendorHash = "sha256-BKAE4i4nw2b9aoFvM7FFrSHT60G42GQHriuptaIjXLQ=";

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

}
