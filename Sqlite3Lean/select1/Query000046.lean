import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000046

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=

  Query: SELECT f1 FROM test1 WHERE f1!=11

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     9     0                    0   
  1     OpenRead       0     2     0     1              0   
  2     Rewind         0     8     0                    0   
  3     Column         0     0     1                    0   
  4     Eq             2     7     1     BINARY-8       84  
  5     Column         0     0     3                    0   
  6     ResultRow      3     1     0                    0   
  7     Next           0     3     0                    1   
  8     Halt           0     0     0                    0   
  9     Transaction    0     0     6     0              1   
  10    Integer        11    2     0                    0   
  11    Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 9 0 0 0,  -- 0: Init
  .openRead 0 2 0 1 0,  -- 1: OpenRead
  .rewind 0 8 0 0 0,  -- 2: Rewind
  .column 0 0 1 0 0,  -- 3: Column
  .eq 2 7 1 "BINARY-8" 84,  -- 4: Eq
  .column 0 0 3 0 0,  -- 5: Column
  .resultRow 3 1 0 0 0,  -- 6: ResultRow
  .next 0 3 0 0 1,  -- 7: Next
  .halt 0 0 0 0 0,  -- 8: Halt
  .transaction 0 0 6 0 1,  -- 9: Transaction
  .integer 11 2 0 0 0,  -- 10: Integer
  .goto 0 1 0 0 0  -- 11: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000046
