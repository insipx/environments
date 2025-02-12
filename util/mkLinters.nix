# A bunch of linting and formatting I use w/o an LSP
{ dprint
, stylua
, deno
, nixfmt
, yamlfmt
, rubyPackages
, dotenv-linter
, gitlint
, html-tidy
, statix
, deadnix
, markdownlint-cli
, shellcheck
, golangci-lint
, ktlint
, mkShell
, taplo
, extraInputs ? { }
}:
(mkShell
  {
    name = "Common Linters + Formatters";
    buildInputs = [
      taplo
      dprint
      stylua
      deno
      nixfmt
      yamlfmt
      rubyPackages.htmlbeautifier

      # Linters
      # cbfmt
      dotenv-linter
      gitlint
      html-tidy
      statix
      deadnix
      markdownlint-cli
      shellcheck
      golangci-lint
      ktlint
    ];

  } // extraInputs)



