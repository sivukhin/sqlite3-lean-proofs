import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000145

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=3 rootpage=4 db=0 mode=read name=
    cursor=5 rootpage=5 db=0 mode=read name=
    cursor=2 rootpage=4 db=0 mode=read name=
    cursor=7 rootpage=5 db=0 mode=read name=
    cursor=0 rootpage=3 db=0 mode=read name=

  Query: SELECT * FROM t1,(SELECT * FROM t2 WHERE y=2
           UNION ALL SELECT * FROM t2 WHERE y=3 ORDER BY y,z LIMIT 4);

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     112   0                    0   
  1     InitCoroutine  1     101   2                    0   
  2     Integer        4     2     0                    0   
  3     Copy           2     3     0                    0   
  4     Copy           3     4     0                    0   
  5     InitCoroutine  5     40    6                    0   
  6     OpenEphemeral  4     3     0     k(1,B)         0   
  7     OpenRead       3     4     0     2              0   
  8     OpenRead       5     5     0     k(2,,)         2   
  9     Integer        2     9     0                    0   
  10    SeekGE         5     31    9     1              0   
  11    IdxGT          5     31    9     1              0   
  12    DeferredSeek   5     0     3                    0   
  13    Column         5     0     10                   0   
  14    Column         3     1     11                   0   
  15    Sequence       4     12    0                    0   
  16    Column         5     0     13                   0   
  17    MakeRecord     11    3     15                   0   
  18    IfNot          12    24    0                    0   
  19    Compare        16    10    1     k(2,B,B)       0   
  20    Jump           21    25    21                   0   
  21    Gosub          17    33    0                    0   
  22    ResetSorter    4     0     0                    0   
  23    IfNot          3     39    0                    0   
  24    Move           10    16    1                    0   
  25    IfNotZero      3     29    0                    0   
  26    Last           4     0     0                    0   
  27    IdxLE          4     30    11    1              0   
  28    Delete         4     0     0                    0   
  29    IdxInsert      4     15    11    3              0   
  30    Next           5     11    1                    0   
  31    Gosub          17    33    0                    0   
  32    Goto           0     39    0                    0   
  33    Sort           4     39    0                    0   
  34    Column         4     0     14                   0   
  35    Column         4     2     13                   0   
  36    Yield          5     0     0                    0   
  37    Next           4     34    0                    0   
  38    Return         17    0     0                    0   
  39    EndCoroutine   5     0     0                    0   
  40    InitCoroutine  6     95    41                   0   
  41    OpenEphemeral  6     3     0     k(1,B)         0   
  42    OpenRead       2     4     0     2              0   
  43    OpenRead       7     5     0     k(2,,)         2   
  44    Integer        3     18    0                    0   
  45    SeekGE         7     66    18    1              0   
  46    IdxGT          7     66    18    1              0   
  47    DeferredSeek   7     0     2                    0   
  48    Column         7     0     19                   0   
  49    Column         2     1     20                   0   
  50    Sequence       6     21    0                    0   
  51    Column         7     0     22                   0   
  52    MakeRecord     20    3     24                   0   
  53    IfNot          21    59    0                    0   
  54    Compare        25    19    1     k(2,B,B)       0   
  55    Jump           56    60    56                   0   
  56    Gosub          26    68    0                    0   
  57    ResetSorter    6     0     0                    0   
  58    IfNot          4     74    0                    0   
  59    Move           19    25    1                    0   
  60    IfNotZero      4     64    0                    0   
  61    Last           6     0     0                    0   
  62    IdxLE          6     65    20    1              0   
  63    Delete         6     0     0                    0   
  64    IdxInsert      6     24    20    3              0   
  65    Next           7     46    1                    0   
  66    Gosub          26    68    0                    0   
  67    Goto           0     74    0                    0   
  68    Sort           6     74    0                    0   
  69    Column         6     0     23                   0   
  70    Column         6     2     22                   0   
  71    Yield          6     0     0                    0   
  72    Next           6     69    0                    0   
  73    Return         26    0     0                    0   
  74    EndCoroutine   6     0     0                    0   
  75    Move           13    27    2                    0   
  76    Yield          1     0     0                    0   
  77    DecrJumpZero   2     100   0                    0   
  78    Return         7     0     0                    0   
  79    Move           22    27    2                    0   
  80    Yield          1     0     0                    0   
  81    DecrJumpZero   2     100   0                    0   
  82    Return         8     0     0                    0   
  83    Gosub          8     79    0                    0   
  84    Yield          6     100   0                    0   
  85    Goto           0     83    0                    0   
  86    Gosub          7     75    0                    0   
  87    Yield          5     100   0                    0   
  88    Goto           0     86    0                    0   
  89    Gosub          7     75    0                    0   
  90    Yield          5     83    0                    0   
  91    Goto           0     97    0                    0   
  92    Gosub          8     79    0                    0   
  93    Yield          6     86    0                    0   
  94    Goto           0     97    0                    0   
  95    Yield          5     84    0                    0   
  96    Yield          6     86    0                    0   
  97    Permutation    0     0     0     [0,1]          0   
  98    Compare        13    22    2     k(3,B,B,)      1   
  99    Jump           89    89    92                   0   
  100   EndCoroutine   1     0     0                    0   
  101   OpenRead       0     3     0     1              0   
  102   InitCoroutine  1     0     2                    0   
  103   Yield          1     111   0                    0   
  104   Rewind         0     111   0                    0   
  105   Column         0     0     29                   0   
  106   Copy           27    30    0                    2   
  107   Copy           28    31    0                    2   
  108   ResultRow      29    3     0                    0   
  109   Next           0     105   0                    1   
  110   Goto           0     103   0                    0   
  111   Halt           0     0     0                    0   
  112   Transaction    0     0     25    1              1   
  113   Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 112 0 "" 0,  -- 0: Init
  vdbeInitCoroutine 1 101 2 "" 0,  -- 1: InitCoroutine
  vdbeInteger 4 2 0 "" 0,  -- 2: Integer
  vdbeCopy 2 3 0 "" 0,  -- 3: Copy
  vdbeCopy 3 4 0 "" 0,  -- 4: Copy
  vdbeInitCoroutine 5 40 6 "" 0,  -- 5: InitCoroutine
  vdbeOpenEphemeral 4 3 0 "k(1,B)" 0,  -- 6: OpenEphemeral
  vdbeOpenRead 3 4 0 "2" 0,  -- 7: OpenRead
  vdbeOpenRead 5 5 0 "k(2,,)" 2,  -- 8: OpenRead
  vdbeInteger 2 9 0 "" 0,  -- 9: Integer
  vdbeSeekGE 5 31 9 "1" 0,  -- 10: SeekGE
  vdbeIdxGT 5 31 9 "1" 0,  -- 11: IdxGT
  vdbeDeferredSeek 5 0 3 "" 0,  -- 12: DeferredSeek
  vdbeColumn 5 0 10 "" 0,  -- 13: Column
  vdbeColumn 3 1 11 "" 0,  -- 14: Column
  vdbeSequence 4 12 0 "" 0,  -- 15: Sequence
  vdbeColumn 5 0 13 "" 0,  -- 16: Column
  vdbeMakeRecord 11 3 15 "" 0,  -- 17: MakeRecord
  vdbeIfNot 12 24 0 "" 0,  -- 18: IfNot
  vdbeCompare 16 10 1 "k(2,B,B)" 0,  -- 19: Compare
  vdbeJump 21 25 21 "" 0,  -- 20: Jump
  vdbeGosub 17 33 0 "" 0,  -- 21: Gosub
  vdbeResetSorter 4 0 0 "" 0,  -- 22: ResetSorter
  vdbeIfNot 3 39 0 "" 0,  -- 23: IfNot
  vdbeMove 10 16 1 "" 0,  -- 24: Move
  vdbeIfNotZero 3 29 0 "" 0,  -- 25: IfNotZero
  vdbeLast 4 0 0 "" 0,  -- 26: Last
  vdbeIdxLE 4 30 11 "1" 0,  -- 27: IdxLE
  vdbeDelete 4 0 0 "" 0,  -- 28: Delete
  vdbeIdxInsert 4 15 11 "3" 0,  -- 29: IdxInsert
  vdbeNext 5 11 1 "" 0,  -- 30: Next
  vdbeGosub 17 33 0 "" 0,  -- 31: Gosub
  vdbeGoto 0 39 0 "" 0,  -- 32: Goto
  vdbeSort 4 39 0 "" 0,  -- 33: Sort
  vdbeColumn 4 0 14 "" 0,  -- 34: Column
  vdbeColumn 4 2 13 "" 0,  -- 35: Column
  vdbeYield 5 0 0 "" 0,  -- 36: Yield
  vdbeNext 4 34 0 "" 0,  -- 37: Next
  vdbeReturn 17 0 0 "" 0,  -- 38: Return
  vdbeEndCoroutine 5 0 0 "" 0,  -- 39: EndCoroutine
  vdbeInitCoroutine 6 95 41 "" 0,  -- 40: InitCoroutine
  vdbeOpenEphemeral 6 3 0 "k(1,B)" 0,  -- 41: OpenEphemeral
  vdbeOpenRead 2 4 0 "2" 0,  -- 42: OpenRead
  vdbeOpenRead 7 5 0 "k(2,,)" 2,  -- 43: OpenRead
  vdbeInteger 3 18 0 "" 0,  -- 44: Integer
  vdbeSeekGE 7 66 18 "1" 0,  -- 45: SeekGE
  vdbeIdxGT 7 66 18 "1" 0,  -- 46: IdxGT
  vdbeDeferredSeek 7 0 2 "" 0,  -- 47: DeferredSeek
  vdbeColumn 7 0 19 "" 0,  -- 48: Column
  vdbeColumn 2 1 20 "" 0,  -- 49: Column
  vdbeSequence 6 21 0 "" 0,  -- 50: Sequence
  vdbeColumn 7 0 22 "" 0,  -- 51: Column
  vdbeMakeRecord 20 3 24 "" 0,  -- 52: MakeRecord
  vdbeIfNot 21 59 0 "" 0,  -- 53: IfNot
  vdbeCompare 25 19 1 "k(2,B,B)" 0,  -- 54: Compare
  vdbeJump 56 60 56 "" 0,  -- 55: Jump
  vdbeGosub 26 68 0 "" 0,  -- 56: Gosub
  vdbeResetSorter 6 0 0 "" 0,  -- 57: ResetSorter
  vdbeIfNot 4 74 0 "" 0,  -- 58: IfNot
  vdbeMove 19 25 1 "" 0,  -- 59: Move
  vdbeIfNotZero 4 64 0 "" 0,  -- 60: IfNotZero
  vdbeLast 6 0 0 "" 0,  -- 61: Last
  vdbeIdxLE 6 65 20 "1" 0,  -- 62: IdxLE
  vdbeDelete 6 0 0 "" 0,  -- 63: Delete
  vdbeIdxInsert 6 24 20 "3" 0,  -- 64: IdxInsert
  vdbeNext 7 46 1 "" 0,  -- 65: Next
  vdbeGosub 26 68 0 "" 0,  -- 66: Gosub
  vdbeGoto 0 74 0 "" 0,  -- 67: Goto
  vdbeSort 6 74 0 "" 0,  -- 68: Sort
  vdbeColumn 6 0 23 "" 0,  -- 69: Column
  vdbeColumn 6 2 22 "" 0,  -- 70: Column
  vdbeYield 6 0 0 "" 0,  -- 71: Yield
  vdbeNext 6 69 0 "" 0,  -- 72: Next
  vdbeReturn 26 0 0 "" 0,  -- 73: Return
  vdbeEndCoroutine 6 0 0 "" 0,  -- 74: EndCoroutine
  vdbeMove 13 27 2 "" 0,  -- 75: Move
  vdbeYield 1 0 0 "" 0,  -- 76: Yield
  vdbeDecrJumpZero 2 100 0 "" 0,  -- 77: DecrJumpZero
  vdbeReturn 7 0 0 "" 0,  -- 78: Return
  vdbeMove 22 27 2 "" 0,  -- 79: Move
  vdbeYield 1 0 0 "" 0,  -- 80: Yield
  vdbeDecrJumpZero 2 100 0 "" 0,  -- 81: DecrJumpZero
  vdbeReturn 8 0 0 "" 0,  -- 82: Return
  vdbeGosub 8 79 0 "" 0,  -- 83: Gosub
  vdbeYield 6 100 0 "" 0,  -- 84: Yield
  vdbeGoto 0 83 0 "" 0,  -- 85: Goto
  vdbeGosub 7 75 0 "" 0,  -- 86: Gosub
  vdbeYield 5 100 0 "" 0,  -- 87: Yield
  vdbeGoto 0 86 0 "" 0,  -- 88: Goto
  vdbeGosub 7 75 0 "" 0,  -- 89: Gosub
  vdbeYield 5 83 0 "" 0,  -- 90: Yield
  vdbeGoto 0 97 0 "" 0,  -- 91: Goto
  vdbeGosub 8 79 0 "" 0,  -- 92: Gosub
  vdbeYield 6 86 0 "" 0,  -- 93: Yield
  vdbeGoto 0 97 0 "" 0,  -- 94: Goto
  vdbeYield 5 84 0 "" 0,  -- 95: Yield
  vdbeYield 6 86 0 "" 0,  -- 96: Yield
  vdbePermutation 0 0 0 "[0,1]" 0,  -- 97: Permutation
  vdbeCompare 13 22 2 "k(3,B,B,)" 1,  -- 98: Compare
  vdbeJump 89 89 92 "" 0,  -- 99: Jump
  vdbeEndCoroutine 1 0 0 "" 0,  -- 100: EndCoroutine
  vdbeOpenRead 0 3 0 "1" 0,  -- 101: OpenRead
  vdbeInitCoroutine 1 0 2 "" 0,  -- 102: InitCoroutine
  vdbeYield 1 111 0 "" 0,  -- 103: Yield
  vdbeRewind 0 111 0 "" 0,  -- 104: Rewind
  vdbeColumn 0 0 29 "" 0,  -- 105: Column
  vdbeCopy 27 30 0 "" 2,  -- 106: Copy
  vdbeCopy 28 31 0 "" 2,  -- 107: Copy
  vdbeResultRow 29 3 0 "" 0,  -- 108: ResultRow
  vdbeNext 0 105 0 "" 1,  -- 109: Next
  vdbeGoto 0 103 0 "" 0,  -- 110: Goto
  vdbeHalt 0 0 0 "" 0,  -- 111: Halt
  vdbeTransaction 0 0 25 "1" 1,  -- 112: Transaction
  vdbeGoto 0 1 0 "" 0  -- 113: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000145
