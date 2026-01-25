import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000094

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
  .init 0 81 0 0 0,  -- 0: Init
  .openRead 0 9 0 2 0,  -- 1: OpenRead
  .rewind 0 80 0 0 0,  -- 2: Rewind
  .beginSubrtn 0 1 0 "subrtnsig:2,B" 0,  -- 3: BeginSubrtn
  .once 0 71 2 0 0,  -- 4: Once
  .openEphemeral 2 1 0 "k(1,B)" 0,  -- 5: OpenEphemeral
  .blob 10000 2 0 0 0,  -- 6: Blob
  .integer 0 3 0 0 0,  -- 7: Integer
  .integer 1 5 0 0 0,  -- 8: Integer
  .initCoroutine 6 26 10 0 0,  -- 9: InitCoroutine
  .sorterOpen 3 3 0 "k(1,-B)" 0,  -- 10: SorterOpen
  .openRead 1 9 0 2 0,  -- 11: OpenRead
  .rewind 1 19 0 0 0,  -- 12: Rewind
  .column 1 0 10 0 0,  -- 13: Column
  .gt 11 18 10 "BINARY-8" 82,  -- 14: Gt
  .column 1 1 12 0 0,  -- 15: Column
  .makeRecord 12 1 14 0 0,  -- 16: MakeRecord
  .sorterInsert 3 14 12 1 0,  -- 17: SorterInsert
  .next 1 13 0 0 1,  -- 18: Next
  .openPseudo 4 15 3 0 0,  -- 19: OpenPseudo
  .sorterSort 3 25 0 0 0,  -- 20: SorterSort
  .sorterData 3 15 4 0 0,  -- 21: SorterData
  .column 4 0 13 0 0,  -- 22: Column
  .yield 6 0 0 0 0,  -- 23: Yield
  .sorterNext 3 21 0 0 0,  -- 24: SorterNext
  .endCoroutine 6 0 0 0 0,  -- 25: EndCoroutine
  .initCoroutine 7 65 27 0 0,  -- 26: InitCoroutine
  .noop 5 3 0 0 0,  -- 27: Noop
  .string8 0 16 0 "3" 0,  -- 28: String8
  .yield 7 0 0 0 0,  -- 29: Yield
  .endCoroutine 7 0 0 0 0,  -- 30: EndCoroutine
  .ifNot 3 34 0 0 0,  -- 31: IfNot
  .compare 13 4 1 "k(1,B)" 0,  -- 32: Compare
  .jump 34 40 34 0 0,  -- 33: Jump
  .copy 13 4 0 0 0,  -- 34: Copy
  .integer 1 3 0 0 0,  -- 35: Integer
  .makeRecord 13 1 17 "B" 0,  -- 36: MakeRecord
  .idxInsert 2 17 13 1 0,  -- 37: IdxInsert
  .filterAdd 2 0 13 1 0,  -- 38: FilterAdd
  .decrJumpZero 5 70 0 0 0,  -- 39: DecrJumpZero
  .return 8 0 0 0 0,  -- 40: Return
  .ifNot 3 44 0 0 0,  -- 41: IfNot
  .compare 16 4 1 "k(1,B)" 0,  -- 42: Compare
  .jump 44 50 44 0 0,  -- 43: Jump
  .copy 16 4 0 0 0,  -- 44: Copy
  .integer 1 3 0 0 0,  -- 45: Integer
  .makeRecord 16 1 17 "B" 0,  -- 46: MakeRecord
  .idxInsert 2 17 16 1 0,  -- 47: IdxInsert
  .filterAdd 2 0 16 1 0,  -- 48: FilterAdd
  .decrJumpZero 5 70 0 0 0,  -- 49: DecrJumpZero
  .return 9 0 0 0 0,  -- 50: Return
  .gosub 9 41 0 0 0,  -- 51: Gosub
  .yield 7 70 0 0 0,  -- 52: Yield
  .goto 0 51 0 0 0,  -- 53: Goto
  .gosub 8 31 0 0 0,  -- 54: Gosub
  .yield 6 70 0 0 0,  -- 55: Yield
  .goto 0 54 0 0 0,  -- 56: Goto
  .gosub 8 31 0 0 0,  -- 57: Gosub
  .yield 6 51 0 0 0,  -- 58: Yield
  .goto 0 67 0 0 0,  -- 59: Goto
  .yield 6 51 0 0 0,  -- 60: Yield
  .goto 0 67 0 0 0,  -- 61: Goto
  .gosub 9 41 0 0 0,  -- 62: Gosub
  .yield 7 54 0 0 0,  -- 63: Yield
  .goto 0 67 0 0 0,  -- 64: Goto
  .yield 6 52 0 0 0,  -- 65: Yield
  .yield 7 54 0 0 0,  -- 66: Yield
  .permutation 0 0 0 "[0]" 0,  -- 67: Permutation
  .compare 13 16 1 "k(2,-B,)" 1,  -- 68: Compare
  .jump 57 60 62 0 0,  -- 69: Jump
  .nullRow 2 0 0 0 0,  -- 70: NullRow
  .return 1 4 1 0 0,  -- 71: Return
  .column 0 1 18 0 0,  -- 72: Column
  .isNull 18 79 0 0 0,  -- 73: IsNull
  .affinity 18 1 0 "B" 0,  -- 74: Affinity
  .filter 2 79 18 1 0,  -- 75: Filter
  .notFound 2 79 18 1 0,  -- 76: NotFound
  .column 0 0 19 0 0,  -- 77: Column
  .resultRow 19 1 0 0 0,  -- 78: ResultRow
  .next 0 3 0 0 1,  -- 79: Next
  .halt 0 0 0 0 0,  -- 80: Halt
  .transaction 0 0 9 0 1,  -- 81: Transaction
  .string8 0 11 0 "b" 0,  -- 82: String8
  .goto 0 1 0 0 0  -- 83: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000094
