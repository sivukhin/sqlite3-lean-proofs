import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000136

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=1 db=0 mode=read name=

  Query: SELECT * FROM sqlite_master WHERE rowid<10;

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     14    0                    0   
  1     OpenRead       0     1     0     5              0   
  2     Rewind         0     13    0                    0   
  3     Integer        10    1     0                    0   
  4     Rowid          0     2     0                    0   
  5     Ge             1     13    2                    83  
  6     Column         0     0     3                    0   
  7     Column         0     1     4                    0   
  8     Column         0     2     5                    0   
  9     Column         0     3     6                    0   
  10    Column         0     4     7                    0   
  11    ResultRow      3     5     0                    0   
  12    Next           0     4     0                    0   
  13    Halt           0     0     0                    0   
  14    Transaction    0     0     18    0              1   
  15    Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 14 0 0 0,  -- 0: Init
  .openRead 0 1 0 5 0,  -- 1: OpenRead
  .rewind 0 13 0 0 0,  -- 2: Rewind
  .integer 10 1 0 0 0,  -- 3: Integer
  .rowid 0 2 0 0 0,  -- 4: Rowid
  .ge 1 13 2 0 83,  -- 5: Ge
  .column 0 0 3 0 0,  -- 6: Column
  .column 0 1 4 0 0,  -- 7: Column
  .column 0 2 5 0 0,  -- 8: Column
  .column 0 3 6 0 0,  -- 9: Column
  .column 0 4 7 0 0,  -- 10: Column
  .resultRow 3 5 0 0 0,  -- 11: ResultRow
  .next 0 4 0 0 0,  -- 12: Next
  .halt 0 0 0 0 0,  -- 13: Halt
  .transaction 0 0 18 0 1,  -- 14: Transaction
  .goto 0 1 0 0 0  -- 15: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000136
