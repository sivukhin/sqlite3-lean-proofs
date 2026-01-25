import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000087

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=
    cursor=1 rootpage=8 db=0 mode=read name=

  Query: SELECT f1, t1 FROM test1, test2 LIMIT 1
    

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     13    0                    0   
  1     Integer        1     1     0                    0   
  2     OpenRead       0     2     0     1              0   
  3     OpenRead       1     8     0     1              0   
  4     Rewind         0     12    0                    0   
  5     Rewind         1     12    0                    0   
  6     Column         0     0     2                    0   
  7     Column         1     0     3                    0   
  8     ResultRow      2     2     0                    0   
  9     DecrJumpZero   1     12    0                    0   
  10    Next           1     6     0                    1   
  11    Next           0     5     0                    1   
  12    Halt           0     0     0                    0   
  13    Transaction    0     0     8     0              1   
  14    Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 13 0 "" 0,  -- 0: Init
  vdbeInteger 1 1 0 "" 0,  -- 1: Integer
  vdbeOpenRead 0 2 0 "1" 0,  -- 2: OpenRead
  vdbeOpenRead 1 8 0 "1" 0,  -- 3: OpenRead
  vdbeRewind 0 12 0 "" 0,  -- 4: Rewind
  vdbeRewind 1 12 0 "" 0,  -- 5: Rewind
  vdbeColumn 0 0 2 "" 0,  -- 6: Column
  vdbeColumn 1 0 3 "" 0,  -- 7: Column
  vdbeResultRow 2 2 0 "" 0,  -- 8: ResultRow
  vdbeDecrJumpZero 1 12 0 "" 0,  -- 9: DecrJumpZero
  vdbeNext 1 6 0 "" 1,  -- 10: Next
  vdbeNext 0 5 0 "" 1,  -- 11: Next
  vdbeHalt 0 0 0 "" 0,  -- 12: Halt
  vdbeTransaction 0 0 8 "0" 1,  -- 13: Transaction
  vdbeGoto 0 1 0 "" 0  -- 14: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000087
