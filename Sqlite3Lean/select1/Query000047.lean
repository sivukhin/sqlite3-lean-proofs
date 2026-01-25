import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000047

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=

  Query: SELECT f1 FROM test1 WHERE min(f1,f2)!=11

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     12    0                    0   
  1     OpenRead       0     2     0     2              0   
  2     Rewind         0     11    0                    0   
  3     Column         0     0     2                    0   
  4     Column         0     1     3                    0   
  5     CollSeq        0     0     0     BINARY-8       0   
  6     Function       0     2     1     min(-3)        0   
  7     Eq             4     10    1                    80  
  8     Column         0     0     5                    0   
  9     ResultRow      5     1     0                    0   
  10    Next           0     3     0                    1   
  11    Halt           0     0     0                    0   
  12    Transaction    0     0     6     0              1   
  13    Integer        11    4     0                    0   
  14    Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 12 0 0 0,  -- 0: Init
  .openRead 0 2 0 2 0,  -- 1: OpenRead
  .rewind 0 11 0 0 0,  -- 2: Rewind
  .column 0 0 2 0 0,  -- 3: Column
  .column 0 1 3 0 0,  -- 4: Column
  .collSeq 0 0 0 "BINARY-8" 0,  -- 5: CollSeq
  .function 0 2 1 "min(-3)" 0,  -- 6: Function
  .eq 4 10 1 0 80,  -- 7: Eq
  .column 0 0 5 0 0,  -- 8: Column
  .resultRow 5 1 0 0 0,  -- 9: ResultRow
  .next 0 3 0 0 1,  -- 10: Next
  .halt 0 0 0 0 0,  -- 11: Halt
  .transaction 0 0 6 0 1,  -- 12: Transaction
  .integer 11 4 0 0 0,  -- 13: Integer
  .goto 0 1 0 0 0  -- 14: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000047
