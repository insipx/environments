{ foundry
, go-ethereum
, mkShell
, nodePackages
, nodejs
, ...
}: mkShell {

  buildInputs = [
    foundry
    go-ethereum
    nodejs
    # make sure to use nodePackages! or it will install yarn irrespective of environmental node.
    nodePackages.yarn
  ];
}
