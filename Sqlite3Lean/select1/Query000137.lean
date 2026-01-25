import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000137

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=1 db=0 mode=read name=

  Query: SELECT * FROM sqlite_master WHERE rowid<=10;

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     14    0                    0   
  1     OpenRead       0     1     0     5              0   
  2     Rewind         0     13    0                    0   
  3     Integer        10    1     0                    0   
  4     Rowid          0     2     0                    0   
  5     Gt             1     13    2                    83  
  6     Column         0     0     3                    0   
  7     Column         0     1     4                    0   
  8     Column         0     2     5                    0   
  9     Column         0     3     6                    0   
  10    Column         0     4     7                    0   
  11    ResultRow      3     5     0                    0   
  12    Next           0     4     0                    0   
  13    Halt           0     0     0                    0   
  14    Transaction    0     0     18    0              1   
  15    Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 14 0 "" 0,  -- 0: Init
  vdbeOpenRead 0 1 0 "5" 0,  -- 1: OpenRead
  vdbeRewind 0 13 0 "" 0,  -- 2: Rewind
  vdbeInteger 10 1 0 "" 0,  -- 3: Integer
  vdbeRowid 0 2 0 "" 0,  -- 4: Rowid
  vdbeGt 1 13 2 "" 83,  -- 5: Gt
  vdbeColumn 0 0 3 "" 0,  -- 6: Column
  vdbeColumn 0 1 4 "" 0,  -- 7: Column
  vdbeColumn 0 2 5 "" 0,  -- 8: Column
  vdbeColumn 0 3 6 "" 0,  -- 9: Column
  vdbeColumn 0 4 7 "" 0,  -- 10: Column
  vdbeResultRow 3 5 0 "" 0,  -- 11: ResultRow
  vdbeNext 0 4 0 "" 0,  -- 12: Next
  vdbeHalt 0 0 0 "" 0,  -- 13: Halt
  vdbeTransaction 0 0 18 "0" 1,  -- 14: Transaction
  vdbeGoto 0 1 0 "" 0  -- 15: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000137
