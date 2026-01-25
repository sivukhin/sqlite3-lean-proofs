import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000005

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=

  Query: SELECT * FROM test1

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     8     0                    0   
  1     OpenRead       0     2     0     2              0   
  2     Rewind         0     7     0                    0   
  3     Column         0     0     1                    0   
  4     Column         0     1     2                    0   
  5     ResultRow      1     2     0                    0   
  6     Next           0     3     0                    1   
  7     Halt           0     0     0                    0   
  8     Transaction    0     0     1     0              1   
  9     Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 8 0 0 0,  -- 0: Init
  .openRead 0 2 0 2 0,  -- 1: OpenRead
  .rewind 0 7 0 0 0,  -- 2: Rewind
  .column 0 0 1 0 0,  -- 3: Column
  .column 0 1 2 0 0,  -- 4: Column
  .resultRow 1 2 0 0 0,  -- 5: ResultRow
  .next 0 3 0 0 1,  -- 6: Next
  .halt 0 0 0 0 0,  -- 7: Halt
  .transaction 0 0 1 0 1,  -- 8: Transaction
  .goto 0 1 0 0 0  -- 9: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000005
