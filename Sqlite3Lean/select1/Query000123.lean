import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000123

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):

  Query: SELECT 1+2+3
    

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     4     0                    0   
  1     Add            3     2     1                    0   
  2     ResultRow      1     1     0                    0   
  3     Halt           0     0     0                    0   
  4     Integer        1     4     0                    0   
  5     Integer        2     5     0                    0   
  6     Add            5     4     2                    0   
  7     Integer        3     3     0                    0   
  8     Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 4 0 0 0,  -- 0: Init
  .add 3 2 1 0 0,  -- 1: Add
  .resultRow 1 1 0 0 0,  -- 2: ResultRow
  .halt 0 0 0 0 0,  -- 3: Halt
  .integer 1 4 0 0 0,  -- 4: Integer
  .integer 2 5 0 0 0,  -- 5: Integer
  .add 5 4 2 0 0,  -- 6: Add
  .integer 3 3 0 0 0,  -- 7: Integer
  .goto 0 1 0 0 0  -- 8: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000123
