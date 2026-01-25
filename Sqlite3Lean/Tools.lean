import Lean

namespace Sqlite3Lean.Tools

open Lean Elab Command Meta Term

private def isArithmetic (e : Expr) : Bool :=
  e.isAppOf `HAdd.hAdd || e.isAppOf `HMul.hMul ||
  e.isAppOf `Nat.add || e.isAppOf `Nat.mul

private def stringContains (haystack : String) (needle : String) : Bool :=
  (haystack.splitOn needle).length > 1

private def nameContains (n : Name) (s : String) : Bool :=
  stringContains n.toString s

-- Find the main arithmetic expression (the running case body)
private partial def findArithmeticExpr (e : Expr) : MetaM Expr := do
  -- Look for HAdd.hAdd or HMul.hMul at the top level or in subexpressions
  match e with
  | .mdata _ inner => findArithmeticExpr inner
  | .letE _ _ val body _ =>
    -- Check body first (more likely to have the result)
    let bodyResult ← findArithmeticExpr body
    if isArithmetic bodyResult then pure bodyResult
    else findArithmeticExpr val
  | .lam _ _ body _ => findArithmeticExpr body
  | .app _ _ =>
    -- Check if this is arithmetic
    if isArithmetic e then
      pure e
    else
      -- Check if it's a match/casesOn - look for the last argument (running case)
      let fn := e.getAppFn
      let args := e.getAppArgs
      if fn.isConst then
        let name := fn.constName!
        -- Status.casesOn has structure: casesOn motive target hHalted hError hRunning
        -- The running case is the last argument
        if nameContains name "casesOn" || nameContains name "match" then
          if args.size > 0 then
            -- Try last few arguments (they're the branches)
            for i in [0:args.size] do
              let idx := args.size - 1 - i
              let arg := args[idx]!
              let result ← findArithmeticExpr arg
              if isArithmetic result then
                return result
      -- Otherwise recurse on all args
      let mut best := e
      for arg in args do
        let result ← findArithmeticExpr arg
        if isArithmetic result then
          best := result
          break
      pure best
  | _ => pure e

-- Extract the running case from a match on state.status
private def extractRunningCase (e : Expr) (_stateArg : Expr) : MetaM Expr := do
  -- Direct approach: walk the expression tree to find arithmetic
  let result ← findArithmeticExpr e
  pure result

-- Simplify Option.rec patterns to readable form
private def simplifyOptionRec (e : Expr) : MetaM (Option String) := do
  -- Pattern: Option.rec defaultVal (fun val => ...) optExpr
  if e.isAppOf `Option.rec then
    let args := e.getAppArgs
    -- Option.rec has args: motive, none_case, some_case, opt_value
    if args.size >= 4 then
      let noneCase := args[args.size - 3]!
      let optValue := args[args.size - 1]!
      -- Check if none case is 0
      let noneReduced ← reduce noneCase
      if noneReduced == .lit (.natVal 0) then
        -- This is "match db X with none => 0 | some btree => btree.tuples.length"
        -- Simplify to "n" where n is the btree tuple count
        return some "n"
  return none

-- Analyze the gas expression structure by walking the Expr
private partial def analyzeGasStructure (e : Expr) (stateArg : Expr) : MetaM String := do
  -- First try to simplify Option.rec patterns
  if let some simplified ← simplifyOptionRec e then
    return simplified

  -- Check if it's an addition: HAdd.hAdd _ _ _ _ lhs rhs
  if e.isAppOf `HAdd.hAdd then
    let args := e.getAppArgs
    if args.size >= 2 then
      let lhs := args[args.size - 2]!
      let rhs := args[args.size - 1]!
      let lhsStr ← analyzeGasStructure lhs stateArg
      let rhsStr ← analyzeGasStructure rhs stateArg
      -- Combine repeated n's
      if lhsStr == "n" && rhsStr == "n" then
        return "2 * n"
      else if lhsStr.endsWith "* n" && rhsStr == "n" then
        -- Extract coefficient and increment
        let parts := lhsStr.splitOn " * "
        if parts.length == 2 then
          if let some coef := parts[0]!.toNat? then
            return s!"{coef + 1} * n"
      -- Combine constant additions: "X + c1 + c2" -> "X + (c1+c2)"
      if let some c2 := rhsStr.toNat? then
        -- rhs is a constant, check if lhs ends with "+ <num>"
        let parts := lhsStr.splitOn " + "
        if parts.length >= 2 then
          let lastPart := parts[parts.length - 1]!
          if let some c1 := lastPart.toNat? then
            let lhsPrefix := " + ".intercalate (parts.take (parts.length - 1))
            return s!"{lhsPrefix} + {c1 + c2}"
      return s!"{lhsStr} + {rhsStr}"

  -- Check if it's a multiplication: HMul.hMul _ _ _ _ lhs rhs
  if e.isAppOf `HMul.hMul then
    let args := e.getAppArgs
    if args.size >= 2 then
      let lhs := args[args.size - 2]!
      let rhs := args[args.size - 1]!
      let lhsStr ← analyzeGasStructure lhs stateArg
      let rhsStr ← analyzeGasStructure rhs stateArg
      return s!"{lhsStr} * {rhsStr}"

  -- Check for Nat.succ chains
  if e.isAppOf `Nat.succ then
    let mut count := 0
    let mut current := e
    while current.isAppOf `Nat.succ do
      count := count + 1
      current := current.getAppArgs[0]!
    let baseStr ← analyzeGasStructure current stateArg
    if baseStr == "0" then
      return s!"{count}"
    else
      return s!"{baseStr} + {count}"

  -- Check for literal
  match e with
  | .lit (.natVal n) => return s!"{n}"
  | _ => pure ()

  -- Check if this involves the state
  if e.containsFVar stateArg.fvarId! then
    -- It's a function of the state - pretty print it
    return s!"{← ppExpr e}"

  -- Try to evaluate constant expressions
  try
    let reduced ← reduce e
    match reduced with
    | .lit (.natVal n) => return s!"{n}"
    | _ => return s!"{← ppExpr e}"
  catch _ =>
    return s!"{← ppExpr e}"

elab "#analyze_def" id:ident : command => do
  let name ← resolveGlobalConstNoOverload id
  let env ← getEnv
  let some info := env.find? name | throwError "Definition '{name}' not found"

  liftTermElabM do
    let some val := info.value? | throwError "'{name}' has no value (is it an axiom?)"

    -- Unfold the gas definition fully
    let unfolded ← unfoldDefinition? val
    let unfolded := unfolded.getD val

    -- The gas function should be: fun state => match state.status with ...
    lambdaTelescope unfolded fun args body => do
      if args.size == 0 then
        throwError "Expected lambda, got: {← ppExpr unfolded}"

      let stateArg := args[0]!

      -- Find and extract the running case from the match
      let runningExpr ← extractRunningCase body stateArg

      -- Extract the symbolic structure
      let gasStructure ← analyzeGasStructure runningExpr stateArg

      -- Now evaluate with initial state: mkInitialState db
      -- Create a fresh variable for the database
      withLocalDeclD `db (mkConst `Sqlite3Lean.Vdbe.Database) fun dbVar => do
        -- Build: mkInitialState db
        let initialState ← mkAppM `Sqlite3Lean.Vdbe.mkInitialState #[dbVar]

        -- Substitute state with initialState in the running expression
        let substituted := runningExpr.replaceFVar stateArg initialState

        -- Reduce/unfold the expression
        let reduced ← reduce substituted (skipTypes := false) (skipProofs := true)

        -- Try to simplify further
        let finalSimplified ← try
          let ctx ← Simp.Context.mkDefault
          let (result, _) ← simp reduced ctx
          pure result.expr
        catch _ =>
          pure reduced

        -- Analyze the structure for initial state
        let initialStructure ← analyzeGasStructure finalSimplified dbVar

        -- Log in the standard format
        logInfo m!"'{name}' has gas bound: {initialStructure}"

end Sqlite3Lean.Tools
