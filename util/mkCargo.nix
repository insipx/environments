# make a shell with standard common cargo tools
{ cargo-cache
, cargo-expand
, cargo-machete
, cargo-features-manager
, cargo-bloat
, cargo-mutants
, cargo-deny
, cargo-audit
, cargo-nextest
, cargo-udeps
, extraInputs ? { }
, mkShell
, ...
}: (mkShell
  {
    buildInputs = [
      cargo-cache
      cargo-expand
      cargo-machete
      cargo-features-manager
      cargo-bloat
      cargo-mutants
      cargo-deny
      cargo-audit
      cargo-nextest
      cargo-udeps
    ];
  } // extraInputs)
