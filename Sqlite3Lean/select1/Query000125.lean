import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000125

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):

  Query: SELECT 1 AS 'a','hello' AS 'b',2 AS 'c'
    

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     6     0                    0   
  1     Integer        1     1     0                    0   
  2     String8        0     2     0     hello          0   
  3     Integer        2     3     0                    0   
  4     ResultRow      1     3     0                    0   
  5     Halt           0     0     0                    0   
  6     Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 6 0 "" 0,  -- 0: Init
  vdbeInteger 1 1 0 "" 0,  -- 1: Integer
  vdbeString8 0 2 0 "hello" 0,  -- 2: String8
  vdbeInteger 2 3 0 "" 0,  -- 3: Integer
  vdbeResultRow 1 3 0 "" 0,  -- 4: ResultRow
  vdbeHalt 0 0 0 "" 0,  -- 5: Halt
  vdbeGoto 0 1 0 "" 0  -- 6: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000125
