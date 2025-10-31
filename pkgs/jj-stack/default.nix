{ lib, buildNpmPackage, fetchFromGitHub }: buildNpmPackage (finalAttrs: {
  pname = "jj-stack";
  version = "1.2.1";
  src = fetchFromGitHub {
    owner = "keanemind";
    repo = "jj-stack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fk+FZv4lu+noM6ig4NFGAlRy4AWdEjkLIDZZ877bKLs=";
  };
  npmDepsHash = "sha256-RVOnxdzSpgyxfS+EZS1oIlX+chUl8GyLXKrmVlEmLPg=";
  npmPackFlags = [ "--ignore-scripts" ];

  NODE_OPTIONS = "--openssl-legacy-provider";

  meta = {
    description = "Stacked PRs on GitHub for Jujutsu ";
    homepage = "https://github.com/keanemind/jj-stack/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ insipx ];
  };
})
