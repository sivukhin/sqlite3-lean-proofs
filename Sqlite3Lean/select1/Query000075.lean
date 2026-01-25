import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000075

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=
    cursor=1 rootpage=8 db=0 mode=read name=

  Query: SELECT test1.f1+F2, t1 FROM test1, test2 
           ORDER BY f2

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     23    0                    0   
  1     SorterOpen     2     4     0     k(1,B)         0   
  2     OpenRead       0     2     0     2              0   
  3     OpenRead       1     8     0     1              0   
  4     Rewind         0     15    0                    0   
  5     Rewind         1     15    0                    0   
  6     Column         0     0     4                    0   
  7     Column         0     1     5                    0   
  8     Add            5     4     2                    0   
  9     Column         1     0     3                    0   
  10    Column         0     1     1                    0   
  11    MakeRecord     1     3     6                    0   
  12    SorterInsert   2     6     1     3              0   
  13    Next           1     6     0                    1   
  14    Next           0     5     0                    1   
  15    OpenPseudo     3     7     4                    0   
  16    SorterSort     2     22    0                    0   
  17    SorterData     2     7     3                    0   
  18    Column         3     2     3                    0   
  19    Column         3     1     2                    0   
  20    ResultRow      2     2     0                    0   
  21    SorterNext     2     17    0                    0   
  22    Halt           0     0     0                    0   
  23    Transaction    0     0     8     0              1   
  24    Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 23 0 0 0,  -- 0: Init
  .sorterOpen 2 4 0 "k(1,B)" 0,  -- 1: SorterOpen
  .openRead 0 2 0 2 0,  -- 2: OpenRead
  .openRead 1 8 0 1 0,  -- 3: OpenRead
  .rewind 0 15 0 0 0,  -- 4: Rewind
  .rewind 1 15 0 0 0,  -- 5: Rewind
  .column 0 0 4 0 0,  -- 6: Column
  .column 0 1 5 0 0,  -- 7: Column
  .add 5 4 2 0 0,  -- 8: Add
  .column 1 0 3 0 0,  -- 9: Column
  .column 0 1 1 0 0,  -- 10: Column
  .makeRecord 1 3 6 0 0,  -- 11: MakeRecord
  .sorterInsert 2 6 1 3 0,  -- 12: SorterInsert
  .next 1 6 0 0 1,  -- 13: Next
  .next 0 5 0 0 1,  -- 14: Next
  .openPseudo 3 7 4 0 0,  -- 15: OpenPseudo
  .sorterSort 2 22 0 0 0,  -- 16: SorterSort
  .sorterData 2 7 3 0 0,  -- 17: SorterData
  .column 3 2 3 0 0,  -- 18: Column
  .column 3 1 2 0 0,  -- 19: Column
  .resultRow 2 2 0 0 0,  -- 20: ResultRow
  .sorterNext 2 17 0 0 0,  -- 21: SorterNext
  .halt 0 0 0 0 0,  -- 22: Halt
  .transaction 0 0 8 0 1,  -- 23: Transaction
  .goto 0 1 0 0 0  -- 24: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000075
