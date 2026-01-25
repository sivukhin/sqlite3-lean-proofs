import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000051

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=

  Query: SELECT f1 FROM test1 ORDER BY min(f1,f2)

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     19    0                    0   
  1     SorterOpen     1     3     0     k(1,B)         0   
  2     OpenRead       0     2     0     2              0   
  3     Rewind         0     12    0                    0   
  4     Column         0     0     2                    0   
  5     Column         0     0     3                    0   
  6     Column         0     1     4                    0   
  7     CollSeq        0     0     0     BINARY-8       0   
  8     Function       0     3     1     min(-3)        0   
  9     MakeRecord     1     2     5                    0   
  10    SorterInsert   1     5     1     2              0   
  11    Next           0     4     0                    1   
  12    OpenPseudo     2     6     3                    0   
  13    SorterSort     1     18    0                    0   
  14    SorterData     1     6     2                    0   
  15    Column         2     1     2                    0   
  16    ResultRow      2     1     0                    0   
  17    SorterNext     1     14    0                    0   
  18    Halt           0     0     0                    0   
  19    Transaction    0     0     6     0              1   
  20    Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 19 0 0 0,  -- 0: Init
  .sorterOpen 1 3 0 "k(1,B)" 0,  -- 1: SorterOpen
  .openRead 0 2 0 2 0,  -- 2: OpenRead
  .rewind 0 12 0 0 0,  -- 3: Rewind
  .column 0 0 2 0 0,  -- 4: Column
  .column 0 0 3 0 0,  -- 5: Column
  .column 0 1 4 0 0,  -- 6: Column
  .collSeq 0 0 0 "BINARY-8" 0,  -- 7: CollSeq
  .function 0 3 1 "min(-3)" 0,  -- 8: Function
  .makeRecord 1 2 5 0 0,  -- 9: MakeRecord
  .sorterInsert 1 5 1 2 0,  -- 10: SorterInsert
  .next 0 4 0 0 1,  -- 11: Next
  .openPseudo 2 6 3 0 0,  -- 12: OpenPseudo
  .sorterSort 1 18 0 0 0,  -- 13: SorterSort
  .sorterData 1 6 2 0 0,  -- 14: SorterData
  .column 2 1 2 0 0,  -- 15: Column
  .resultRow 2 1 0 0 0,  -- 16: ResultRow
  .sorterNext 1 14 0 0 0,  -- 17: SorterNext
  .halt 0 0 0 0 0,  -- 18: Halt
  .transaction 0 0 6 0 1,  -- 19: Transaction
  .goto 0 1 0 0 0  -- 20: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000051
