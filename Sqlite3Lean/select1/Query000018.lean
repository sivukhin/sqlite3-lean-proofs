import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000018

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=3 db=0 mode=read name=

  Query: SELECT * FROM t3;

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     8     0                    0   
  1     OpenRead       0     3     0     2              0   
  2     Rewind         0     7     0                    0   
  3     Column         0     0     1                    0   
  4     Column         0     1     2                    0   
  5     ResultRow      1     2     0                    0   
  6     Next           0     3     0                    1   
  7     Halt           0     0     0                    0   
  8     Transaction    0     0     5     0              1   
  9     Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 8 0 "" 0,  -- 0: Init
  vdbeOpenRead 0 3 0 "2" 0,  -- 1: OpenRead
  vdbeRewind 0 7 0 "" 0,  -- 2: Rewind
  vdbeColumn 0 0 1 "" 0,  -- 3: Column
  vdbeColumn 0 1 2 "" 0,  -- 4: Column
  vdbeResultRow 1 2 0 "" 0,  -- 5: ResultRow
  vdbeNext 0 3 0 "" 1,  -- 6: Next
  vdbeHalt 0 0 0 "" 0,  -- 7: Halt
  vdbeTransaction 0 0 5 "0" 1,  -- 8: Transaction
  vdbeGoto 0 1 0 "" 0  -- 9: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000018
