import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000099

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=

  Query: SELECT f1 FROM test1 WHERE 5-3==2
      ORDER BY f1
    

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     16    0                    0   
  1     SorterOpen     1     3     0     k(1,B)         0   
  2     Ne             2     9     1                    80  
  3     OpenRead       0     2     0     1              0   
  4     Rewind         0     9     0                    0   
  5     Column         0     0     3                    0   
  6     MakeRecord     3     1     5                    0   
  7     SorterInsert   1     5     3     1              0   
  8     Next           0     5     0                    1   
  9     OpenPseudo     2     6     3                    0   
  10    SorterSort     1     15    0                    0   
  11    SorterData     1     6     2                    0   
  12    Column         2     0     4                    0   
  13    ResultRow      4     1     0                    0   
  14    SorterNext     1     11    0                    0   
  15    Halt           0     0     0                    0   
  16    Transaction    0     0     9     0              1   
  17    Integer        5     7     0                    0   
  18    Integer        3     8     0                    0   
  19    Subtract       8     7     1                    0   
  20    Integer        2     2     0                    0   
  21    Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 16 0 0 0,  -- 0: Init
  .sorterOpen 1 3 0 "k(1,B)" 0,  -- 1: SorterOpen
  .ne 2 9 1 0 80,  -- 2: Ne
  .openRead 0 2 0 1 0,  -- 3: OpenRead
  .rewind 0 9 0 0 0,  -- 4: Rewind
  .column 0 0 3 0 0,  -- 5: Column
  .makeRecord 3 1 5 0 0,  -- 6: MakeRecord
  .sorterInsert 1 5 3 1 0,  -- 7: SorterInsert
  .next 0 5 0 0 1,  -- 8: Next
  .openPseudo 2 6 3 0 0,  -- 9: OpenPseudo
  .sorterSort 1 15 0 0 0,  -- 10: SorterSort
  .sorterData 1 6 2 0 0,  -- 11: SorterData
  .column 2 0 4 0 0,  -- 12: Column
  .resultRow 4 1 0 0 0,  -- 13: ResultRow
  .sorterNext 1 11 0 0 0,  -- 14: SorterNext
  .halt 0 0 0 0 0,  -- 15: Halt
  .transaction 0 0 9 0 1,  -- 16: Transaction
  .integer 5 7 0 0 0,  -- 17: Integer
  .integer 3 8 0 0 0,  -- 18: Integer
  .subtract 8 7 1 0 0,  -- 19: Subtract
  .integer 2 2 0 0 0,  -- 20: Integer
  .goto 0 1 0 0 0  -- 21: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000099
