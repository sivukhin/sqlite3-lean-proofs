import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000079

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=

  Query: SELECT test1 . f1, test1 . f2 FROM test1 LIMIT 1
    

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     10    0                    0   
  1     Integer        1     1     0                    0   
  2     OpenRead       0     2     0     2              0   
  3     Rewind         0     9     0                    0   
  4     Column         0     0     2                    0   
  5     Column         0     1     3                    0   
  6     ResultRow      2     2     0                    0   
  7     DecrJumpZero   1     9     0                    0   
  8     Next           0     4     0                    1   
  9     Halt           0     0     0                    0   
  10    Transaction    0     0     8     0              1   
  11    Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 10 0 0 0,  -- 0: Init
  .integer 1 1 0 0 0,  -- 1: Integer
  .openRead 0 2 0 2 0,  -- 2: OpenRead
  .rewind 0 9 0 0 0,  -- 3: Rewind
  .column 0 0 2 0 0,  -- 4: Column
  .column 0 1 3 0 0,  -- 5: Column
  .resultRow 2 2 0 0 0,  -- 6: ResultRow
  .decrJumpZero 1 9 0 0 0,  -- 7: DecrJumpZero
  .next 0 4 0 0 1,  -- 8: Next
  .halt 0 0 0 0 0,  -- 9: Halt
  .transaction 0 0 8 0 1,  -- 10: Transaction
  .goto 0 1 0 0 0  -- 11: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000079
