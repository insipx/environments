# make a shell with standard common cargo tools
{ cargo-cache
, cargo-machete
, cargo-features-manager
, cargo-bloat
, cargo-mutants
, cargo-deny
, cargo-audit
, cargo-nextest
, cargo-udeps
, cargo-generate
, extraInputs ? { }
, mkShell
, ...
}: (mkShell
  {
    buildInputs = [
      cargo-cache
      cargo-machete
      cargo-features-manager
      cargo-bloat
      cargo-mutants
      cargo-deny
      cargo-audit
      cargo-nextest
      cargo-udeps
      cargo-generate
    ];
  } // extraInputs)
