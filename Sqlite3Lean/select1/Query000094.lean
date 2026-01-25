import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000094

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=9 db=0 mode=read name=
    cursor=1 rootpage=9 db=0 mode=read name=

  Query: SELECT a FROM t6 WHERE b IN 
          (SELECT b FROM t6 WHERE a<='b' UNION SELECT '3' AS x
                   ORDER BY 1 DESC LIMIT 1)
     

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     81    0                    0   
  1     OpenRead       0     9     0     2              0   
  2     Rewind         0     80    0                    0   
  3     BeginSubrtn    0     1     0     subrtnsig:2,B  0   
  4     Once           0     71    2                    0   
  5     OpenEphemeral  2     1     0     k(1,B)         0   
  6     Blob           10000  2     0                    0   
  7     Integer        0     3     0                    0   
  8     Integer        1     5     0                    0   
  9     InitCoroutine  6     26    10                   0   
  10    SorterOpen     3     3     0     k(1,-B)        0   
  11    OpenRead       1     9     0     2              0   
  12    Rewind         1     19    0                    0   
  13    Column         1     0     10                   0   
  14    Gt             11    18    10    BINARY-8       82  
  15    Column         1     1     12                   0   
  16    MakeRecord     12    1     14                   0   
  17    SorterInsert   3     14    12    1              0   
  18    Next           1     13    0                    1   
  19    OpenPseudo     4     15    3                    0   
  20    SorterSort     3     25    0                    0   
  21    SorterData     3     15    4                    0   
  22    Column         4     0     13                   0   
  23    Yield          6     0     0                    0   
  24    SorterNext     3     21    0                    0   
  25    EndCoroutine   6     0     0                    0   
  26    InitCoroutine  7     65    27                   0   
  27    Noop           5     3     0                    0   
  28    String8        0     16    0     3              0   
  29    Yield          7     0     0                    0   
  30    EndCoroutine   7     0     0                    0   
  31    IfNot          3     34    0                    0   
  32    Compare        13    4     1     k(1,B)         0   
  33    Jump           34    40    34                   0   
  34    Copy           13    4     0                    0   
  35    Integer        1     3     0                    0   
  36    MakeRecord     13    1     17    B              0   
  37    IdxInsert      2     17    13    1              0   
  38    FilterAdd      2     0     13    1              0   
  39    DecrJumpZero   5     70    0                    0   
  40    Return         8     0     0                    0   
  41    IfNot          3     44    0                    0   
  42    Compare        16    4     1     k(1,B)         0   
  43    Jump           44    50    44                   0   
  44    Copy           16    4     0                    0   
  45    Integer        1     3     0                    0   
  46    MakeRecord     16    1     17    B              0   
  47    IdxInsert      2     17    16    1              0   
  48    FilterAdd      2     0     16    1              0   
  49    DecrJumpZero   5     70    0                    0   
  50    Return         9     0     0                    0   
  51    Gosub          9     41    0                    0   
  52    Yield          7     70    0                    0   
  53    Goto           0     51    0                    0   
  54    Gosub          8     31    0                    0   
  55    Yield          6     70    0                    0   
  56    Goto           0     54    0                    0   
  57    Gosub          8     31    0                    0   
  58    Yield          6     51    0                    0   
  59    Goto           0     67    0                    0   
  60    Yield          6     51    0                    0   
  61    Goto           0     67    0                    0   
  62    Gosub          9     41    0                    0   
  63    Yield          7     54    0                    0   
  64    Goto           0     67    0                    0   
  65    Yield          6     52    0                    0   
  66    Yield          7     54    0                    0   
  67    Permutation    0     0     0     [0]            0   
  68    Compare        13    16    1     k(2,-B,)       1   
  69    Jump           57    60    62                   0   
  70    NullRow        2     0     0                    0   
  71    Return         1     4     1                    0   
  72    Column         0     1     18                   0   
  73    IsNull         18    79    0                    0   
  74    Affinity       18    1     0     B              0   
  75    Filter         2     79    18    1              0   
  76    NotFound       2     79    18    1              0   
  77    Column         0     0     19                   0   
  78    ResultRow      19    1     0                    0   
  79    Next           0     3     0                    1   
  80    Halt           0     0     0                    0   
  81    Transaction    0     0     9     0              1   
  82    String8        0     11    0     b              0   
  83    Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 81 0 "" 0,  -- 0: Init
  vdbeOpenRead 0 9 0 "2" 0,  -- 1: OpenRead
  vdbeRewind 0 80 0 "" 0,  -- 2: Rewind
  vdbeBeginSubrtn 0 1 0 "subrtnsig:2,B" 0,  -- 3: BeginSubrtn
  vdbeOnce 0 71 2 "" 0,  -- 4: Once
  vdbeOpenEphemeral 2 1 0 "k(1,B)" 0,  -- 5: OpenEphemeral
  vdbeBlob 10000 2 0 "" 0,  -- 6: Blob
  vdbeInteger 0 3 0 "" 0,  -- 7: Integer
  vdbeInteger 1 5 0 "" 0,  -- 8: Integer
  vdbeInitCoroutine 6 26 10 "" 0,  -- 9: InitCoroutine
  vdbeSorterOpen 3 3 0 "k(1,-B)" 0,  -- 10: SorterOpen
  vdbeOpenRead 1 9 0 "2" 0,  -- 11: OpenRead
  vdbeRewind 1 19 0 "" 0,  -- 12: Rewind
  vdbeColumn 1 0 10 "" 0,  -- 13: Column
  vdbeGt 11 18 10 "BINARY-8" 82,  -- 14: Gt
  vdbeColumn 1 1 12 "" 0,  -- 15: Column
  vdbeMakeRecord 12 1 14 "" 0,  -- 16: MakeRecord
  vdbeSorterInsert 3 14 12 "1" 0,  -- 17: SorterInsert
  vdbeNext 1 13 0 "" 1,  -- 18: Next
  vdbeOpenPseudo 4 15 3 "" 0,  -- 19: OpenPseudo
  vdbeSorterSort 3 25 0 "" 0,  -- 20: SorterSort
  vdbeSorterData 3 15 4 "" 0,  -- 21: SorterData
  vdbeColumn 4 0 13 "" 0,  -- 22: Column
  vdbeYield 6 0 0 "" 0,  -- 23: Yield
  vdbeSorterNext 3 21 0 "" 0,  -- 24: SorterNext
  vdbeEndCoroutine 6 0 0 "" 0,  -- 25: EndCoroutine
  vdbeInitCoroutine 7 65 27 "" 0,  -- 26: InitCoroutine
  vdbeNoop 5 3 0 "" 0,  -- 27: Noop
  vdbeString8 0 16 0 "3" 0,  -- 28: String8
  vdbeYield 7 0 0 "" 0,  -- 29: Yield
  vdbeEndCoroutine 7 0 0 "" 0,  -- 30: EndCoroutine
  vdbeIfNot 3 34 0 "" 0,  -- 31: IfNot
  vdbeCompare 13 4 1 "k(1,B)" 0,  -- 32: Compare
  vdbeJump 34 40 34 "" 0,  -- 33: Jump
  vdbeCopy 13 4 0 "" 0,  -- 34: Copy
  vdbeInteger 1 3 0 "" 0,  -- 35: Integer
  vdbeMakeRecord 13 1 17 "B" 0,  -- 36: MakeRecord
  vdbeIdxInsert 2 17 13 "1" 0,  -- 37: IdxInsert
  vdbeFilterAdd 2 0 13 "1" 0,  -- 38: FilterAdd
  vdbeDecrJumpZero 5 70 0 "" 0,  -- 39: DecrJumpZero
  vdbeReturn 8 0 0 "" 0,  -- 40: Return
  vdbeIfNot 3 44 0 "" 0,  -- 41: IfNot
  vdbeCompare 16 4 1 "k(1,B)" 0,  -- 42: Compare
  vdbeJump 44 50 44 "" 0,  -- 43: Jump
  vdbeCopy 16 4 0 "" 0,  -- 44: Copy
  vdbeInteger 1 3 0 "" 0,  -- 45: Integer
  vdbeMakeRecord 16 1 17 "B" 0,  -- 46: MakeRecord
  vdbeIdxInsert 2 17 16 "1" 0,  -- 47: IdxInsert
  vdbeFilterAdd 2 0 16 "1" 0,  -- 48: FilterAdd
  vdbeDecrJumpZero 5 70 0 "" 0,  -- 49: DecrJumpZero
  vdbeReturn 9 0 0 "" 0,  -- 50: Return
  vdbeGosub 9 41 0 "" 0,  -- 51: Gosub
  vdbeYield 7 70 0 "" 0,  -- 52: Yield
  vdbeGoto 0 51 0 "" 0,  -- 53: Goto
  vdbeGosub 8 31 0 "" 0,  -- 54: Gosub
  vdbeYield 6 70 0 "" 0,  -- 55: Yield
  vdbeGoto 0 54 0 "" 0,  -- 56: Goto
  vdbeGosub 8 31 0 "" 0,  -- 57: Gosub
  vdbeYield 6 51 0 "" 0,  -- 58: Yield
  vdbeGoto 0 67 0 "" 0,  -- 59: Goto
  vdbeYield 6 51 0 "" 0,  -- 60: Yield
  vdbeGoto 0 67 0 "" 0,  -- 61: Goto
  vdbeGosub 9 41 0 "" 0,  -- 62: Gosub
  vdbeYield 7 54 0 "" 0,  -- 63: Yield
  vdbeGoto 0 67 0 "" 0,  -- 64: Goto
  vdbeYield 6 52 0 "" 0,  -- 65: Yield
  vdbeYield 7 54 0 "" 0,  -- 66: Yield
  vdbePermutation 0 0 0 "[0]" 0,  -- 67: Permutation
  vdbeCompare 13 16 1 "k(2,-B,)" 1,  -- 68: Compare
  vdbeJump 57 60 62 "" 0,  -- 69: Jump
  vdbeNullRow 2 0 0 "" 0,  -- 70: NullRow
  vdbeReturn 1 4 1 "" 0,  -- 71: Return
  vdbeColumn 0 1 18 "" 0,  -- 72: Column
  vdbeIsNull 18 79 0 "" 0,  -- 73: IsNull
  vdbeAffinity 18 1 0 "B" 0,  -- 74: Affinity
  vdbeFilter 2 79 18 "1" 0,  -- 75: Filter
  vdbeNotFound 2 79 18 "1" 0,  -- 76: NotFound
  vdbeColumn 0 0 19 "" 0,  -- 77: Column
  vdbeResultRow 19 1 0 "" 0,  -- 78: ResultRow
  vdbeNext 0 3 0 "" 1,  -- 79: Next
  vdbeHalt 0 0 0 "" 0,  -- 80: Halt
  vdbeTransaction 0 0 9 "0" 1,  -- 81: Transaction
  vdbeString8 0 11 0 "b" 0,  -- 82: String8
  vdbeGoto 0 1 0 "" 0  -- 83: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000094
