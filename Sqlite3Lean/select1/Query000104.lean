import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000104

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=

  Query: SELECT * FROM test1 WHERE f1<0 ORDER BY f1

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     19    0                    0   
  1     SorterOpen     1     4     0     k(1,B)         0   
  2     OpenRead       0     2     0     2              0   
  3     Rewind         0     11    0                    0   
  4     Column         0     0     1                    0   
  5     Ge             2     10    1     BINARY-8       84  
  6     Column         0     1     4                    0   
  7     Column         0     0     3                    0   
  8     MakeRecord     3     2     6                    0   
  9     SorterInsert   1     6     3     2              0   
  10    Next           0     4     0                    1   
  11    OpenPseudo     2     7     4                    0   
  12    SorterSort     1     18    0                    0   
  13    SorterData     1     7     2                    0   
  14    Column         2     1     5                    0   
  15    Column         2     0     4                    0   
  16    ResultRow      4     2     0                    0   
  17    SorterNext     1     13    0                    0   
  18    Halt           0     0     0                    0   
  19    Transaction    0     0     9     0              1   
  20    Integer        0     2     0                    0   
  21    Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 19 0 0 0,  -- 0: Init
  .sorterOpen 1 4 0 "k(1,B)" 0,  -- 1: SorterOpen
  .openRead 0 2 0 2 0,  -- 2: OpenRead
  .rewind 0 11 0 0 0,  -- 3: Rewind
  .column 0 0 1 0 0,  -- 4: Column
  .ge 2 10 1 "BINARY-8" 84,  -- 5: Ge
  .column 0 1 4 0 0,  -- 6: Column
  .column 0 0 3 0 0,  -- 7: Column
  .makeRecord 3 2 6 0 0,  -- 8: MakeRecord
  .sorterInsert 1 6 3 2 0,  -- 9: SorterInsert
  .next 0 4 0 0 1,  -- 10: Next
  .openPseudo 2 7 4 0 0,  -- 11: OpenPseudo
  .sorterSort 1 18 0 0 0,  -- 12: SorterSort
  .sorterData 1 7 2 0 0,  -- 13: SorterData
  .column 2 1 5 0 0,  -- 14: Column
  .column 2 0 4 0 0,  -- 15: Column
  .resultRow 4 2 0 0 0,  -- 16: ResultRow
  .sorterNext 1 13 0 0 0,  -- 17: SorterNext
  .halt 0 0 0 0 0,  -- 18: Halt
  .transaction 0 0 9 0 1,  -- 19: Transaction
  .integer 0 2 0 0 0,  -- 20: Integer
  .goto 0 1 0 0 0  -- 21: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000104
