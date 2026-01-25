import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000108

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=

  Query: SELECT f1-23 AS x FROM test1 ORDER BY -abs(x)
    

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     20    0                    0   
  1     SorterOpen     1     3     0     k(1,B)         0   
  2     OpenRead       0     2     0     1              0   
  3     Rewind         0     13    0                    0   
  4     Column         0     0     3                    0   
  5     Subtract       4     3     2                    0   
  6     Column         0     0     7                    0   
  7     Subtract       4     7     6                    0   
  8     Function       0     6     3     abs(1)         0   
  9     Subtract       3     5     1                    0   
  10    MakeRecord     1     2     8                    0   
  11    SorterInsert   1     8     1     2              0   
  12    Next           0     4     0                    1   
  13    OpenPseudo     2     9     3                    0   
  14    SorterSort     1     19    0                    0   
  15    SorterData     1     9     2                    0   
  16    Column         2     1     2                    0   
  17    ResultRow      2     1     0                    0   
  18    SorterNext     1     15    0                    0   
  19    Halt           0     0     0                    0   
  20    Transaction    0     0     9     0              1   
  21    Integer        23    4     0                    0   
  22    Integer        0     5     0                    0   
  23    Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 20 0 0 0,  -- 0: Init
  .sorterOpen 1 3 0 "k(1,B)" 0,  -- 1: SorterOpen
  .openRead 0 2 0 1 0,  -- 2: OpenRead
  .rewind 0 13 0 0 0,  -- 3: Rewind
  .column 0 0 3 0 0,  -- 4: Column
  .subtract 4 3 2 0 0,  -- 5: Subtract
  .column 0 0 7 0 0,  -- 6: Column
  .subtract 4 7 6 0 0,  -- 7: Subtract
  .function 0 6 3 "abs(1)" 0,  -- 8: Function
  .subtract 3 5 1 0 0,  -- 9: Subtract
  .makeRecord 1 2 8 0 0,  -- 10: MakeRecord
  .sorterInsert 1 8 1 2 0,  -- 11: SorterInsert
  .next 0 4 0 0 1,  -- 12: Next
  .openPseudo 2 9 3 0 0,  -- 13: OpenPseudo
  .sorterSort 1 19 0 0 0,  -- 14: SorterSort
  .sorterData 1 9 2 0 0,  -- 15: SorterData
  .column 2 1 2 0 0,  -- 16: Column
  .resultRow 2 1 0 0 0,  -- 17: ResultRow
  .sorterNext 1 15 0 0 0,  -- 18: SorterNext
  .halt 0 0 0 0 0,  -- 19: Halt
  .transaction 0 0 9 0 1,  -- 20: Transaction
  .integer 23 4 0 0 0,  -- 21: Integer
  .integer 0 5 0 0 0,  -- 22: Integer
  .goto 0 1 0 0 0  -- 23: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000108
