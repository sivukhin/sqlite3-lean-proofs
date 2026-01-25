import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000020

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=1 rootpage=2 db=0 mode=read name=

  Query: SELECT Count() FROM test1

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     7     0                    0   
  1     OpenRead       1     2     0     1              0   
  2     Count          1     1     0                    0   
  3     Close          1     0     0                    0   
  4     Copy           1     2     0                    0   
  5     ResultRow      2     1     0                    0   
  6     Halt           0     0     0                    0   
  7     Transaction    0     0     5     0              1   
  8     Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 7 0 "" 0,  -- 0: Init
  vdbeOpenRead 1 2 0 "1" 0,  -- 1: OpenRead
  vdbeCount 1 1 0 "" 0,  -- 2: Count
  vdbeClose 1 0 0 "" 0,  -- 3: Close
  vdbeCopy 1 2 0 "" 0,  -- 4: Copy
  vdbeResultRow 2 1 0 "" 0,  -- 5: ResultRow
  vdbeHalt 0 0 0 "" 0,  -- 6: Halt
  vdbeTransaction 0 0 5 "0" 1,  -- 7: Transaction
  vdbeGoto 0 1 0 "" 0  -- 8: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000020
