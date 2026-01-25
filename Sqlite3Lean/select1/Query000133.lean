import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000133

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=1 db=0 mode=read name=

  Query: SELECT name FROM sqlite_master WHERE type = 'table'

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     9     0                    0   
  1     OpenRead       0     1     0     2              0   
  2     Rewind         0     8     0                    0   
  3     Column         0     0     1                    0   
  4     Ne             2     7     1     BINARY-8       82  
  5     Column         0     1     3                    0   
  6     ResultRow      3     1     0                    0   
  7     Next           0     3     0                    1   
  8     Halt           0     0     0                    0   
  9     Transaction    0     0     10    0              1   
  10    String8        0     2     0     table          0   
  11    Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 9 0 0 0,  -- 0: Init
  .openRead 0 1 0 2 0,  -- 1: OpenRead
  .rewind 0 8 0 0 0,  -- 2: Rewind
  .column 0 0 1 0 0,  -- 3: Column
  .ne 2 7 1 "BINARY-8" 82,  -- 4: Ne
  .column 0 1 3 0 0,  -- 5: Column
  .resultRow 3 1 0 0 0,  -- 6: ResultRow
  .next 0 3 0 0 1,  -- 7: Next
  .halt 0 0 0 0 0,  -- 8: Halt
  .transaction 0 0 10 0 1,  -- 9: Transaction
  .string8 0 2 0 "table" 0,  -- 10: String8
  .goto 0 1 0 0 0  -- 11: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000133
