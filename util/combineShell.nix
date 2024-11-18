{ otherShells ? [ ]
, mkShell
, hello
, extraInputs
}:
let
  # Evaluate the fn if its a function, otherwise leave it alone
  fnOrSet = x:
    if builtins.isFunction x then
      x { }
    else
      x;
  evaluatedShells = builtins.map (x: (fnOrSet x)) otherShells;
in
mkShell ({
  inputsFrom = [ hello ] ++ evaluatedShells;
} // extraInputs)
