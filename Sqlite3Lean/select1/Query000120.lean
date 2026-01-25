import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000120

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=2 rootpage=4 db=0 mode=read name=
    cursor=0 rootpage=3 db=0 mode=read name=

  Query: SELECT * FROM t3, (SELECT max(a), max(b) FROM t4) AS 'tx'
      

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     29    0                    0   
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
  19    Yield          1     28    0                    0   
  20    Rewind         0     28    0                    0   
  21    Column         0     0     9                    0   
  22    Column         0     1     10                   0   
  23    Copy           7     11    0                    2   
  24    Copy           8     12    0                    2   
  25    ResultRow      9     4     0                    0   
  26    Next           0     21    0                    1   
  27    Goto           0     19    0                    0   
  28    Halt           0     0     0                    0   
  29    Transaction    0     0     9     0              1   
  30    Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 29 0 0 0,  -- 0: Init
  .initCoroutine 1 17 2 0 0,  -- 1: InitCoroutine
  .null 0 2 5 0 0,  -- 2: Null
  .openRead 2 4 0 2 0,  -- 3: OpenRead
  .rewind 2 12 0 0 0,  -- 4: Rewind
  .column 2 0 6 0 0,  -- 5: Column
  .collSeq 0 0 0 "BINARY-8" 0,  -- 6: CollSeq
  .aggStep 0 6 4 "max(1)" 1,  -- 7: AggStep
  .column 2 1 6 0 0,  -- 8: Column
  .collSeq 0 0 0 "BINARY-8" 0,  -- 9: CollSeq
  .aggStep 0 6 5 "max(1)" 1,  -- 10: AggStep
  .next 2 5 0 0 1,  -- 11: Next
  .aggFinal 4 1 0 "max(1)" 0,  -- 12: AggFinal
  .aggFinal 5 1 0 "max(1)" 0,  -- 13: AggFinal
  .copy 4 7 1 0 0,  -- 14: Copy
  .yield 1 0 0 0 0,  -- 15: Yield
  .endCoroutine 1 0 0 0 0,  -- 16: EndCoroutine
  .openRead 0 3 0 2 0,  -- 17: OpenRead
  .initCoroutine 1 0 2 0 0,  -- 18: InitCoroutine
  .yield 1 28 0 0 0,  -- 19: Yield
  .rewind 0 28 0 0 0,  -- 20: Rewind
  .column 0 0 9 0 0,  -- 21: Column
  .column 0 1 10 0 0,  -- 22: Column
  .copy 7 11 0 0 2,  -- 23: Copy
  .copy 8 12 0 0 2,  -- 24: Copy
  .resultRow 9 4 0 0 0,  -- 25: ResultRow
  .next 0 21 0 0 1,  -- 26: Next
  .goto 0 19 0 0 0,  -- 27: Goto
  .halt 0 0 0 0 0,  -- 28: Halt
  .transaction 0 0 9 0 1,  -- 29: Transaction
  .goto 0 1 0 0 0  -- 30: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000120
