import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000007

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=

  Query: SELECT *, min(f1,f2), max(f1,f2) FROM test1

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     16    0                    0   
  1     OpenRead       0     2     0     2              0   
  2     Rewind         0     15    0                    0   
  3     Column         0     0     1                    0   
  4     Column         0     1     2                    0   
  5     Column         0     0     5                    0   
  6     Column         0     1     6                    0   
  7     CollSeq        0     0     0     BINARY-8       0   
  8     Function       0     5     3     min(-3)        0   
  9     Column         0     0     5                    0   
  10    Column         0     1     6                    0   
  11    CollSeq        0     0     0     BINARY-8       0   
  12    Function       0     5     4     max(-3)        0   
  13    ResultRow      1     4     0                    0   
  14    Next           0     3     0                    1   
  15    Halt           0     0     0                    0   
  16    Transaction    0     0     1     0              1   
  17    Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 16 0 "" 0,  -- 0: Init
  vdbeOpenRead 0 2 0 "2" 0,  -- 1: OpenRead
  vdbeRewind 0 15 0 "" 0,  -- 2: Rewind
  vdbeColumn 0 0 1 "" 0,  -- 3: Column
  vdbeColumn 0 1 2 "" 0,  -- 4: Column
  vdbeColumn 0 0 5 "" 0,  -- 5: Column
  vdbeColumn 0 1 6 "" 0,  -- 6: Column
  vdbeCollSeq 0 0 0 "BINARY-8" 0,  -- 7: CollSeq
  vdbeFunction 0 5 3 "min(-3)" 0,  -- 8: Function
  vdbeColumn 0 0 5 "" 0,  -- 9: Column
  vdbeColumn 0 1 6 "" 0,  -- 10: Column
  vdbeCollSeq 0 0 0 "BINARY-8" 0,  -- 11: CollSeq
  vdbeFunction 0 5 4 "max(-3)" 0,  -- 12: Function
  vdbeResultRow 1 4 0 "" 0,  -- 13: ResultRow
  vdbeNext 0 3 0 "" 1,  -- 14: Next
  vdbeHalt 0 0 0 "" 0,  -- 15: Halt
  vdbeTransaction 0 0 1 "0" 1,  -- 16: Transaction
  vdbeGoto 0 1 0 "" 0  -- 17: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000007
