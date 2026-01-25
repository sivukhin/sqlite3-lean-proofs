import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000016

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=3 db=0 mode=read name=
    cursor=1 rootpage=2 db=0 mode=read name=

  Query: SELECT max(test1.f1,test2.r1), min(test1.f2,test2.r2)
             FROM test2, test1

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     19    0                    0   
  1     OpenRead       0     3     0     2              0   
  2     OpenRead       1     2     0     2              0   
  3     Rewind         0     18    0                    0   
  4     Rewind         1     18    0                    0   
  5     Column         1     0     3                    0   
  6     Column         0     0     4                    0   
  7     RealAffinity   4     0     0                    0   
  8     CollSeq        0     0     0     BINARY-8       0   
  9     Function       0     3     1     max(-3)        0   
  10    Column         1     1     3                    0   
  11    Column         0     1     4                    0   
  12    RealAffinity   4     0     0                    0   
  13    CollSeq        0     0     0     BINARY-8       0   
  14    Function       0     3     2     min(-3)        0   
  15    ResultRow      1     2     0                    0   
  16    Next           1     5     0                    1   
  17    Next           0     4     0                    1   
  18    Halt           0     0     0                    0   
  19    Transaction    0     0     2     0              1   
  20    Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 19 0 0 0,  -- 0: Init
  .openRead 0 3 0 2 0,  -- 1: OpenRead
  .openRead 1 2 0 2 0,  -- 2: OpenRead
  .rewind 0 18 0 0 0,  -- 3: Rewind
  .rewind 1 18 0 0 0,  -- 4: Rewind
  .column 1 0 3 0 0,  -- 5: Column
  .column 0 0 4 0 0,  -- 6: Column
  .realAffinity 4 0 0 0 0,  -- 7: RealAffinity
  .collSeq 0 0 0 "BINARY-8" 0,  -- 8: CollSeq
  .function 0 3 1 "max(-3)" 0,  -- 9: Function
  .column 1 1 3 0 0,  -- 10: Column
  .column 0 1 4 0 0,  -- 11: Column
  .realAffinity 4 0 0 0 0,  -- 12: RealAffinity
  .collSeq 0 0 0 "BINARY-8" 0,  -- 13: CollSeq
  .function 0 3 2 "min(-3)" 0,  -- 14: Function
  .resultRow 1 2 0 0 0,  -- 15: ResultRow
  .next 1 5 0 0 1,  -- 16: Next
  .next 0 4 0 0 1,  -- 17: Next
  .halt 0 0 0 0 0,  -- 18: Halt
  .transaction 0 0 2 0 1,  -- 19: Transaction
  .goto 0 1 0 0 0  -- 20: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000016
