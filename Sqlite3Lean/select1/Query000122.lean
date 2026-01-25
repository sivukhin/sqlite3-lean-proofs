import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000122

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=3 db=0 mode=read name=
    cursor=1 rootpage=4 db=0 mode=read name=

  Query: SELECT y.* FROM t3 as y, t4 as z
    

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     11    0                    0   
  1     OpenRead       0     3     0     2              0   
  2     OpenRead       1     4     0     0              0   
  3     Rewind         0     10    0                    0   
  4     Rewind         1     10    0                    0   
  5     Column         0     0     1                    0   
  6     Column         0     1     2                    0   
  7     ResultRow      1     2     0                    0   
  8     Next           1     5     0                    1   
  9     Next           0     4     0                    1   
  10    Halt           0     0     0                    0   
  11    Transaction    0     0     9     0              1   
  12    Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 11 0 0 0,  -- 0: Init
  .openRead 0 3 0 2 0,  -- 1: OpenRead
  .openRead 1 4 0 0 0,  -- 2: OpenRead
  .rewind 0 10 0 0 0,  -- 3: Rewind
  .rewind 1 10 0 0 0,  -- 4: Rewind
  .column 0 0 1 0 0,  -- 5: Column
  .column 0 1 2 0 0,  -- 6: Column
  .resultRow 1 2 0 0 0,  -- 7: ResultRow
  .next 1 5 0 0 1,  -- 8: Next
  .next 0 4 0 0 1,  -- 9: Next
  .halt 0 0 0 0 0,  -- 10: Halt
  .transaction 0 0 9 0 1,  -- 11: Transaction
  .goto 0 1 0 0 0  -- 12: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000122
