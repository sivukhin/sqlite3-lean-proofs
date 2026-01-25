import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000123

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):

  Query: SELECT 1+2+3
    

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     4     0                    0   
  1     Add            3     2     1                    0   
  2     ResultRow      1     1     0                    0   
  3     Halt           0     0     0                    0   
  4     Integer        1     4     0                    0   
  5     Integer        2     5     0                    0   
  6     Add            5     4     2                    0   
  7     Integer        3     3     0                    0   
  8     Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 4 0 "" 0,  -- 0: Init
  vdbeAdd 3 2 1 "" 0,  -- 1: Add
  vdbeResultRow 1 1 0 "" 0,  -- 2: ResultRow
  vdbeHalt 0 0 0 "" 0,  -- 3: Halt
  vdbeInteger 1 4 0 "" 0,  -- 4: Integer
  vdbeInteger 2 5 0 "" 0,  -- 5: Integer
  vdbeAdd 5 4 2 "" 0,  -- 6: Add
  vdbeInteger 3 3 0 "" 0,  -- 7: Integer
  vdbeGoto 0 1 0 "" 0  -- 8: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000123
