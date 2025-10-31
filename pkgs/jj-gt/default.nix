{ writeShellScriptBin, fetchFromGitHub }:
let
  # https://gist.github.com/riwsky/38b17ea3fca70acf20a18c752663aff4/e65933ddd40e0d25d23be85766583fc370d57008
  # https://gist.github.com/riwsky/38b17ea3fca70acf20a18c752663aff4
  src = fetchFromGitHub {
    owner = "riwsky";
    repo = "38b17ea3fca70acf20a18c752663aff4";
    rev = "e65933ddd40e0d25d23be85766583fc370d57008";
    hash = "sha256-yqiNU6Q6uy5hRD/+nfTsTOSgBG1LDdC3LOdDIbOFu3s=";
    githubBase = "gist.github.com";
  };
in
writeShellScriptBin "jj-gt" (builtins.readFile "${src}/jts")
