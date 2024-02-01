{ pkgs, ... }:

let linters = import ./linters.nix { inherit pkgs; };
in pkgs.mkShell { buildInputs = with pkgs; [ linters curl ]; }
