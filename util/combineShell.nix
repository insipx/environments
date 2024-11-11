{ otherShells ? [ ]
, mkShell
, hello
}:
mkShell {
  inputsFrom = [ hello ] ++ otherShells;
}
