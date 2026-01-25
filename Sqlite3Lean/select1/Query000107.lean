import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000107

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=

  Query: SELECT f1-23 AS x FROM test1 ORDER BY abs(x)
    

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     19    0                    0   
  1     SorterOpen     1     3     0     k(1,B)         0   
  2     OpenRead       0     2     0     1              0   
  3     Rewind         0     12    0                    0   
  4     Column         0     0     3                    0   
  5     Subtract       4     3     2                    0   
  6     Column         0     0     5                    0   
  7     Subtract       4     5     3                    0   
  8     Function       0     3     1     abs(1)         0   
  9     MakeRecord     1     2     6                    0   
  10    SorterInsert   1     6     1     2              0   
  11    Next           0     4     0                    1   
  12    OpenPseudo     2     7     3                    0   
  13    SorterSort     1     18    0                    0   
  14    SorterData     1     7     2                    0   
  15    Column         2     1     2                    0   
  16    ResultRow      2     1     0                    0   
  17    SorterNext     1     14    0                    0   
  18    Halt           0     0     0                    0   
  19    Transaction    0     0     9     0              1   
  20    Integer        23    4     0                    0   
  21    Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 19 0 0 0,  -- 0: Init
  .sorterOpen 1 3 0 "k(1,B)" 0,  -- 1: SorterOpen
  .openRead 0 2 0 1 0,  -- 2: OpenRead
  .rewind 0 12 0 0 0,  -- 3: Rewind
  .column 0 0 3 0 0,  -- 4: Column
  .subtract 4 3 2 0 0,  -- 5: Subtract
  .column 0 0 5 0 0,  -- 6: Column
  .subtract 4 5 3 0 0,  -- 7: Subtract
  .function 0 3 1 "abs(1)" 0,  -- 8: Function
  .makeRecord 1 2 6 0 0,  -- 9: MakeRecord
  .sorterInsert 1 6 1 2 0,  -- 10: SorterInsert
  .next 0 4 0 0 1,  -- 11: Next
  .openPseudo 2 7 3 0 0,  -- 12: OpenPseudo
  .sorterSort 1 18 0 0 0,  -- 13: SorterSort
  .sorterData 1 7 2 0 0,  -- 14: SorterData
  .column 2 1 2 0 0,  -- 15: Column
  .resultRow 2 1 0 0 0,  -- 16: ResultRow
  .sorterNext 1 14 0 0 0,  -- 17: SorterNext
  .halt 0 0 0 0 0,  -- 18: Halt
  .transaction 0 0 9 0 1,  -- 19: Transaction
  .integer 23 4 0 0 0,  -- 20: Integer
  .goto 0 1 0 0 0  -- 21: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000107
