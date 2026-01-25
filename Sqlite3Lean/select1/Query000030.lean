import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000030

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=4 db=0 mode=read name=

  Query: SELECT min(b), min(b) FROM t4

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     13    0                    0   
  1     Null           0     1     2                    0   
  2     OpenRead       0     4     0     2              0   
  3     Rewind         0     8     0                    0   
  4     Column         0     1     3                    0   
  5     CollSeq        0     0     0     BINARY-8       0   
  6     AggStep        0     3     2     min(1)         1   
  7     Next           0     4     0                    1   
  8     AggFinal       2     1     0     min(1)         0   
  9     Copy           2     4     0                    0   
  10    Copy           2     5     0                    0   
  11    ResultRow      4     2     0                    0   
  12    Halt           0     0     0                    0   
  13    Transaction    0     0     5     0              1   
  14    Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 13 0 "" 0,  -- 0: Init
  vdbeNull 0 1 2 "" 0,  -- 1: Null
  vdbeOpenRead 0 4 0 "2" 0,  -- 2: OpenRead
  vdbeRewind 0 8 0 "" 0,  -- 3: Rewind
  vdbeColumn 0 1 3 "" 0,  -- 4: Column
  vdbeCollSeq 0 0 0 "BINARY-8" 0,  -- 5: CollSeq
  vdbeAggStep 0 3 2 "min(1)" 1,  -- 6: AggStep
  vdbeNext 0 4 0 "" 1,  -- 7: Next
  vdbeAggFinal 2 1 0 "min(1)" 0,  -- 8: AggFinal
  vdbeCopy 2 4 0 "" 0,  -- 9: Copy
  vdbeCopy 2 5 0 "" 0,  -- 10: Copy
  vdbeResultRow 4 2 0 "" 0,  -- 11: ResultRow
  vdbeHalt 0 0 0 "" 0,  -- 12: Halt
  vdbeTransaction 0 0 5 "0" 1,  -- 13: Transaction
  vdbeGoto 0 1 0 "" 0  -- 14: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000030
