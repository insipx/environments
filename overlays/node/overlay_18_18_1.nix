self: super: {
  nodejs_18 =
    super.nodejs_18.overrideAttrs (oldAttrs: { version = "18.18.1"; });
}
