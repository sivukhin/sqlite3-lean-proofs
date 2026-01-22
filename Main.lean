import Sqlite3Lean.SelectStarProof

def main : IO Unit := do
  IO.println "Running SELECT * FROM t simulation..."
  IO.println ""
  let result := Sqlite3Lean.Vdbe.runSelectExample
  IO.println s!"Status: {repr result.status}"
  IO.println s!"Output rows: {result.output.length}"
  for row in result.output do
    IO.println s!"  Row: {repr row}"
