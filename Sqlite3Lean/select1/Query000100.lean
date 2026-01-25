import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000100

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=

  Query: SELECT min(1,2,3), -max(1,2,3)
      FROM test1 ORDER BY f1
    

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     30    0                    0   
  1     SorterOpen     1     4     0     k(1,B)         0   
  2     OpenRead       0     2     0     1              0   
  3     Rewind         0     22    0                    0   
  4     Once           0     10    0                    0   
  5     Integer        1     5     0                    0   
  6     Integer        2     6     0                    0   
  7     Integer        3     7     0                    0   
  8     CollSeq        0     0     0     BINARY-8       0   
  9     Function       7     5     4     min(-3)        0   
  10    Copy           4     2     0                    0   
  11    Once           0     17    0                    0   
  12    Integer        1     10    0                    0   
  13    Integer        2     11    0                    0   
  14    Integer        3     12    0                    0   
  15    CollSeq        0     0     0     BINARY-8       0   
  16    Function       7     10    9     max(-3)        0   
  17    Subtract       9     8     3                    0   
  18    Column         0     0     1                    0   
  19    MakeRecord     1     3     13                   0   
  20    SorterInsert   1     13    1     3              0   
  21    Next           0     4     0                    1   
  22    OpenPseudo     2     14    4                    0   
  23    SorterSort     1     29    0                    0   
  24    SorterData     1     14    2                    0   
  25    Column         2     2     3                    0   
  26    Column         2     1     2                    0   
  27    ResultRow      2     2     0                    0   
  28    SorterNext     1     24    0                    0   
  29    Halt           0     0     0                    0   
  30    Transaction    0     0     9     0              1   
  31    Integer        0     8     0                    0   
  32    Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 30 0 0 0,  -- 0: Init
  .sorterOpen 1 4 0 "k(1,B)" 0,  -- 1: SorterOpen
  .openRead 0 2 0 1 0,  -- 2: OpenRead
  .rewind 0 22 0 0 0,  -- 3: Rewind
  .once 0 10 0 0 0,  -- 4: Once
  .integer 1 5 0 0 0,  -- 5: Integer
  .integer 2 6 0 0 0,  -- 6: Integer
  .integer 3 7 0 0 0,  -- 7: Integer
  .collSeq 0 0 0 "BINARY-8" 0,  -- 8: CollSeq
  .function 7 5 4 "min(-3)" 0,  -- 9: Function
  .copy 4 2 0 0 0,  -- 10: Copy
  .once 0 17 0 0 0,  -- 11: Once
  .integer 1 10 0 0 0,  -- 12: Integer
  .integer 2 11 0 0 0,  -- 13: Integer
  .integer 3 12 0 0 0,  -- 14: Integer
  .collSeq 0 0 0 "BINARY-8" 0,  -- 15: CollSeq
  .function 7 10 9 "max(-3)" 0,  -- 16: Function
  .subtract 9 8 3 0 0,  -- 17: Subtract
  .column 0 0 1 0 0,  -- 18: Column
  .makeRecord 1 3 13 0 0,  -- 19: MakeRecord
  .sorterInsert 1 13 1 3 0,  -- 20: SorterInsert
  .next 0 4 0 0 1,  -- 21: Next
  .openPseudo 2 14 4 0 0,  -- 22: OpenPseudo
  .sorterSort 1 29 0 0 0,  -- 23: SorterSort
  .sorterData 1 14 2 0 0,  -- 24: SorterData
  .column 2 2 3 0 0,  -- 25: Column
  .column 2 1 2 0 0,  -- 26: Column
  .resultRow 2 2 0 0 0,  -- 27: ResultRow
  .sorterNext 1 24 0 0 0,  -- 28: SorterNext
  .halt 0 0 0 0 0,  -- 29: Halt
  .transaction 0 0 9 0 1,  -- 30: Transaction
  .integer 0 8 0 0 0,  -- 31: Integer
  .goto 0 1 0 0 0  -- 32: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000100
