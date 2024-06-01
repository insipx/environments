self: super: {
  go_1_20 = super.go.overrideAttrs (oldAttrs:
    let version = "1.20";
    in {
      inherit version;
      src = super.fetchurl {
        url = "https://dl.google.com/go/go${version}.src.tar.gz";
        sha256 = "sha256-0000000000000000000000000000000000000000000=";
      };
    });
}
