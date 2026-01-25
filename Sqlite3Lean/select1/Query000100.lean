import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000100

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
  vdbeInit 0 30 0 "" 0,  -- 0: Init
  vdbeSorterOpen 1 4 0 "k(1,B)" 0,  -- 1: SorterOpen
  vdbeOpenRead 0 2 0 "1" 0,  -- 2: OpenRead
  vdbeRewind 0 22 0 "" 0,  -- 3: Rewind
  vdbeOnce 0 10 0 "" 0,  -- 4: Once
  vdbeInteger 1 5 0 "" 0,  -- 5: Integer
  vdbeInteger 2 6 0 "" 0,  -- 6: Integer
  vdbeInteger 3 7 0 "" 0,  -- 7: Integer
  vdbeCollSeq 0 0 0 "BINARY-8" 0,  -- 8: CollSeq
  vdbeFunction 7 5 4 "min(-3)" 0,  -- 9: Function
  vdbeCopy 4 2 0 "" 0,  -- 10: Copy
  vdbeOnce 0 17 0 "" 0,  -- 11: Once
  vdbeInteger 1 10 0 "" 0,  -- 12: Integer
  vdbeInteger 2 11 0 "" 0,  -- 13: Integer
  vdbeInteger 3 12 0 "" 0,  -- 14: Integer
  vdbeCollSeq 0 0 0 "BINARY-8" 0,  -- 15: CollSeq
  vdbeFunction 7 10 9 "max(-3)" 0,  -- 16: Function
  vdbeSubtract 9 8 3 "" 0,  -- 17: Subtract
  vdbeColumn 0 0 1 "" 0,  -- 18: Column
  vdbeMakeRecord 1 3 13 "" 0,  -- 19: MakeRecord
  vdbeSorterInsert 1 13 1 "3" 0,  -- 20: SorterInsert
  vdbeNext 0 4 0 "" 1,  -- 21: Next
  vdbeOpenPseudo 2 14 4 "" 0,  -- 22: OpenPseudo
  vdbeSorterSort 1 29 0 "" 0,  -- 23: SorterSort
  vdbeSorterData 1 14 2 "" 0,  -- 24: SorterData
  vdbeColumn 2 2 3 "" 0,  -- 25: Column
  vdbeColumn 2 1 2 "" 0,  -- 26: Column
  vdbeResultRow 2 2 0 "" 0,  -- 27: ResultRow
  vdbeSorterNext 1 24 0 "" 0,  -- 28: SorterNext
  vdbeHalt 0 0 0 "" 0,  -- 29: Halt
  vdbeTransaction 0 0 9 "0" 1,  -- 30: Transaction
  vdbeInteger 0 8 0 "" 0,  -- 31: Integer
  vdbeGoto 0 1 0 "" 0  -- 32: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000100
