{ nixpkgs, fenix, solc, system, ... }:
let custom_overlays = import ./overlays;
in {
  #withNodejs14 = import nixpkgs {
  #  inherit system;
  #  overlays = with overlays; [
  #    # go_1_21_3
  #    # nodejs_14_21_3
  #    fenix.overlays.default
  #    solc.overlay
  #  ];
  #};
  #withGo1_21_3 = import nixpkgs {
  #  inherit system;
  #  overlays = with overlays; [ go_1_21_3 ];
  #};
  withGo1_20 = import nixpkgs {
    inherit system;
    overlays = [ custom_overlays.go_1_20 ];
  };
  withRust = import nixpkgs {
    inherit system;
    overlays = [ fenix.overlays.default ];
  };
  withRustAndSolc = import nixpkgs {
    inherit system;
    overlays = [ fenix.overlays.default solc.overlay ];
  };
}
