# make a shell with an environment for rust and wasm dev
{ twiggy
, binaryen
, wasm-pack
, wabt
, chromedriver
, google-chrome
, geckodriver
, mkShell
, extraInputs ? { }
, ...
}: (mkShell
  {
    buildInputs = [
      twiggy
      binaryen
      wasm-pack
      wabt
      chromedriver
      google-chrome
      geckodriver
    ];
  } // extraInputs)
