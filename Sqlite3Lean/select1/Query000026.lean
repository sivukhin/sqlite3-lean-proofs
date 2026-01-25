import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000026

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=

  Query: SELECT Min(f1) FROM test1

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     12    0                    0   
  1     Null           0     1     2                    0   
  2     OpenRead       0     2     0     1              0   
  3     Rewind         0     8     0                    0   
  4     Column         0     0     3                    0   
  5     CollSeq        0     0     0     BINARY-8       0   
  6     AggStep        0     3     2     min(1)         1   
  7     Next           0     4     0                    1   
  8     AggFinal       2     1     0     min(1)         0   
  9     Copy           2     4     0                    0   
  10    ResultRow      4     1     0                    0   
  11    Halt           0     0     0                    0   
  12    Transaction    0     0     5     0              1   
  13    Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 12 0 0 0,  -- 0: Init
  .null 0 1 2 0 0,  -- 1: Null
  .openRead 0 2 0 1 0,  -- 2: OpenRead
  .rewind 0 8 0 0 0,  -- 3: Rewind
  .column 0 0 3 0 0,  -- 4: Column
  .collSeq 0 0 0 "BINARY-8" 0,  -- 5: CollSeq
  .aggStep 0 3 2 "min(1)" 1,  -- 6: AggStep
  .next 0 4 0 0 1,  -- 7: Next
  .aggFinal 2 1 0 "min(1)" 0,  -- 8: AggFinal
  .copy 2 4 0 0 0,  -- 9: Copy
  .resultRow 4 1 0 0 0,  -- 10: ResultRow
  .halt 0 0 0 0 0,  -- 11: Halt
  .transaction 0 0 5 0 1,  -- 12: Transaction
  .goto 0 1 0 0 0  -- 13: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000026
