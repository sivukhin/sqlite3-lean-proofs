import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000122

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=3 db=0 mode=read name=
    cursor=1 rootpage=4 db=0 mode=read name=

  Query: SELECT y.* FROM t3 as y, t4 as z
    

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     11    0                    0   
  1     OpenRead       0     3     0     2              0   
  2     OpenRead       1     4     0     0              0   
  3     Rewind         0     10    0                    0   
  4     Rewind         1     10    0                    0   
  5     Column         0     0     1                    0   
  6     Column         0     1     2                    0   
  7     ResultRow      1     2     0                    0   
  8     Next           1     5     0                    1   
  9     Next           0     4     0                    1   
  10    Halt           0     0     0                    0   
  11    Transaction    0     0     9     0              1   
  12    Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 11 0 "" 0,  -- 0: Init
  vdbeOpenRead 0 3 0 "2" 0,  -- 1: OpenRead
  vdbeOpenRead 1 4 0 "0" 0,  -- 2: OpenRead
  vdbeRewind 0 10 0 "" 0,  -- 3: Rewind
  vdbeRewind 1 10 0 "" 0,  -- 4: Rewind
  vdbeColumn 0 0 1 "" 0,  -- 5: Column
  vdbeColumn 0 1 2 "" 0,  -- 6: Column
  vdbeResultRow 1 2 0 "" 0,  -- 7: ResultRow
  vdbeNext 1 5 0 "" 1,  -- 8: Next
  vdbeNext 0 4 0 "" 1,  -- 9: Next
  vdbeHalt 0 0 0 "" 0,  -- 10: Halt
  vdbeTransaction 0 0 9 "0" 1,  -- 11: Transaction
  vdbeGoto 0 1 0 "" 0  -- 12: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000122
