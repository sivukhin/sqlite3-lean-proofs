import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000014

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=3 db=0 mode=read name=
    cursor=1 rootpage=2 db=0 mode=read name=

  Query: SELECT * FROM test2, test1

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     15    0                    0   
  1     OpenRead       0     3     0     2              0   
  2     OpenRead       1     2     0     2              0   
  3     Rewind         0     14    0                    0   
  4     Rewind         1     14    0                    0   
  5     Column         0     0     1                    0   
  6     RealAffinity   1     0     0                    0   
  7     Column         0     1     2                    0   
  8     RealAffinity   2     0     0                    0   
  9     Column         1     0     3                    0   
  10    Column         1     1     4                    0   
  11    ResultRow      1     4     0                    0   
  12    Next           1     5     0                    1   
  13    Next           0     4     0                    1   
  14    Halt           0     0     0                    0   
  15    Transaction    0     0     2     0              1   
  16    Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 15 0 0 0,  -- 0: Init
  .openRead 0 3 0 2 0,  -- 1: OpenRead
  .openRead 1 2 0 2 0,  -- 2: OpenRead
  .rewind 0 14 0 0 0,  -- 3: Rewind
  .rewind 1 14 0 0 0,  -- 4: Rewind
  .column 0 0 1 0 0,  -- 5: Column
  .realAffinity 1 0 0 0 0,  -- 6: RealAffinity
  .column 0 1 2 0 0,  -- 7: Column
  .realAffinity 2 0 0 0 0,  -- 8: RealAffinity
  .column 1 0 3 0 0,  -- 9: Column
  .column 1 1 4 0 0,  -- 10: Column
  .resultRow 1 4 0 0 0,  -- 11: ResultRow
  .next 1 5 0 0 1,  -- 12: Next
  .next 0 4 0 0 1,  -- 13: Next
  .halt 0 0 0 0 0,  -- 14: Halt
  .transaction 0 0 2 0 1,  -- 15: Transaction
  .goto 0 1 0 0 0  -- 16: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000014
