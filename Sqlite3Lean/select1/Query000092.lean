import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000092

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=1 rootpage=2 db=0 mode=read name=
    cursor=0 rootpage=2 db=0 mode=read name=

  Query: SELECT f1 FROM test1 UNION SELECT f2 FROM test1
      ORDER BY f2;

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     66    0                    0   
  1     Integer        0     1     0                    0   
  2     InitCoroutine  3     17    3                    0   
  3     SorterOpen     2     3     0     k(1,B)         0   
  4     OpenRead       1     2     0     2              0   
  5     Rewind         1     10    0                    0   
  6     Column         1     0     7                    0   
  7     MakeRecord     7     1     9                    0   
  8     SorterInsert   2     9     7     1              0   
  9     Next           1     6     0                    1   
  10    OpenPseudo     3     10    3                    0   
  11    SorterSort     2     16    0                    0   
  12    SorterData     2     10    3                    0   
  13    Column         3     0     8                    0   
  14    Yield          3     0     0                    0   
  15    SorterNext     2     12    0                    0   
  16    EndCoroutine   3     0     0                    0   
  17    InitCoroutine  4     60    18                   0   
  18    SorterOpen     4     3     0     k(1,B)         0   
  19    OpenRead       0     2     0     2              0   
  20    Rewind         0     25    0                    0   
  21    Column         0     1     11                   0   
  22    MakeRecord     11    1     13                   0   
  23    SorterInsert   4     13    11    1              0   
  24    Next           0     21    0                    1   
  25    OpenPseudo     5     14    3                    0   
  26    SorterSort     4     31    0                    0   
  27    SorterData     4     14    5                    0   
  28    Column         5     0     12                   0   
  29    Yield          4     0     0                    0   
  30    SorterNext     4     27    0                    0   
  31    EndCoroutine   4     0     0                    0   
  32    IfNot          1     35    0                    0   
  33    Compare        8     2     1     k(1,B)         0   
  34    Jump           35    38    35                   0   
  35    Copy           8     2     0                    0   
  36    Integer        1     1     0                    0   
  37    ResultRow      8     1     0                    0   
  38    Return         5     0     0                    0   
  39    IfNot          1     42    0                    0   
  40    Compare        12    2     1     k(1,B)         0   
  41    Jump           42    45    42                   0   
  42    Copy           12    2     0                    0   
  43    Integer        1     1     0                    0   
  44    ResultRow      12    1     0                    0   
  45    Return         6     0     0                    0   
  46    Gosub          6     39    0                    0   
  47    Yield          4     65    0                    0   
  48    Goto           0     46    0                    0   
  49    Gosub          5     32    0                    0   
  50    Yield          3     65    0                    0   
  51    Goto           0     49    0                    0   
  52    Gosub          5     32    0                    0   
  53    Yield          3     46    0                    0   
  54    Goto           0     62    0                    0   
  55    Yield          3     46    0                    0   
  56    Goto           0     62    0                    0   
  57    Gosub          6     39    0                    0   
  58    Yield          4     49    0                    0   
  59    Goto           0     62    0                    0   
  60    Yield          3     47    0                    0   
  61    Yield          4     49    0                    0   
  62    Permutation    0     0     0     [0]            0   
  63    Compare        8     12    1     k(2,B,)        1   
  64    Jump           52    55    57                   0   
  65    Halt           0     0     0                    0   
  66    Transaction    0     0     8     0              1   
  67    Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 66 0 "" 0,  -- 0: Init
  vdbeInteger 0 1 0 "" 0,  -- 1: Integer
  vdbeInitCoroutine 3 17 3 "" 0,  -- 2: InitCoroutine
  vdbeSorterOpen 2 3 0 "k(1,B)" 0,  -- 3: SorterOpen
  vdbeOpenRead 1 2 0 "2" 0,  -- 4: OpenRead
  vdbeRewind 1 10 0 "" 0,  -- 5: Rewind
  vdbeColumn 1 0 7 "" 0,  -- 6: Column
  vdbeMakeRecord 7 1 9 "" 0,  -- 7: MakeRecord
  vdbeSorterInsert 2 9 7 "1" 0,  -- 8: SorterInsert
  vdbeNext 1 6 0 "" 1,  -- 9: Next
  vdbeOpenPseudo 3 10 3 "" 0,  -- 10: OpenPseudo
  vdbeSorterSort 2 16 0 "" 0,  -- 11: SorterSort
  vdbeSorterData 2 10 3 "" 0,  -- 12: SorterData
  vdbeColumn 3 0 8 "" 0,  -- 13: Column
  vdbeYield 3 0 0 "" 0,  -- 14: Yield
  vdbeSorterNext 2 12 0 "" 0,  -- 15: SorterNext
  vdbeEndCoroutine 3 0 0 "" 0,  -- 16: EndCoroutine
  vdbeInitCoroutine 4 60 18 "" 0,  -- 17: InitCoroutine
  vdbeSorterOpen 4 3 0 "k(1,B)" 0,  -- 18: SorterOpen
  vdbeOpenRead 0 2 0 "2" 0,  -- 19: OpenRead
  vdbeRewind 0 25 0 "" 0,  -- 20: Rewind
  vdbeColumn 0 1 11 "" 0,  -- 21: Column
  vdbeMakeRecord 11 1 13 "" 0,  -- 22: MakeRecord
  vdbeSorterInsert 4 13 11 "1" 0,  -- 23: SorterInsert
  vdbeNext 0 21 0 "" 1,  -- 24: Next
  vdbeOpenPseudo 5 14 3 "" 0,  -- 25: OpenPseudo
  vdbeSorterSort 4 31 0 "" 0,  -- 26: SorterSort
  vdbeSorterData 4 14 5 "" 0,  -- 27: SorterData
  vdbeColumn 5 0 12 "" 0,  -- 28: Column
  vdbeYield 4 0 0 "" 0,  -- 29: Yield
  vdbeSorterNext 4 27 0 "" 0,  -- 30: SorterNext
  vdbeEndCoroutine 4 0 0 "" 0,  -- 31: EndCoroutine
  vdbeIfNot 1 35 0 "" 0,  -- 32: IfNot
  vdbeCompare 8 2 1 "k(1,B)" 0,  -- 33: Compare
  vdbeJump 35 38 35 "" 0,  -- 34: Jump
  vdbeCopy 8 2 0 "" 0,  -- 35: Copy
  vdbeInteger 1 1 0 "" 0,  -- 36: Integer
  vdbeResultRow 8 1 0 "" 0,  -- 37: ResultRow
  vdbeReturn 5 0 0 "" 0,  -- 38: Return
  vdbeIfNot 1 42 0 "" 0,  -- 39: IfNot
  vdbeCompare 12 2 1 "k(1,B)" 0,  -- 40: Compare
  vdbeJump 42 45 42 "" 0,  -- 41: Jump
  vdbeCopy 12 2 0 "" 0,  -- 42: Copy
  vdbeInteger 1 1 0 "" 0,  -- 43: Integer
  vdbeResultRow 12 1 0 "" 0,  -- 44: ResultRow
  vdbeReturn 6 0 0 "" 0,  -- 45: Return
  vdbeGosub 6 39 0 "" 0,  -- 46: Gosub
  vdbeYield 4 65 0 "" 0,  -- 47: Yield
  vdbeGoto 0 46 0 "" 0,  -- 48: Goto
  vdbeGosub 5 32 0 "" 0,  -- 49: Gosub
  vdbeYield 3 65 0 "" 0,  -- 50: Yield
  vdbeGoto 0 49 0 "" 0,  -- 51: Goto
  vdbeGosub 5 32 0 "" 0,  -- 52: Gosub
  vdbeYield 3 46 0 "" 0,  -- 53: Yield
  vdbeGoto 0 62 0 "" 0,  -- 54: Goto
  vdbeYield 3 46 0 "" 0,  -- 55: Yield
  vdbeGoto 0 62 0 "" 0,  -- 56: Goto
  vdbeGosub 6 39 0 "" 0,  -- 57: Gosub
  vdbeYield 4 49 0 "" 0,  -- 58: Yield
  vdbeGoto 0 62 0 "" 0,  -- 59: Goto
  vdbeYield 3 47 0 "" 0,  -- 60: Yield
  vdbeYield 4 49 0 "" 0,  -- 61: Yield
  vdbePermutation 0 0 0 "[0]" 0,  -- 62: Permutation
  vdbeCompare 8 12 1 "k(2,B,)" 1,  -- 63: Compare
  vdbeJump 52 55 57 "" 0,  -- 64: Jump
  vdbeHalt 0 0 0 "" 0,  -- 65: Halt
  vdbeTransaction 0 0 8 "0" 1,  -- 66: Transaction
  vdbeGoto 0 1 0 "" 0  -- 67: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000092
