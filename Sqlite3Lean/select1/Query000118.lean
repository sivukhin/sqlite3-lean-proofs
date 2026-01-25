import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000118

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=2 rootpage=4 db=0 mode=read name=
    cursor=0 rootpage=3 db=0 mode=read name=

  Query: SELECT t3.* FROM t3, (SELECT max(a), max(b) FROM t4)
      

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     27    0                    0   
  1     InitCoroutine  1     17    2                    0   
  2     Null           0     2     5                    0   
  3     OpenRead       2     4     0     2              0   
  4     Rewind         2     12    0                    0   
  5     Column         2     0     6                    0   
  6     CollSeq        0     0     0     BINARY-8       0   
  7     AggStep        0     6     4     max(1)         1   
  8     Column         2     1     6                    0   
  9     CollSeq        0     0     0     BINARY-8       0   
  10    AggStep        0     6     5     max(1)         1   
  11    Next           2     5     0                    1   
  12    AggFinal       4     1     0     max(1)         0   
  13    AggFinal       5     1     0     max(1)         0   
  14    Copy           4     7     1                    0   
  15    Yield          1     0     0                    0   
  16    EndCoroutine   1     0     0                    0   
  17    OpenRead       0     3     0     2              0   
  18    InitCoroutine  1     0     2                    0   
  19    Yield          1     26    0                    0   
  20    Rewind         0     26    0                    0   
  21    Column         0     0     9                    0   
  22    Column         0     1     10                   0   
  23    ResultRow      9     2     0                    0   
  24    Next           0     21    0                    1   
  25    Goto           0     19    0                    0   
  26    Halt           0     0     0                    0   
  27    Transaction    0     0     9     0              1   
  28    Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 27 0 "" 0,  -- 0: Init
  vdbeInitCoroutine 1 17 2 "" 0,  -- 1: InitCoroutine
  vdbeNull 0 2 5 "" 0,  -- 2: Null
  vdbeOpenRead 2 4 0 "2" 0,  -- 3: OpenRead
  vdbeRewind 2 12 0 "" 0,  -- 4: Rewind
  vdbeColumn 2 0 6 "" 0,  -- 5: Column
  vdbeCollSeq 0 0 0 "BINARY-8" 0,  -- 6: CollSeq
  vdbeAggStep 0 6 4 "max(1)" 1,  -- 7: AggStep
  vdbeColumn 2 1 6 "" 0,  -- 8: Column
  vdbeCollSeq 0 0 0 "BINARY-8" 0,  -- 9: CollSeq
  vdbeAggStep 0 6 5 "max(1)" 1,  -- 10: AggStep
  vdbeNext 2 5 0 "" 1,  -- 11: Next
  vdbeAggFinal 4 1 0 "max(1)" 0,  -- 12: AggFinal
  vdbeAggFinal 5 1 0 "max(1)" 0,  -- 13: AggFinal
  vdbeCopy 4 7 1 "" 0,  -- 14: Copy
  vdbeYield 1 0 0 "" 0,  -- 15: Yield
  vdbeEndCoroutine 1 0 0 "" 0,  -- 16: EndCoroutine
  vdbeOpenRead 0 3 0 "2" 0,  -- 17: OpenRead
  vdbeInitCoroutine 1 0 2 "" 0,  -- 18: InitCoroutine
  vdbeYield 1 26 0 "" 0,  -- 19: Yield
  vdbeRewind 0 26 0 "" 0,  -- 20: Rewind
  vdbeColumn 0 0 9 "" 0,  -- 21: Column
  vdbeColumn 0 1 10 "" 0,  -- 22: Column
  vdbeResultRow 9 2 0 "" 0,  -- 23: ResultRow
  vdbeNext 0 21 0 "" 1,  -- 24: Next
  vdbeGoto 0 19 0 "" 0,  -- 25: Goto
  vdbeHalt 0 0 0 "" 0,  -- 26: Halt
  vdbeTransaction 0 0 9 "0" 1,  -- 27: Transaction
  vdbeGoto 0 1 0 "" 0  -- 28: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000118
