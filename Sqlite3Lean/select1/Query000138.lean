import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000138

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=1 db=0 mode=read name=

  Query: SELECT * FROM sqlite_master WHERE rowid>=10;

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     11    0                    0   
  1     OpenRead       0     1     0     5              0   
  2     SeekGE         0     10    1                    0   
  3     Column         0     0     2                    0   
  4     Column         0     1     3                    0   
  5     Column         0     2     4                    0   
  6     Column         0     3     5                    0   
  7     Column         0     4     6                    0   
  8     ResultRow      2     5     0                    0   
  9     Next           0     3     0                    0   
  10    Halt           0     0     0                    0   
  11    Transaction    0     0     18    0              1   
  12    Integer        10    1     0                    0   
  13    Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 11 0 0 0,  -- 0: Init
  .openRead 0 1 0 5 0,  -- 1: OpenRead
  .seekGE 0 10 1 0 0,  -- 2: SeekGE
  .column 0 0 2 0 0,  -- 3: Column
  .column 0 1 3 0 0,  -- 4: Column
  .column 0 2 4 0 0,  -- 5: Column
  .column 0 3 5 0 0,  -- 6: Column
  .column 0 4 6 0 0,  -- 7: Column
  .resultRow 2 5 0 0 0,  -- 8: ResultRow
  .next 0 3 0 0 0,  -- 9: Next
  .halt 0 0 0 0 0,  -- 10: Halt
  .transaction 0 0 18 0 1,  -- 11: Transaction
  .integer 10 1 0 0 0,  -- 12: Integer
  .goto 0 1 0 0 0  -- 13: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000138
