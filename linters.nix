# A bunch of linting and formatting I use w/o an LSP
{ pkgs }:
pkgs.buildEnv {
  name = "Linters and Formatters for Nvim Config";
  paths = with pkgs; [
    dprint
    stylua
    deno
    nixfmt
    yamlfmt
    rubyPackages.htmlbeautifier
    # codespell

    # Linters
    # cbfmt
    dotenv-linter
    gitlint
    html-tidy
    statix
    deadnix
  ];
}
