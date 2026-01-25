import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000021

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=1 rootpage=2 db=0 mode=read name=

  Query: SELECT COUNT(*) FROM test1

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     7     0                    0   
  1     OpenRead       1     2     0     1              0   
  2     Count          1     1     0                    0   
  3     Close          1     0     0                    0   
  4     Copy           1     2     0                    0   
  5     ResultRow      2     1     0                    0   
  6     Halt           0     0     0                    0   
  7     Transaction    0     0     5     0              1   
  8     Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 7 0 0 0,  -- 0: Init
  .openRead 1 2 0 1 0,  -- 1: OpenRead
  .count 1 1 0 0 0,  -- 2: Count
  .close 1 0 0 0 0,  -- 3: Close
  .copy 1 2 0 0 0,  -- 4: Copy
  .resultRow 2 1 0 0 0,  -- 5: ResultRow
  .halt 0 0 0 0 0,  -- 6: Halt
  .transaction 0 0 5 0 1,  -- 7: Transaction
  .goto 0 1 0 0 0  -- 8: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000021
