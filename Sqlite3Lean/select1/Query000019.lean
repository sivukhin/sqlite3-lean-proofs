import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000019

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=

  Query: SELECT count(f1) FROM test1

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     11    0                    0   
  1     Null           0     1     2                    0   
  2     OpenRead       0     2     0     1              0   
  3     Rewind         0     7     0                    0   
  4     Column         0     0     3                    0   
  5     AggStep        0     3     2     count(1)       1   
  6     Next           0     4     0                    1   
  7     AggFinal       2     1     0     count(1)       0   
  8     Copy           2     4     0                    0   
  9     ResultRow      4     1     0                    0   
  10    Halt           0     0     0                    0   
  11    Transaction    0     0     5     0              1   
  12    Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 11 0 0 0,  -- 0: Init
  .null 0 1 2 0 0,  -- 1: Null
  .openRead 0 2 0 1 0,  -- 2: OpenRead
  .rewind 0 7 0 0 0,  -- 3: Rewind
  .column 0 0 3 0 0,  -- 4: Column
  .aggStep 0 3 2 "count(1)" 1,  -- 5: AggStep
  .next 0 4 0 0 1,  -- 6: Next
  .aggFinal 2 1 0 "count(1)" 0,  -- 7: AggFinal
  .copy 2 4 0 0 0,  -- 8: Copy
  .resultRow 4 1 0 0 0,  -- 9: ResultRow
  .halt 0 0 0 0 0,  -- 10: Halt
  .transaction 0 0 5 0 1,  -- 11: Transaction
  .goto 0 1 0 0 0  -- 12: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000019
