# A bunch of linting and formatting I use w/o an LSP
{ pkgs }:
pkgs.buildEnv {
  name = "Linters and Formatters for Nvim Config";
  paths = with pkgs; [
    gotools
    gopls
    golangci-lint
    delve
    richgo
    ginkgo
    gotests
    govulncheck
    iferr
    reftools
    golines
    gomodifytags
    gofumpt
    impl
    gotestsum
  ];
}
