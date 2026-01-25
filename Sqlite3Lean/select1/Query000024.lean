import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000024

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=4 db=0 mode=read name=

  Query: SELECT count(*),count(a),count(b) FROM t4

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     16    0                    0   
  1     Null           0     1     5                    0   
  2     OpenRead       0     4     0     2              0   
  3     Rewind         0     10    0                    0   
  4     AggStep        0     0     3     count(0)       0   
  5     Column         0     0     6                    0   
  6     AggStep        0     6     4     count(1)       1   
  7     Column         0     1     6                    0   
  8     AggStep        0     6     5     count(1)       1   
  9     Next           0     4     0                    1   
  10    AggFinal       3     0     0     count(0)       0   
  11    AggFinal       4     1     0     count(1)       0   
  12    AggFinal       5     1     0     count(1)       0   
  13    Copy           3     7     2                    0   
  14    ResultRow      7     3     0                    0   
  15    Halt           0     0     0                    0   
  16    Transaction    0     0     5     0              1   
  17    Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 16 0 0 0,  -- 0: Init
  .null 0 1 5 0 0,  -- 1: Null
  .openRead 0 4 0 2 0,  -- 2: OpenRead
  .rewind 0 10 0 0 0,  -- 3: Rewind
  .aggStep 0 0 3 "count(0)" 0,  -- 4: AggStep
  .column 0 0 6 0 0,  -- 5: Column
  .aggStep 0 6 4 "count(1)" 1,  -- 6: AggStep
  .column 0 1 6 0 0,  -- 7: Column
  .aggStep 0 6 5 "count(1)" 1,  -- 8: AggStep
  .next 0 4 0 0 1,  -- 9: Next
  .aggFinal 3 0 0 "count(0)" 0,  -- 10: AggFinal
  .aggFinal 4 1 0 "count(1)" 0,  -- 11: AggFinal
  .aggFinal 5 1 0 "count(1)" 0,  -- 12: AggFinal
  .copy 3 7 2 0 0,  -- 13: Copy
  .resultRow 7 3 0 0 0,  -- 14: ResultRow
  .halt 0 0 0 0 0,  -- 15: Halt
  .transaction 0 0 5 0 1,  -- 16: Transaction
  .goto 0 1 0 0 0  -- 17: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000024
