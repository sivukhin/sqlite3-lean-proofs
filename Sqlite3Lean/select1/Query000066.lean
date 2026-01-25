import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000066

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=

  Query: SELECT * FROM test1 WHERE f1==11

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     10    0                    0   
  1     OpenRead       0     2     0     2              0   
  2     Rewind         0     9     0                    0   
  3     Column         0     0     1                    0   
  4     Ne             2     8     1     BINARY-8       84  
  5     Column         0     0     3                    0   
  6     Column         0     1     4                    0   
  7     ResultRow      3     2     0                    0   
  8     Next           0     3     0                    1   
  9     Halt           0     0     0                    0   
  10    Transaction    0     0     8     0              1   
  11    Integer        11    2     0                    0   
  12    Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 10 0 0 0,  -- 0: Init
  .openRead 0 2 0 2 0,  -- 1: OpenRead
  .rewind 0 9 0 0 0,  -- 2: Rewind
  .column 0 0 1 0 0,  -- 3: Column
  .ne 2 8 1 "BINARY-8" 84,  -- 4: Ne
  .column 0 0 3 0 0,  -- 5: Column
  .column 0 1 4 0 0,  -- 6: Column
  .resultRow 3 2 0 0 0,  -- 7: ResultRow
  .next 0 3 0 0 1,  -- 8: Next
  .halt 0 0 0 0 0,  -- 9: Halt
  .transaction 0 0 8 0 1,  -- 10: Transaction
  .integer 11 2 0 0 0,  -- 11: Integer
  .goto 0 1 0 0 0  -- 12: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000066
