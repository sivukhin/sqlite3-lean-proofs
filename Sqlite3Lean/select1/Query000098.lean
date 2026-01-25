import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000098

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
  vdbeInit 0 19 0 "" 0,  -- 0: Init
  vdbeSorterOpen 1 3 0 "k(1,B)" 0,  -- 1: SorterOpen
  vdbeOpenRead 0 2 0 "1" 0,  -- 2: OpenRead
  vdbeRewind 0 12 0 "" 0,  -- 3: Rewind
  vdbeColumn 0 0 3 "" 0,  -- 4: Column
  vdbeConcat 3 2 1 "" 0,  -- 5: Concat
  vdbeLt 4 11 1 "" 80,  -- 6: Lt
  vdbeGt 5 11 1 "" 80,  -- 7: Gt
  vdbeColumn 0 0 6 "" 0,  -- 8: Column
  vdbeMakeRecord 6 1 8 "" 0,  -- 9: MakeRecord
  vdbeSorterInsert 1 8 6 "1" 0,  -- 10: SorterInsert
  vdbeNext 0 4 0 "" 1,  -- 11: Next
  vdbeOpenPseudo 2 9 3 "" 0,  -- 12: OpenPseudo
  vdbeSorterSort 1 18 0 "" 0,  -- 13: SorterSort
  vdbeSorterData 1 9 2 "" 0,  -- 14: SorterData
  vdbeColumn 2 0 7 "" 0,  -- 15: Column
  vdbeResultRow 7 1 0 "" 0,  -- 16: ResultRow
  vdbeSorterNext 1 14 0 "" 0,  -- 17: SorterNext
  vdbeHalt 0 0 0 "" 0,  -- 18: Halt
  vdbeTransaction 0 0 9 "0" 1,  -- 19: Transaction
  vdbeString8 0 2 0 "x" 0,  -- 20: String8
  vdbeString8 0 4 0 "x10" 0,  -- 21: String8
  vdbeString8 0 5 0 "x20" 0,  -- 22: String8
  vdbeGoto 0 1 0 "" 0  -- 23: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000098
