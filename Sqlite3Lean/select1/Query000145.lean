import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000145

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
  .init 0 112 0 0 0,  -- 0: Init
  .initCoroutine 1 101 2 0 0,  -- 1: InitCoroutine
  .integer 4 2 0 0 0,  -- 2: Integer
  .copy 2 3 0 0 0,  -- 3: Copy
  .copy 3 4 0 0 0,  -- 4: Copy
  .initCoroutine 5 40 6 0 0,  -- 5: InitCoroutine
  .openEphemeral 4 3 0 "k(1,B)" 0,  -- 6: OpenEphemeral
  .openRead 3 4 0 2 0,  -- 7: OpenRead
  .openRead 5 5 0 "k(2,,)" 2,  -- 8: OpenRead
  .integer 2 9 0 0 0,  -- 9: Integer
  .seekGE 5 31 9 1 0,  -- 10: SeekGE
  .idxGT 5 31 9 1 0,  -- 11: IdxGT
  .deferredSeek 5 0 3 0 0,  -- 12: DeferredSeek
  .column 5 0 10 0 0,  -- 13: Column
  .column 3 1 11 0 0,  -- 14: Column
  .sequence 4 12 0 0 0,  -- 15: Sequence
  .column 5 0 13 0 0,  -- 16: Column
  .makeRecord 11 3 15 0 0,  -- 17: MakeRecord
  .ifNot 12 24 0 0 0,  -- 18: IfNot
  .compare 16 10 1 "k(2,B,B)" 0,  -- 19: Compare
  .jump 21 25 21 0 0,  -- 20: Jump
  .gosub 17 33 0 0 0,  -- 21: Gosub
  .resetSorter 4 0 0 0 0,  -- 22: ResetSorter
  .ifNot 3 39 0 0 0,  -- 23: IfNot
  .move 10 16 1 0 0,  -- 24: Move
  .ifNotZero 3 29 0 0 0,  -- 25: IfNotZero
  .last 4 0 0 0 0,  -- 26: Last
  .idxLE 4 30 11 1 0,  -- 27: IdxLE
  .delete 4 0 0 0 0,  -- 28: Delete
  .idxInsert 4 15 11 3 0,  -- 29: IdxInsert
  .next 5 11 1 0 0,  -- 30: Next
  .gosub 17 33 0 0 0,  -- 31: Gosub
  .goto 0 39 0 0 0,  -- 32: Goto
  .sort 4 39 0 0 0,  -- 33: Sort
  .column 4 0 14 0 0,  -- 34: Column
  .column 4 2 13 0 0,  -- 35: Column
  .yield 5 0 0 0 0,  -- 36: Yield
  .next 4 34 0 0 0,  -- 37: Next
  .return 17 0 0 0 0,  -- 38: Return
  .endCoroutine 5 0 0 0 0,  -- 39: EndCoroutine
  .initCoroutine 6 95 41 0 0,  -- 40: InitCoroutine
  .openEphemeral 6 3 0 "k(1,B)" 0,  -- 41: OpenEphemeral
  .openRead 2 4 0 2 0,  -- 42: OpenRead
  .openRead 7 5 0 "k(2,,)" 2,  -- 43: OpenRead
  .integer 3 18 0 0 0,  -- 44: Integer
  .seekGE 7 66 18 1 0,  -- 45: SeekGE
  .idxGT 7 66 18 1 0,  -- 46: IdxGT
  .deferredSeek 7 0 2 0 0,  -- 47: DeferredSeek
  .column 7 0 19 0 0,  -- 48: Column
  .column 2 1 20 0 0,  -- 49: Column
  .sequence 6 21 0 0 0,  -- 50: Sequence
  .column 7 0 22 0 0,  -- 51: Column
  .makeRecord 20 3 24 0 0,  -- 52: MakeRecord
  .ifNot 21 59 0 0 0,  -- 53: IfNot
  .compare 25 19 1 "k(2,B,B)" 0,  -- 54: Compare
  .jump 56 60 56 0 0,  -- 55: Jump
  .gosub 26 68 0 0 0,  -- 56: Gosub
  .resetSorter 6 0 0 0 0,  -- 57: ResetSorter
  .ifNot 4 74 0 0 0,  -- 58: IfNot
  .move 19 25 1 0 0,  -- 59: Move
  .ifNotZero 4 64 0 0 0,  -- 60: IfNotZero
  .last 6 0 0 0 0,  -- 61: Last
  .idxLE 6 65 20 1 0,  -- 62: IdxLE
  .delete 6 0 0 0 0,  -- 63: Delete
  .idxInsert 6 24 20 3 0,  -- 64: IdxInsert
  .next 7 46 1 0 0,  -- 65: Next
  .gosub 26 68 0 0 0,  -- 66: Gosub
  .goto 0 74 0 0 0,  -- 67: Goto
  .sort 6 74 0 0 0,  -- 68: Sort
  .column 6 0 23 0 0,  -- 69: Column
  .column 6 2 22 0 0,  -- 70: Column
  .yield 6 0 0 0 0,  -- 71: Yield
  .next 6 69 0 0 0,  -- 72: Next
  .return 26 0 0 0 0,  -- 73: Return
  .endCoroutine 6 0 0 0 0,  -- 74: EndCoroutine
  .move 13 27 2 0 0,  -- 75: Move
  .yield 1 0 0 0 0,  -- 76: Yield
  .decrJumpZero 2 100 0 0 0,  -- 77: DecrJumpZero
  .return 7 0 0 0 0,  -- 78: Return
  .move 22 27 2 0 0,  -- 79: Move
  .yield 1 0 0 0 0,  -- 80: Yield
  .decrJumpZero 2 100 0 0 0,  -- 81: DecrJumpZero
  .return 8 0 0 0 0,  -- 82: Return
  .gosub 8 79 0 0 0,  -- 83: Gosub
  .yield 6 100 0 0 0,  -- 84: Yield
  .goto 0 83 0 0 0,  -- 85: Goto
  .gosub 7 75 0 0 0,  -- 86: Gosub
  .yield 5 100 0 0 0,  -- 87: Yield
  .goto 0 86 0 0 0,  -- 88: Goto
  .gosub 7 75 0 0 0,  -- 89: Gosub
  .yield 5 83 0 0 0,  -- 90: Yield
  .goto 0 97 0 0 0,  -- 91: Goto
  .gosub 8 79 0 0 0,  -- 92: Gosub
  .yield 6 86 0 0 0,  -- 93: Yield
  .goto 0 97 0 0 0,  -- 94: Goto
  .yield 5 84 0 0 0,  -- 95: Yield
  .yield 6 86 0 0 0,  -- 96: Yield
  .permutation 0 0 0 "[0,1]" 0,  -- 97: Permutation
  .compare 13 22 2 "k(3,B,B,)" 1,  -- 98: Compare
  .jump 89 89 92 0 0,  -- 99: Jump
  .endCoroutine 1 0 0 0 0,  -- 100: EndCoroutine
  .openRead 0 3 0 1 0,  -- 101: OpenRead
  .initCoroutine 1 0 2 0 0,  -- 102: InitCoroutine
  .yield 1 111 0 0 0,  -- 103: Yield
  .rewind 0 111 0 0 0,  -- 104: Rewind
  .column 0 0 29 0 0,  -- 105: Column
  .copy 27 30 0 0 2,  -- 106: Copy
  .copy 28 31 0 0 2,  -- 107: Copy
  .resultRow 29 3 0 0 0,  -- 108: ResultRow
  .next 0 105 0 0 1,  -- 109: Next
  .goto 0 103 0 0 0,  -- 110: Goto
  .halt 0 0 0 0 0,  -- 111: Halt
  .transaction 0 0 25 1 1,  -- 112: Transaction
  .goto 0 1 0 0 0  -- 113: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000145
