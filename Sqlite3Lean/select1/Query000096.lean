import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000096

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=9 db=0 mode=read name=
    cursor=1 rootpage=9 db=0 mode=read name=

  Query: SELECT a FROM t6 WHERE b IN 
          (SELECT b FROM t6 WHERE a<='b' UNION SELECT '3' AS x
                   ORDER BY x DESC LIMIT 2)
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
  11    SorterOpen     4     3     0     k(1,-B)        0   
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
  69    Compare        13    16    1     k(2,-B,)       1   
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
  .init 0 89 0 0 0,  -- 0: Init
  .sorterOpen 2 3 0 "k(1,B)" 0,  -- 1: SorterOpen
  .openRead 0 9 0 2 0,  -- 2: OpenRead
  .rewind 0 82 0 0 0,  -- 3: Rewind
  .beginSubrtn 0 1 0 "subrtnsig:2,B" 0,  -- 4: BeginSubrtn
  .once 0 72 2 0 0,  -- 5: Once
  .openEphemeral 3 1 0 "k(1,B)" 0,  -- 6: OpenEphemeral
  .blob 10000 2 0 0 0,  -- 7: Blob
  .integer 0 3 0 0 0,  -- 8: Integer
  .integer 2 5 0 0 0,  -- 9: Integer
  .initCoroutine 6 27 11 0 0,  -- 10: InitCoroutine
  .sorterOpen 4 3 0 "k(1,-B)" 0,  -- 11: SorterOpen
  .openRead 1 9 0 2 0,  -- 12: OpenRead
  .rewind 1 20 0 0 0,  -- 13: Rewind
  .column 1 0 10 0 0,  -- 14: Column
  .gt 11 19 10 "BINARY-8" 82,  -- 15: Gt
  .column 1 1 12 0 0,  -- 16: Column
  .makeRecord 12 1 14 0 0,  -- 17: MakeRecord
  .sorterInsert 4 14 12 1 0,  -- 18: SorterInsert
  .next 1 14 0 0 1,  -- 19: Next
  .openPseudo 5 15 3 0 0,  -- 20: OpenPseudo
  .sorterSort 4 26 0 0 0,  -- 21: SorterSort
  .sorterData 4 15 5 0 0,  -- 22: SorterData
  .column 5 0 13 0 0,  -- 23: Column
  .yield 6 0 0 0 0,  -- 24: Yield
  .sorterNext 4 22 0 0 0,  -- 25: SorterNext
  .endCoroutine 6 0 0 0 0,  -- 26: EndCoroutine
  .initCoroutine 7 66 28 0 0,  -- 27: InitCoroutine
  .noop 6 3 0 0 0,  -- 28: Noop
  .string8 0 16 0 "3" 0,  -- 29: String8
  .yield 7 0 0 0 0,  -- 30: Yield
  .endCoroutine 7 0 0 0 0,  -- 31: EndCoroutine
  .ifNot 3 35 0 0 0,  -- 32: IfNot
  .compare 13 4 1 "k(1,B)" 0,  -- 33: Compare
  .jump 35 41 35 0 0,  -- 34: Jump
  .copy 13 4 0 0 0,  -- 35: Copy
  .integer 1 3 0 0 0,  -- 36: Integer
  .makeRecord 13 1 17 "B" 0,  -- 37: MakeRecord
  .idxInsert 3 17 13 1 0,  -- 38: IdxInsert
  .filterAdd 2 0 13 1 0,  -- 39: FilterAdd
  .decrJumpZero 5 71 0 0 0,  -- 40: DecrJumpZero
  .return 8 0 0 0 0,  -- 41: Return
  .ifNot 3 45 0 0 0,  -- 42: IfNot
  .compare 16 4 1 "k(1,B)" 0,  -- 43: Compare
  .jump 45 51 45 0 0,  -- 44: Jump
  .copy 16 4 0 0 0,  -- 45: Copy
  .integer 1 3 0 0 0,  -- 46: Integer
  .makeRecord 16 1 17 "B" 0,  -- 47: MakeRecord
  .idxInsert 3 17 16 1 0,  -- 48: IdxInsert
  .filterAdd 2 0 16 1 0,  -- 49: FilterAdd
  .decrJumpZero 5 71 0 0 0,  -- 50: DecrJumpZero
  .return 9 0 0 0 0,  -- 51: Return
  .gosub 9 42 0 0 0,  -- 52: Gosub
  .yield 7 71 0 0 0,  -- 53: Yield
  .goto 0 52 0 0 0,  -- 54: Goto
  .gosub 8 32 0 0 0,  -- 55: Gosub
  .yield 6 71 0 0 0,  -- 56: Yield
  .goto 0 55 0 0 0,  -- 57: Goto
  .gosub 8 32 0 0 0,  -- 58: Gosub
  .yield 6 52 0 0 0,  -- 59: Yield
  .goto 0 68 0 0 0,  -- 60: Goto
  .yield 6 52 0 0 0,  -- 61: Yield
  .goto 0 68 0 0 0,  -- 62: Goto
  .gosub 9 42 0 0 0,  -- 63: Gosub
  .yield 7 55 0 0 0,  -- 64: Yield
  .goto 0 68 0 0 0,  -- 65: Goto
  .yield 6 53 0 0 0,  -- 66: Yield
  .yield 7 55 0 0 0,  -- 67: Yield
  .permutation 0 0 0 "[0]" 0,  -- 68: Permutation
  .compare 13 16 1 "k(2,-B,)" 1,  -- 69: Compare
  .jump 58 61 63 0 0,  -- 70: Jump
  .nullRow 3 0 0 0 0,  -- 71: NullRow
  .return 1 5 1 0 0,  -- 72: Return
  .column 0 1 18 0 0,  -- 73: Column
  .isNull 18 81 0 0 0,  -- 74: IsNull
  .affinity 18 1 0 "B" 0,  -- 75: Affinity
  .filter 2 81 18 1 0,  -- 76: Filter
  .notFound 3 81 18 1 0,  -- 77: NotFound
  .column 0 0 19 0 0,  -- 78: Column
  .makeRecord 19 1 21 0 0,  -- 79: MakeRecord
  .sorterInsert 2 21 19 1 0,  -- 80: SorterInsert
  .next 0 4 0 0 1,  -- 81: Next
  .openPseudo 7 22 3 0 0,  -- 82: OpenPseudo
  .sorterSort 2 88 0 0 0,  -- 83: SorterSort
  .sorterData 2 22 7 0 0,  -- 84: SorterData
  .column 7 0 20 0 0,  -- 85: Column
  .resultRow 20 1 0 0 0,  -- 86: ResultRow
  .sorterNext 2 84 0 0 0,  -- 87: SorterNext
  .halt 0 0 0 0 0,  -- 88: Halt
  .transaction 0 0 9 0 1,  -- 89: Transaction
  .string8 0 11 0 "b" 0,  -- 90: String8
  .goto 0 1 0 0 0  -- 91: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000096
