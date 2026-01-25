import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000150

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=

  Query: SELECT*FROM"main"."t1"

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     9     0                    0   
  1     OpenRead       0     2     0     1              0   
  2     Rewind         0     8     0                    0   
  3     Rowid          0     1     0                    0   
  4     IfNullRow      0     6     2                    0   
  5     String8        0     2     0     Y              0   
  6     ResultRow      1     2     0                    0   
  7     Next           0     3     0                    1   
  8     Halt           0     0     0                    0   
  9     Transaction    0     0     1     0              1   
  10    Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 9 0 0 0,  -- 0: Init
  .openRead 0 2 0 1 0,  -- 1: OpenRead
  .rewind 0 8 0 0 0,  -- 2: Rewind
  .rowid 0 1 0 0 0,  -- 3: Rowid
  .ifNullRow 0 6 2 0 0,  -- 4: IfNullRow
  .string8 0 2 0 "Y" 0,  -- 5: String8
  .resultRow 1 2 0 0 0,  -- 6: ResultRow
  .next 0 3 0 0 1,  -- 7: Next
  .halt 0 0 0 0 0,  -- 8: Halt
  .transaction 0 0 1 0 1,  -- 9: Transaction
  .goto 0 1 0 0 0  -- 10: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000150
