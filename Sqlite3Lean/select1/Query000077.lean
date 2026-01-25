import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000077

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=
    cursor=1 rootpage=2 db=0 mode=read name=

  Query: SELECT A.f1, B.f1 FROM test1 as A, test1 as B 
           ORDER BY A.f1, B.f1

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     20    0                    0   
  1     SorterOpen     2     5     0     k(2,B,B)       0   
  2     OpenRead       0     2     0     1              0   
  3     OpenRead       1     2     0     1              0   
  4     Rewind         0     12    0                    0   
  5     Rewind         1     12    0                    0   
  6     Column         0     0     1                    0   
  7     Column         1     0     2                    0   
  8     MakeRecord     1     2     5                    0   
  9     SorterInsert   2     5     1     2              0   
  10    Next           1     6     0                    1   
  11    Next           0     5     0                    1   
  12    OpenPseudo     3     6     5                    0   
  13    SorterSort     2     19    0                    0   
  14    SorterData     2     6     3                    0   
  15    Column         3     1     4                    0   
  16    Column         3     0     3                    0   
  17    ResultRow      3     2     0                    0   
  18    SorterNext     2     14    0                    0   
  19    Halt           0     0     0                    0   
  20    Transaction    0     0     8     0              1   
  21    Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 20 0 0 0,  -- 0: Init
  .sorterOpen 2 5 0 "k(2,B,B)" 0,  -- 1: SorterOpen
  .openRead 0 2 0 1 0,  -- 2: OpenRead
  .openRead 1 2 0 1 0,  -- 3: OpenRead
  .rewind 0 12 0 0 0,  -- 4: Rewind
  .rewind 1 12 0 0 0,  -- 5: Rewind
  .column 0 0 1 0 0,  -- 6: Column
  .column 1 0 2 0 0,  -- 7: Column
  .makeRecord 1 2 5 0 0,  -- 8: MakeRecord
  .sorterInsert 2 5 1 2 0,  -- 9: SorterInsert
  .next 1 6 0 0 1,  -- 10: Next
  .next 0 5 0 0 1,  -- 11: Next
  .openPseudo 3 6 5 0 0,  -- 12: OpenPseudo
  .sorterSort 2 19 0 0 0,  -- 13: SorterSort
  .sorterData 2 6 3 0 0,  -- 14: SorterData
  .column 3 1 4 0 0,  -- 15: Column
  .column 3 0 3 0 0,  -- 16: Column
  .resultRow 3 2 0 0 0,  -- 17: ResultRow
  .sorterNext 2 14 0 0 0,  -- 18: SorterNext
  .halt 0 0 0 0 0,  -- 19: Halt
  .transaction 0 0 8 0 1,  -- 20: Transaction
  .goto 0 1 0 0 0  -- 21: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000077
