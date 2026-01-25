import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000124

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):

  Query: SELECT 1,'hello',2
    

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     6     0                    0   
  1     Integer        1     1     0                    0   
  2     String8        0     2     0     hello          0   
  3     Integer        2     3     0                    0   
  4     ResultRow      1     3     0                    0   
  5     Halt           0     0     0                    0   
  6     Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 6 0 0 0,  -- 0: Init
  .integer 1 1 0 0 0,  -- 1: Integer
  .string8 0 2 0 "hello" 0,  -- 2: String8
  .integer 2 3 0 0 0,  -- 3: Integer
  .resultRow 1 3 0 0 0,  -- 4: ResultRow
  .halt 0 0 0 0 0,  -- 5: Halt
  .goto 0 1 0 0 0  -- 6: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000124
