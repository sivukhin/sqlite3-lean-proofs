import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000076

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=
    cursor=1 rootpage=8 db=0 mode=read name=

  Query: SELECT A.f1, t1 FROM test1 as A, test2 
           ORDER BY f2

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     21    0                    0   
  1     SorterOpen     2     4     0     k(1,B)         0   
  2     OpenRead       0     2     0     2              0   
  3     OpenRead       1     8     0     1              0   
  4     Rewind         0     13    0                    0   
  5     Rewind         1     13    0                    0   
  6     Column         0     0     2                    0   
  7     Column         1     0     3                    0   
  8     Column         0     1     1                    0   
  9     MakeRecord     1     3     4                    0   
  10    SorterInsert   2     4     1     3              0   
  11    Next           1     6     0                    1   
  12    Next           0     5     0                    1   
  13    OpenPseudo     3     5     4                    0   
  14    SorterSort     2     20    0                    0   
  15    SorterData     2     5     3                    0   
  16    Column         3     2     3                    0   
  17    Column         3     1     2                    0   
  18    ResultRow      2     2     0                    0   
  19    SorterNext     2     15    0                    0   
  20    Halt           0     0     0                    0   
  21    Transaction    0     0     8     0              1   
  22    Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 21 0 0 0,  -- 0: Init
  .sorterOpen 2 4 0 "k(1,B)" 0,  -- 1: SorterOpen
  .openRead 0 2 0 2 0,  -- 2: OpenRead
  .openRead 1 8 0 1 0,  -- 3: OpenRead
  .rewind 0 13 0 0 0,  -- 4: Rewind
  .rewind 1 13 0 0 0,  -- 5: Rewind
  .column 0 0 2 0 0,  -- 6: Column
  .column 1 0 3 0 0,  -- 7: Column
  .column 0 1 1 0 0,  -- 8: Column
  .makeRecord 1 3 4 0 0,  -- 9: MakeRecord
  .sorterInsert 2 4 1 3 0,  -- 10: SorterInsert
  .next 1 6 0 0 1,  -- 11: Next
  .next 0 5 0 0 1,  -- 12: Next
  .openPseudo 3 5 4 0 0,  -- 13: OpenPseudo
  .sorterSort 2 20 0 0 0,  -- 14: SorterSort
  .sorterData 2 5 3 0 0,  -- 15: SorterData
  .column 3 2 3 0 0,  -- 16: Column
  .column 3 1 2 0 0,  -- 17: Column
  .resultRow 2 2 0 0 0,  -- 18: ResultRow
  .sorterNext 2 15 0 0 0,  -- 19: SorterNext
  .halt 0 0 0 0 0,  -- 20: Halt
  .transaction 0 0 8 0 1,  -- 21: Transaction
  .goto 0 1 0 0 0  -- 22: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000076
