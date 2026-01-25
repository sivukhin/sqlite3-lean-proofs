import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000022

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=

  Query: SELECT COUNT(*)+1 FROM test1

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     10    0                    0   
  1     Null           0     1     1                    0   
  2     OpenRead       0     2     0     0              0   
  3     Rewind         0     6     0                    0   
  4     AggStep        0     0     1     count(0)       0   
  5     Next           0     4     0                    1   
  6     AggFinal       1     0     0     count(0)       0   
  7     Add            4     1     2                    0   
  8     ResultRow      2     1     0                    0   
  9     Halt           0     0     0                    0   
  10    Transaction    0     0     5     0              1   
  11    Integer        1     4     0                    0   
  12    Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 10 0 0 0,  -- 0: Init
  .null 0 1 1 0 0,  -- 1: Null
  .openRead 0 2 0 0 0,  -- 2: OpenRead
  .rewind 0 6 0 0 0,  -- 3: Rewind
  .aggStep 0 0 1 "count(0)" 0,  -- 4: AggStep
  .next 0 4 0 0 1,  -- 5: Next
  .aggFinal 1 0 0 "count(0)" 0,  -- 6: AggFinal
  .add 4 1 2 0 0,  -- 7: Add
  .resultRow 2 1 0 0 0,  -- 8: ResultRow
  .halt 0 0 0 0 0,  -- 9: Halt
  .transaction 0 0 5 0 1,  -- 10: Transaction
  .integer 1 4 0 0 0,  -- 11: Integer
  .goto 0 1 0 0 0  -- 12: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000022
