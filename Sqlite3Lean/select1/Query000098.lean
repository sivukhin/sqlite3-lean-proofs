import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000098

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=

  Query: SELECT f1 FROM test1 WHERE ('x' || f1) BETWEEN 'x10' AND 'x20'
      ORDER BY f1
    

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     19    0                    0   
  1     SorterOpen     1     3     0     k(1,B)         0   
  2     OpenRead       0     2     0     1              0   
  3     Rewind         0     12    0                    0   
  4     Column         0     0     3                    0   
  5     Concat         3     2     1                    0   
  6     Lt             4     11    1                    80  
  7     Gt             5     11    1                    80  
  8     Column         0     0     6                    0   
  9     MakeRecord     6     1     8                    0   
  10    SorterInsert   1     8     6     1              0   
  11    Next           0     4     0                    1   
  12    OpenPseudo     2     9     3                    0   
  13    SorterSort     1     18    0                    0   
  14    SorterData     1     9     2                    0   
  15    Column         2     0     7                    0   
  16    ResultRow      7     1     0                    0   
  17    SorterNext     1     14    0                    0   
  18    Halt           0     0     0                    0   
  19    Transaction    0     0     9     0              1   
  20    String8        0     2     0     x              0   
  21    String8        0     4     0     x10            0   
  22    String8        0     5     0     x20            0   
  23    Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 19 0 0 0,  -- 0: Init
  .sorterOpen 1 3 0 "k(1,B)" 0,  -- 1: SorterOpen
  .openRead 0 2 0 1 0,  -- 2: OpenRead
  .rewind 0 12 0 0 0,  -- 3: Rewind
  .column 0 0 3 0 0,  -- 4: Column
  .concat 3 2 1 0 0,  -- 5: Concat
  .lt 4 11 1 0 80,  -- 6: Lt
  .gt 5 11 1 0 80,  -- 7: Gt
  .column 0 0 6 0 0,  -- 8: Column
  .makeRecord 6 1 8 0 0,  -- 9: MakeRecord
  .sorterInsert 1 8 6 1 0,  -- 10: SorterInsert
  .next 0 4 0 0 1,  -- 11: Next
  .openPseudo 2 9 3 0 0,  -- 12: OpenPseudo
  .sorterSort 1 18 0 0 0,  -- 13: SorterSort
  .sorterData 1 9 2 0 0,  -- 14: SorterData
  .column 2 0 7 0 0,  -- 15: Column
  .resultRow 7 1 0 0 0,  -- 16: ResultRow
  .sorterNext 1 14 0 0 0,  -- 17: SorterNext
  .halt 0 0 0 0 0,  -- 18: Halt
  .transaction 0 0 9 0 1,  -- 19: Transaction
  .string8 0 2 0 "x" 0,  -- 20: String8
  .string8 0 4 0 "x10" 0,  -- 21: String8
  .string8 0 5 0 "x20" 0,  -- 22: String8
  .goto 0 1 0 0 0  -- 23: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000098
