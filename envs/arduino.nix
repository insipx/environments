{ shells
, stdenv
, darwin
, lib
, system
, fenix
, pkg-config
, fblog
, avrdude
, fetchCrate
, makeRustPlatform
, ...
}:

let
  inherit (stdenv) isDarwin;
  inherit (darwin.apple_sdk) frameworks;
  inherit (shells) combineShell;
  fenixPkgs = fenix.packages.${system};
  mkShell =
    top:
    (combineShell
      (with shells; [
        mkLinters
        mkCargo
      ])
      top);

  rust-toolchain = fenixPkgs.combine (with fenixPkgs; [
    minimal.rustc
    minimal.cargo
    targets.wasm32-unknown-unknown.latest.rust-std
  ]);

  rustPlatform = makeRustPlatform {
    cargo = rust-toolchain;
    rustc = rust-toolchain;
  };
  ravedude-common = {
    pname = "ravedude";
    version = "0.1.8";
  };
  ravedude = rustPlatform.buildRustPackage {
    inherit (ravedude-common) pname version;
    src = fetchCrate {
      inherit (ravedude-common) pname version;
      hash = "sha256-AvnojcWQ4dQKk6B1Tjhkb4jfL6BJDsbeEo4tlgbOp84=";
    };
    cargoSha256 = "sha256-dCRKGB/dfUMPGmR42oQiqyF4CB+K5fIAHvwqfNmNBfQ=";
  };
in
mkShell {
  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    [
      rust-toolchain
      fenixPkgs.rust-analyzer
      fblog
      ravedude
      avrdude
    ]
    ++ lib.optionals isDarwin [
      frameworks.CoreServices
      frameworks.Carbon
      darwin.cctools
    ];
}
