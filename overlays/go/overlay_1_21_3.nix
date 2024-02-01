self: super: {
  go_1_21 = super.go_1_21.overrideAttrs (oldAttrs:
    let version = "1.21.3";
    in {
      inherit version;
      src = super.fetchurl {
        url = "https://dl.google.com/go/go${version}.src.tar.gz";
        sha256 = "sha256-GG8rb4yLcE5paCGwmrIEGlwe4T3LwxVqE63PdZMe5Ig=";
      };
    });
}
