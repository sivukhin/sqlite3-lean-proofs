import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000095

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=9 db=0 mode=read name=
    cursor=1 rootpage=9 db=0 mode=read name=

  Query: SELECT a FROM t6 WHERE b IN 
          (SELECT b FROM t6 WHERE a<='b' UNION SELECT '3' AS x
                   ORDER BY b LIMIT 2)
       ORDER BY a;

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     89    0                    0   
  1     SorterOpen     2     3     0     k(1,B)         0   
  2     OpenRead       0     9     0     2              0   
  3     Rewind         0     82    0                    0   
  4     BeginSubrtn    0     1     0     subrtnsig:2,B  0   
  5     Once           0     72    2                    0   
  6     OpenEphemeral  3     1     0     k(1,B)         0   
  7     Blob           10000  2     0                    0   
  8     Integer        0     3     0                    0   
  9     Integer        2     5     0                    0   
  10    InitCoroutine  6     27    11                   0   
  11    SorterOpen     4     3     0     k(1,B)         0   
  12    OpenRead       1     9     0     2              0   
  13    Rewind         1     20    0                    0   
  14    Column         1     0     10                   0   
  15    Gt             11    19    10    BINARY-8       82  
  16    Column         1     1     12                   0   
  17    MakeRecord     12    1     14                   0   
  18    SorterInsert   4     14    12    1              0   
  19    Next           1     14    0                    1   
  20    OpenPseudo     5     15    3                    0   
  21    SorterSort     4     26    0                    0   
  22    SorterData     4     15    5                    0   
  23    Column         5     0     13                   0   
  24    Yield          6     0     0                    0   
  25    SorterNext     4     22    0                    0   
  26    EndCoroutine   6     0     0                    0   
  27    InitCoroutine  7     66    28                   0   
  28    Noop           6     3     0                    0   
  29    String8        0     16    0     3              0   
  30    Yield          7     0     0                    0   
  31    EndCoroutine   7     0     0                    0   
  32    IfNot          3     35    0                    0   
  33    Compare        13    4     1     k(1,B)         0   
  34    Jump           35    41    35                   0   
  35    Copy           13    4     0                    0   
  36    Integer        1     3     0                    0   
  37    MakeRecord     13    1     17    B              0   
  38    IdxInsert      3     17    13    1              0   
  39    FilterAdd      2     0     13    1              0   
  40    DecrJumpZero   5     71    0                    0   
  41    Return         8     0     0                    0   
  42    IfNot          3     45    0                    0   
  43    Compare        16    4     1     k(1,B)         0   
  44    Jump           45    51    45                   0   
  45    Copy           16    4     0                    0   
  46    Integer        1     3     0                    0   
  47    MakeRecord     16    1     17    B              0   
  48    IdxInsert      3     17    16    1              0   
  49    FilterAdd      2     0     16    1              0   
  50    DecrJumpZero   5     71    0                    0   
  51    Return         9     0     0                    0   
  52    Gosub          9     42    0                    0   
  53    Yield          7     71    0                    0   
  54    Goto           0     52    0                    0   
  55    Gosub          8     32    0                    0   
  56    Yield          6     71    0                    0   
  57    Goto           0     55    0                    0   
  58    Gosub          8     32    0                    0   
  59    Yield          6     52    0                    0   
  60    Goto           0     68    0                    0   
  61    Yield          6     52    0                    0   
  62    Goto           0     68    0                    0   
  63    Gosub          9     42    0                    0   
  64    Yield          7     55    0                    0   
  65    Goto           0     68    0                    0   
  66    Yield          6     53    0                    0   
  67    Yield          7     55    0                    0   
  68    Permutation    0     0     0     [0]            0   
  69    Compare        13    16    1     k(2,B,)        1   
  70    Jump           58    61    63                   0   
  71    NullRow        3     0     0                    0   
  72    Return         1     5     1                    0   
  73    Column         0     1     18                   0   
  74    IsNull         18    81    0                    0   
  75    Affinity       18    1     0     B              0   
  76    Filter         2     81    18    1              0   
  77    NotFound       3     81    18    1              0   
  78    Column         0     0     19                   0   
  79    MakeRecord     19    1     21                   0   
  80    SorterInsert   2     21    19    1              0   
  81    Next           0     4     0                    1   
  82    OpenPseudo     7     22    3                    0   
  83    SorterSort     2     88    0                    0   
  84    SorterData     2     22    7                    0   
  85    Column         7     0     20                   0   
  86    ResultRow      20    1     0                    0   
  87    SorterNext     2     84    0                    0   
  88    Halt           0     0     0                    0   
  89    Transaction    0     0     9     0              1   
  90    String8        0     11    0     b              0   
  91    Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 89 0 "" 0,  -- 0: Init
  vdbeSorterOpen 2 3 0 "k(1,B)" 0,  -- 1: SorterOpen
  vdbeOpenRead 0 9 0 "2" 0,  -- 2: OpenRead
  vdbeRewind 0 82 0 "" 0,  -- 3: Rewind
  vdbeBeginSubrtn 0 1 0 "subrtnsig:2,B" 0,  -- 4: BeginSubrtn
  vdbeOnce 0 72 2 "" 0,  -- 5: Once
  vdbeOpenEphemeral 3 1 0 "k(1,B)" 0,  -- 6: OpenEphemeral
  vdbeBlob 10000 2 0 "" 0,  -- 7: Blob
  vdbeInteger 0 3 0 "" 0,  -- 8: Integer
  vdbeInteger 2 5 0 "" 0,  -- 9: Integer
  vdbeInitCoroutine 6 27 11 "" 0,  -- 10: InitCoroutine
  vdbeSorterOpen 4 3 0 "k(1,B)" 0,  -- 11: SorterOpen
  vdbeOpenRead 1 9 0 "2" 0,  -- 12: OpenRead
  vdbeRewind 1 20 0 "" 0,  -- 13: Rewind
  vdbeColumn 1 0 10 "" 0,  -- 14: Column
  vdbeGt 11 19 10 "BINARY-8" 82,  -- 15: Gt
  vdbeColumn 1 1 12 "" 0,  -- 16: Column
  vdbeMakeRecord 12 1 14 "" 0,  -- 17: MakeRecord
  vdbeSorterInsert 4 14 12 "1" 0,  -- 18: SorterInsert
  vdbeNext 1 14 0 "" 1,  -- 19: Next
  vdbeOpenPseudo 5 15 3 "" 0,  -- 20: OpenPseudo
  vdbeSorterSort 4 26 0 "" 0,  -- 21: SorterSort
  vdbeSorterData 4 15 5 "" 0,  -- 22: SorterData
  vdbeColumn 5 0 13 "" 0,  -- 23: Column
  vdbeYield 6 0 0 "" 0,  -- 24: Yield
  vdbeSorterNext 4 22 0 "" 0,  -- 25: SorterNext
  vdbeEndCoroutine 6 0 0 "" 0,  -- 26: EndCoroutine
  vdbeInitCoroutine 7 66 28 "" 0,  -- 27: InitCoroutine
  vdbeNoop 6 3 0 "" 0,  -- 28: Noop
  vdbeString8 0 16 0 "3" 0,  -- 29: String8
  vdbeYield 7 0 0 "" 0,  -- 30: Yield
  vdbeEndCoroutine 7 0 0 "" 0,  -- 31: EndCoroutine
  vdbeIfNot 3 35 0 "" 0,  -- 32: IfNot
  vdbeCompare 13 4 1 "k(1,B)" 0,  -- 33: Compare
  vdbeJump 35 41 35 "" 0,  -- 34: Jump
  vdbeCopy 13 4 0 "" 0,  -- 35: Copy
  vdbeInteger 1 3 0 "" 0,  -- 36: Integer
  vdbeMakeRecord 13 1 17 "B" 0,  -- 37: MakeRecord
  vdbeIdxInsert 3 17 13 "1" 0,  -- 38: IdxInsert
  vdbeFilterAdd 2 0 13 "1" 0,  -- 39: FilterAdd
  vdbeDecrJumpZero 5 71 0 "" 0,  -- 40: DecrJumpZero
  vdbeReturn 8 0 0 "" 0,  -- 41: Return
  vdbeIfNot 3 45 0 "" 0,  -- 42: IfNot
  vdbeCompare 16 4 1 "k(1,B)" 0,  -- 43: Compare
  vdbeJump 45 51 45 "" 0,  -- 44: Jump
  vdbeCopy 16 4 0 "" 0,  -- 45: Copy
  vdbeInteger 1 3 0 "" 0,  -- 46: Integer
  vdbeMakeRecord 16 1 17 "B" 0,  -- 47: MakeRecord
  vdbeIdxInsert 3 17 16 "1" 0,  -- 48: IdxInsert
  vdbeFilterAdd 2 0 16 "1" 0,  -- 49: FilterAdd
  vdbeDecrJumpZero 5 71 0 "" 0,  -- 50: DecrJumpZero
  vdbeReturn 9 0 0 "" 0,  -- 51: Return
  vdbeGosub 9 42 0 "" 0,  -- 52: Gosub
  vdbeYield 7 71 0 "" 0,  -- 53: Yield
  vdbeGoto 0 52 0 "" 0,  -- 54: Goto
  vdbeGosub 8 32 0 "" 0,  -- 55: Gosub
  vdbeYield 6 71 0 "" 0,  -- 56: Yield
  vdbeGoto 0 55 0 "" 0,  -- 57: Goto
  vdbeGosub 8 32 0 "" 0,  -- 58: Gosub
  vdbeYield 6 52 0 "" 0,  -- 59: Yield
  vdbeGoto 0 68 0 "" 0,  -- 60: Goto
  vdbeYield 6 52 0 "" 0,  -- 61: Yield
  vdbeGoto 0 68 0 "" 0,  -- 62: Goto
  vdbeGosub 9 42 0 "" 0,  -- 63: Gosub
  vdbeYield 7 55 0 "" 0,  -- 64: Yield
  vdbeGoto 0 68 0 "" 0,  -- 65: Goto
  vdbeYield 6 53 0 "" 0,  -- 66: Yield
  vdbeYield 7 55 0 "" 0,  -- 67: Yield
  vdbePermutation 0 0 0 "[0]" 0,  -- 68: Permutation
  vdbeCompare 13 16 1 "k(2,B,)" 1,  -- 69: Compare
  vdbeJump 58 61 63 "" 0,  -- 70: Jump
  vdbeNullRow 3 0 0 "" 0,  -- 71: NullRow
  vdbeReturn 1 5 1 "" 0,  -- 72: Return
  vdbeColumn 0 1 18 "" 0,  -- 73: Column
  vdbeIsNull 18 81 0 "" 0,  -- 74: IsNull
  vdbeAffinity 18 1 0 "B" 0,  -- 75: Affinity
  vdbeFilter 2 81 18 "1" 0,  -- 76: Filter
  vdbeNotFound 3 81 18 "1" 0,  -- 77: NotFound
  vdbeColumn 0 0 19 "" 0,  -- 78: Column
  vdbeMakeRecord 19 1 21 "" 0,  -- 79: MakeRecord
  vdbeSorterInsert 2 21 19 "1" 0,  -- 80: SorterInsert
  vdbeNext 0 4 0 "" 1,  -- 81: Next
  vdbeOpenPseudo 7 22 3 "" 0,  -- 82: OpenPseudo
  vdbeSorterSort 2 88 0 "" 0,  -- 83: SorterSort
  vdbeSorterData 2 22 7 "" 0,  -- 84: SorterData
  vdbeColumn 7 0 20 "" 0,  -- 85: Column
  vdbeResultRow 20 1 0 "" 0,  -- 86: ResultRow
  vdbeSorterNext 2 84 0 "" 0,  -- 87: SorterNext
  vdbeHalt 0 0 0 "" 0,  -- 88: Halt
  vdbeTransaction 0 0 9 "0" 1,  -- 89: Transaction
  vdbeString8 0 11 0 "b" 0,  -- 90: String8
  vdbeGoto 0 1 0 "" 0  -- 91: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000095
