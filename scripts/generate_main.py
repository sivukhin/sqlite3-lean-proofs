#!/usr/bin/env python3
"""Generate Main.lean with axiom checks for all query files."""

import os
from pathlib import Path

def find_query_files(base_dir: Path) -> list[str]:
    """Find all Query*.lean files in select1 directory."""
    select1_dir = base_dir / "Sqlite3Lean" / "select1"
    if not select1_dir.exists():
        return []

    query_files = []
    for f in sorted(select1_dir.glob("Query*.lean")):
        # Extract query name without .lean extension
        name = f.stem  # e.g., "Query000001"
        query_files.append(name)

    return query_files

def generate_main_lean(base_dir: Path, query_files: list[str]) -> str:
    """Generate Main.lean content."""
    lines = []

    # Imports
    lines.append("import Sqlite3Lean.Tools")
    lines.append("import Sqlite3Lean.Vdbe")
    lines.append("import Sqlite3Lean.VdbeLemmas")
    lines.append("import Sqlite3Lean.Example")
    for name in query_files:
        lines.append(f"import Sqlite3Lean.select1.{name}")
    lines.append("")

    # Open namespaces
    lines.append("open Sqlite3Lean.Vdbe")
    lines.append("open Sqlite3Lean.VdbeLemmas")
    lines.append("")

    # Example
    lines.append("-- Example")
    lines.append("#print axioms Sqlite3Lean.Example.program")
    lines.append("#print axioms Sqlite3Lean.Example.program_terminates")
    lines.append("#print axioms Sqlite3Lean.Example.program_gas")
    lines.append("#analyze_def Sqlite3Lean.Example.program_gas")
    lines.append("example (db : Database) : ∃ n : Nat, (runBounded Sqlite3Lean.Example.program (mkInitialState db) n).status ≠ .running := Sqlite3Lean.Example.program_terminates db")
    lines.append("example (db : Database) : (runBounded Sqlite3Lean.Example.program (mkInitialState db) (Sqlite3Lean.Example.program_gas (mkInitialState db))).status ≠ .running := Sqlite3Lean.Example.program_terminates' db")
    lines.append("")

    # Each query file
    for name in query_files:
        namespace = f"Sqlite3Lean.select1.{name}"
        lines.append(f"-- {name}")
        lines.append(f"#print axioms {namespace}.program")
        lines.append(f"#print axioms {namespace}.program_terminates")
        lines.append(f"#print axioms {namespace}.program_gas")
        lines.append(f"#analyze_def {namespace}.program_gas")
        lines.append(f"example (db : Database) : ∃ n : Nat, (runBounded {namespace}.program (mkInitialState db) n).status ≠ .running := {namespace}.program_terminates db")
        lines.append(f"example (db : Database) : (runBounded {namespace}.program (mkInitialState db) ({namespace}.program_gas (mkInitialState db))).status ≠ .running := {namespace}.program_terminates' db")
        lines.append("")

    # Main function
    lines.append("def main : IO Unit := do")
    lines.append('  IO.println "sqlite3-lean"')
    lines.append("")

    return "\n".join(lines)

def main():
    # Find project root (directory containing Main.lean)
    script_dir = Path(__file__).parent
    base_dir = script_dir.parent

    query_files = find_query_files(base_dir)
    print(f"Found {len(query_files)} query files")

    content = generate_main_lean(base_dir, query_files)

    main_path = base_dir / "Main.lean"
    with open(main_path, "w") as f:
        f.write(content)

    print(f"Generated {main_path}")

if __name__ == "__main__":
    main()
