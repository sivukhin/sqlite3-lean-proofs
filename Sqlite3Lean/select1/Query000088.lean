import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000088

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=
    cursor=1 rootpage=2 db=0 mode=read name=

  Query: SELECT a.f1, b.f1 FROM test1 a, test1 b LIMIT 1
    

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     13    0                    0   
  1     Integer        1     1     0                    0   
  2     OpenRead       0     2     0     1              0   
  3     OpenRead       1     2     0     1              0   
  4     Rewind         0     12    0                    0   
  5     Rewind         1     12    0                    0   
  6     Column         0     0     2                    0   
  7     Column         1     0     3                    0   
  8     ResultRow      2     2     0                    0   
  9     DecrJumpZero   1     12    0                    0   
  10    Next           1     6     0                    1   
  11    Next           0     5     0                    1   
  12    Halt           0     0     0                    0   
  13    Transaction    0     0     8     0              1   
  14    Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 13 0 0 0,  -- 0: Init
  .integer 1 1 0 0 0,  -- 1: Integer
  .openRead 0 2 0 1 0,  -- 2: OpenRead
  .openRead 1 2 0 1 0,  -- 3: OpenRead
  .rewind 0 12 0 0 0,  -- 4: Rewind
  .rewind 1 12 0 0 0,  -- 5: Rewind
  .column 0 0 2 0 0,  -- 6: Column
  .column 1 0 3 0 0,  -- 7: Column
  .resultRow 2 2 0 0 0,  -- 8: ResultRow
  .decrJumpZero 1 12 0 0 0,  -- 9: DecrJumpZero
  .next 1 6 0 0 1,  -- 10: Next
  .next 0 5 0 0 1,  -- 11: Next
  .halt 0 0 0 0 0,  -- 12: Halt
  .transaction 0 0 8 0 1,  -- 13: Transaction
  .goto 0 1 0 0 0  -- 14: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000088
