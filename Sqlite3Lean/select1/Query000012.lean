import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000012

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=
    cursor=1 rootpage=3 db=0 mode=read name=

  Query: SELECT test1.f1, test2.r1 FROM test1, test2

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     12    0                    0   
  1     OpenRead       0     2     0     1              0   
  2     OpenRead       1     3     0     1              0   
  3     Rewind         0     11    0                    0   
  4     Rewind         1     11    0                    0   
  5     Column         0     0     1                    0   
  6     Column         1     0     2                    0   
  7     RealAffinity   2     0     0                    0   
  8     ResultRow      1     2     0                    0   
  9     Next           1     5     0                    1   
  10    Next           0     4     0                    1   
  11    Halt           0     0     0                    0   
  12    Transaction    0     0     2     0              1   
  13    Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 12 0 0 0,  -- 0: Init
  .openRead 0 2 0 1 0,  -- 1: OpenRead
  .openRead 1 3 0 1 0,  -- 2: OpenRead
  .rewind 0 11 0 0 0,  -- 3: Rewind
  .rewind 1 11 0 0 0,  -- 4: Rewind
  .column 0 0 1 0 0,  -- 5: Column
  .column 1 0 2 0 0,  -- 6: Column
  .realAffinity 2 0 0 0 0,  -- 7: RealAffinity
  .resultRow 1 2 0 0 0,  -- 8: ResultRow
  .next 1 5 0 0 1,  -- 9: Next
  .next 0 4 0 0 1,  -- 10: Next
  .halt 0 0 0 0 0,  -- 11: Halt
  .transaction 0 0 2 0 1,  -- 12: Transaction
  .goto 0 1 0 0 0  -- 13: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000012
