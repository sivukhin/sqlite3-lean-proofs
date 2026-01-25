import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000048

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=

  Query: SELECT f1 FROM test1 WHERE max(f1,f2)!=11

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     12    0                    0   
  1     OpenRead       0     2     0     2              0   
  2     Rewind         0     11    0                    0   
  3     Column         0     0     2                    0   
  4     Column         0     1     3                    0   
  5     CollSeq        0     0     0     BINARY-8       0   
  6     Function       0     2     1     max(-3)        0   
  7     Eq             4     10    1                    80  
  8     Column         0     0     5                    0   
  9     ResultRow      5     1     0                    0   
  10    Next           0     3     0                    1   
  11    Halt           0     0     0                    0   
  12    Transaction    0     0     6     0              1   
  13    Integer        11    4     0                    0   
  14    Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 12 0 "" 0,  -- 0: Init
  vdbeOpenRead 0 2 0 "2" 0,  -- 1: OpenRead
  vdbeRewind 0 11 0 "" 0,  -- 2: Rewind
  vdbeColumn 0 0 2 "" 0,  -- 3: Column
  vdbeColumn 0 1 3 "" 0,  -- 4: Column
  vdbeCollSeq 0 0 0 "BINARY-8" 0,  -- 5: CollSeq
  vdbeFunction 0 2 1 "max(-3)" 0,  -- 6: Function
  vdbeEq 4 10 1 "" 80,  -- 7: Eq
  vdbeColumn 0 0 5 "" 0,  -- 8: Column
  vdbeResultRow 5 1 0 "" 0,  -- 9: ResultRow
  vdbeNext 0 3 0 "" 1,  -- 10: Next
  vdbeHalt 0 0 0 "" 0,  -- 11: Halt
  vdbeTransaction 0 0 6 "0" 1,  -- 12: Transaction
  vdbeInteger 11 4 0 "" 0,  -- 13: Integer
  vdbeGoto 0 1 0 "" 0  -- 14: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000048
