import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000080

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):

  Query: SELECT 123.45;

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     4     0                    0   
  1     Real           0     1     0     123.45         0   
  2     ResultRow      1     1     0                    0   
  3     Halt           0     0     0                    0   
  4     Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 4 0 "" 0,  -- 0: Init
  vdbeReal 0 1 0 "123.45" 0,  -- 1: Real
  vdbeResultRow 1 1 0 "" 0,  -- 2: ResultRow
  vdbeHalt 0 0 0 "" 0,  -- 3: Halt
  vdbeGoto 0 1 0 "" 0  -- 4: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000080
