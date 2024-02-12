{ nixpkgs, fenix, solc, system, ... }:
let overlays = import ./overlays;
in {
  withNodejs14 = import nixpkgs {
    inherit system;
    overlays = with overlays; [
      # go_1_21_3
      # nodejs_14_21_3
      fenix.overlays.default
      solc.overlay
    ];
  };
  withGo = import nixpkgs {
    inherit system;
    overlays = with overlays; [ go_1_21_3 fenix.overlays.default ];
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
