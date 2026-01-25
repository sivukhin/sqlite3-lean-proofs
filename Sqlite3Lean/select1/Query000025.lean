import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000025

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=4 db=0 mode=read name=

  Query: SELECT count(*),count(a),count(b) FROM t4 WHERE b=5

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     18    0                    0   
  1     Null           0     1     5                    0   
  2     OpenRead       0     4     0     2              0   
  3     Rewind         0     12    0                    0   
  4     Column         0     1     6                    0   
  5     Ne             7     11    6     BINARY-8       81  
  6     AggStep        0     0     3     count(0)       0   
  7     Column         0     0     6                    0   
  8     AggStep        0     6     4     count(1)       1   
  9     Column         0     1     6                    0   
  10    AggStep        0     6     5     count(1)       1   
  11    Next           0     4     0                    1   
  12    AggFinal       3     0     0     count(0)       0   
  13    AggFinal       4     1     0     count(1)       0   
  14    AggFinal       5     1     0     count(1)       0   
  15    Copy           3     8     2                    0   
  16    ResultRow      8     3     0                    0   
  17    Halt           0     0     0                    0   
  18    Transaction    0     0     5     0              1   
  19    Integer        5     7     0                    0   
  20    Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 18 0 0 0,  -- 0: Init
  .null 0 1 5 0 0,  -- 1: Null
  .openRead 0 4 0 2 0,  -- 2: OpenRead
  .rewind 0 12 0 0 0,  -- 3: Rewind
  .column 0 1 6 0 0,  -- 4: Column
  .ne 7 11 6 "BINARY-8" 81,  -- 5: Ne
  .aggStep 0 0 3 "count(0)" 0,  -- 6: AggStep
  .column 0 0 6 0 0,  -- 7: Column
  .aggStep 0 6 4 "count(1)" 1,  -- 8: AggStep
  .column 0 1 6 0 0,  -- 9: Column
  .aggStep 0 6 5 "count(1)" 1,  -- 10: AggStep
  .next 0 4 0 0 1,  -- 11: Next
  .aggFinal 3 0 0 "count(0)" 0,  -- 12: AggFinal
  .aggFinal 4 1 0 "count(1)" 0,  -- 13: AggFinal
  .aggFinal 5 1 0 "count(1)" 0,  -- 14: AggFinal
  .copy 3 8 2 0 0,  -- 15: Copy
  .resultRow 8 3 0 0 0,  -- 16: ResultRow
  .halt 0 0 0 0 0,  -- 17: Halt
  .transaction 0 0 5 0 1,  -- 18: Transaction
  .integer 5 7 0 0 0,  -- 19: Integer
  .goto 0 1 0 0 0  -- 20: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000025
