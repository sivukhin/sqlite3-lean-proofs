import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000151

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=
    cursor=1 rootpage=2 db=0 mode=read name=
    cursor=2 rootpage=2 db=0 mode=read name=
    cursor=5 rootpage=3 db=0 mode=read name=
    cursor=2 rootpage=2 db=0 mode=read name=
    cursor=7 rootpage=3 db=0 mode=read name=

  Query: SELECT * FROM t1 JOIN t1 USING(a,b)
     WHERE ((SELECT t1.a FROM t1 AS x GROUP BY b) AND b=0)
        OR a = 10;

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     105   0                    0   
  1     OpenRead       0     2     0     1              0   
  2     OpenRead       1     2     0     1              0   
  3     Null           0     2     0                    0   
  4     Integer        52    1     0                    0   
  5     ReopenIdx      3     3     0     k(2,,)         2   
  6     Integer        0     4     0                    0   
  7     SeekGE         3     47    4     1              0   
  8     IdxGT          3     47    4     1              0   
  9     DeferredSeek   3     0     0     [0,1]          0   
  10    BeginSubrtn    0     6     0                    0   
  11    Null           0     7     7                    0   
  12    Integer        1     8     0                    0   
  13    Noop           4     1     0                    0   
  14    Integer        0     10    0                    0   
  15    Null           0     13    13                   0   
  16    Gosub          12    40    0                    0   
  17    OpenRead       2     2     0     1              0   
  18    OpenRead       5     3     0     k(2,,)         0   
  19    Rewind         5     31    15    0              0   
  20    DeferredSeek   5     0     2                    0   
  21    IfNullRow      5     23    14                   0   
  22    String8        0     14    0     Y              0   
  23    Compare        13    14    1     k(1,B)         0   
  24    Jump           25    29    25                   0   
  25    Gosub          11    35    0                    0   
  26    Move           14    13    1                    0   
  27    IfPos          10    42    0                    0   
  28    Gosub          12    40    0                    0   
  29    Integer        1     9     0                    0   
  30    Next           5     20    0                    1   
  31    Gosub          11    35    0                    0   
  32    Goto           0     42    0                    0   
  33    Integer        1     10    0                    0   
  34    Return         11    0     0                    0   
  35    IfPos          9     37    0                    0   
  36    Return         11    0     0                    0   
  37    IdxRowid       3     7     0                    0   
  38    DecrJumpZero   8     33    0                    0   
  39    Return         11    0     0                    0   
  40    Integer        0     9     0                    0   
  41    Return         12    0     0                    0   
  42    Return         6     11    1                    0   
  43    IfNot          7     47    1                    0   
  44    IdxRowid       3     3     0                    0   
  45    RowSetTest     2     47    3     0              0   
  46    Gosub          1     53    0                    0   
  47    Integer        10    15    0                    0   
  48    SeekRowid      0     52    15                   0   
  49    Rowid          0     3     0                    0   
  50    RowSetTest     2     52    3     -1             0   
  51    Gosub          1     53    0                    0   
  52    Goto           0     104   0                    0   
  53    Rowid          0     5     0                    0   
  54    Eq             16    92    5                    68  
  55    IfNullRow      0     57    5                    0   
  56    String8        0     5     0     Y              0   
  57    Ne             17    103   5     BINARY-8       81  
  58    BeginSubrtn    0     18    0                    0   
  59    Null           0     19    19                   0   
  60    Integer        1     20    0                    0   
  61    Noop           6     1     0                    0   
  62    Integer        0     22    0                    0   
  63    Null           0     25    25                   0   
  64    Gosub          24    88    0                    0   
  65    OpenRead       2     2     0     1              0   
  66    OpenRead       7     3     0     k(2,,)         0   
  67    Rewind         7     79    27    0              0   
  68    DeferredSeek   7     0     2                    0   
  69    IfNullRow      7     71    26                   0   
  70    String8        0     26    0     Y              0   
  71    Compare        25    26    1     k(1,B)         0   
  72    Jump           73    77    73                   0   
  73    Gosub          23    83    0                    0   
  74    Move           26    25    1                    0   
  75    IfPos          22    90    0                    0   
  76    Gosub          24    88    0                    0   
  77    Integer        1     21    0                    0   
  78    Next           7     68    0                    1   
  79    Gosub          23    83    0                    0   
  80    Goto           0     90    0                    0   
  81    Integer        1     22    0                    0   
  82    Return         23    0     0                    0   
  83    IfPos          21    85    0                    0   
  84    Return         23    0     0                    0   
  85    Rowid          0     19    0                    0   
  86    DecrJumpZero   20    81    0                    0   
  87    Return         23    0     0                    0   
  88    Integer        0     21    0                    0   
  89    Return         24    0     0                    0   
  90    Return         18    59    1                    0   
  91    IfNot          19    103   1                    0   
  92    Rowid          0     27    0                    0   
  93    SeekRowid      1     103   27                   0   
  94    IfNullRow      0     96    5                    0   
  95    String8        0     5     0     Y              0   
  96    IfNullRow      1     98    28                   0   
  97    String8        0     28    0     Y              0   
  98    Ne             28    103   5     BINARY-8       81  
  99    Rowid          0     29    0                    0   
  100   IfNullRow      0     102   30                   0   
  101   String8        0     30    0     Y              0   
  102   ResultRow      29    2     0                    0   
  103   Return         1     53    0                    0   
  104   Halt           0     0     0                    0   
  105   Transaction    0     0     1     0              1   
  106   Integer        10    16    0                    0   
  107   Integer        0     17    0                    0   
  108   Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 105 0 "" 0,  -- 0: Init
  vdbeOpenRead 0 2 0 "1" 0,  -- 1: OpenRead
  vdbeOpenRead 1 2 0 "1" 0,  -- 2: OpenRead
  vdbeNull 0 2 0 "" 0,  -- 3: Null
  vdbeInteger 52 1 0 "" 0,  -- 4: Integer
  vdbeReopenIdx 3 3 0 "k(2,,)" 2,  -- 5: ReopenIdx
  vdbeInteger 0 4 0 "" 0,  -- 6: Integer
  vdbeSeekGE 3 47 4 "1" 0,  -- 7: SeekGE
  vdbeIdxGT 3 47 4 "1" 0,  -- 8: IdxGT
  vdbeDeferredSeek 3 0 0 "[0,1]" 0,  -- 9: DeferredSeek
  vdbeBeginSubrtn 0 6 0 "" 0,  -- 10: BeginSubrtn
  vdbeNull 0 7 7 "" 0,  -- 11: Null
  vdbeInteger 1 8 0 "" 0,  -- 12: Integer
  vdbeNoop 4 1 0 "" 0,  -- 13: Noop
  vdbeInteger 0 10 0 "" 0,  -- 14: Integer
  vdbeNull 0 13 13 "" 0,  -- 15: Null
  vdbeGosub 12 40 0 "" 0,  -- 16: Gosub
  vdbeOpenRead 2 2 0 "1" 0,  -- 17: OpenRead
  vdbeOpenRead 5 3 0 "k(2,,)" 0,  -- 18: OpenRead
  vdbeRewind 5 31 15 "0" 0,  -- 19: Rewind
  vdbeDeferredSeek 5 0 2 "" 0,  -- 20: DeferredSeek
  vdbeIfNullRow 5 23 14 "" 0,  -- 21: IfNullRow
  vdbeString8 0 14 0 "Y" 0,  -- 22: String8
  vdbeCompare 13 14 1 "k(1,B)" 0,  -- 23: Compare
  vdbeJump 25 29 25 "" 0,  -- 24: Jump
  vdbeGosub 11 35 0 "" 0,  -- 25: Gosub
  vdbeMove 14 13 1 "" 0,  -- 26: Move
  vdbeIfPos 10 42 0 "" 0,  -- 27: IfPos
  vdbeGosub 12 40 0 "" 0,  -- 28: Gosub
  vdbeInteger 1 9 0 "" 0,  -- 29: Integer
  vdbeNext 5 20 0 "" 1,  -- 30: Next
  vdbeGosub 11 35 0 "" 0,  -- 31: Gosub
  vdbeGoto 0 42 0 "" 0,  -- 32: Goto
  vdbeInteger 1 10 0 "" 0,  -- 33: Integer
  vdbeReturn 11 0 0 "" 0,  -- 34: Return
  vdbeIfPos 9 37 0 "" 0,  -- 35: IfPos
  vdbeReturn 11 0 0 "" 0,  -- 36: Return
  vdbeIdxRowid 3 7 0 "" 0,  -- 37: IdxRowid
  vdbeDecrJumpZero 8 33 0 "" 0,  -- 38: DecrJumpZero
  vdbeReturn 11 0 0 "" 0,  -- 39: Return
  vdbeInteger 0 9 0 "" 0,  -- 40: Integer
  vdbeReturn 12 0 0 "" 0,  -- 41: Return
  vdbeReturn 6 11 1 "" 0,  -- 42: Return
  vdbeIfNot 7 47 1 "" 0,  -- 43: IfNot
  vdbeIdxRowid 3 3 0 "" 0,  -- 44: IdxRowid
  vdbeRowSetTest 2 47 3 "0" 0,  -- 45: RowSetTest
  vdbeGosub 1 53 0 "" 0,  -- 46: Gosub
  vdbeInteger 10 15 0 "" 0,  -- 47: Integer
  vdbeSeekRowid 0 52 15 "" 0,  -- 48: SeekRowid
  vdbeRowid 0 3 0 "" 0,  -- 49: Rowid
  vdbeRowSetTest 2 52 3 "-1" 0,  -- 50: RowSetTest
  vdbeGosub 1 53 0 "" 0,  -- 51: Gosub
  vdbeGoto 0 104 0 "" 0,  -- 52: Goto
  vdbeRowid 0 5 0 "" 0,  -- 53: Rowid
  vdbeEq 16 92 5 "" 68,  -- 54: Eq
  vdbeIfNullRow 0 57 5 "" 0,  -- 55: IfNullRow
  vdbeString8 0 5 0 "Y" 0,  -- 56: String8
  vdbeNe 17 103 5 "BINARY-8" 81,  -- 57: Ne
  vdbeBeginSubrtn 0 18 0 "" 0,  -- 58: BeginSubrtn
  vdbeNull 0 19 19 "" 0,  -- 59: Null
  vdbeInteger 1 20 0 "" 0,  -- 60: Integer
  vdbeNoop 6 1 0 "" 0,  -- 61: Noop
  vdbeInteger 0 22 0 "" 0,  -- 62: Integer
  vdbeNull 0 25 25 "" 0,  -- 63: Null
  vdbeGosub 24 88 0 "" 0,  -- 64: Gosub
  vdbeOpenRead 2 2 0 "1" 0,  -- 65: OpenRead
  vdbeOpenRead 7 3 0 "k(2,,)" 0,  -- 66: OpenRead
  vdbeRewind 7 79 27 "0" 0,  -- 67: Rewind
  vdbeDeferredSeek 7 0 2 "" 0,  -- 68: DeferredSeek
  vdbeIfNullRow 7 71 26 "" 0,  -- 69: IfNullRow
  vdbeString8 0 26 0 "Y" 0,  -- 70: String8
  vdbeCompare 25 26 1 "k(1,B)" 0,  -- 71: Compare
  vdbeJump 73 77 73 "" 0,  -- 72: Jump
  vdbeGosub 23 83 0 "" 0,  -- 73: Gosub
  vdbeMove 26 25 1 "" 0,  -- 74: Move
  vdbeIfPos 22 90 0 "" 0,  -- 75: IfPos
  vdbeGosub 24 88 0 "" 0,  -- 76: Gosub
  vdbeInteger 1 21 0 "" 0,  -- 77: Integer
  vdbeNext 7 68 0 "" 1,  -- 78: Next
  vdbeGosub 23 83 0 "" 0,  -- 79: Gosub
  vdbeGoto 0 90 0 "" 0,  -- 80: Goto
  vdbeInteger 1 22 0 "" 0,  -- 81: Integer
  vdbeReturn 23 0 0 "" 0,  -- 82: Return
  vdbeIfPos 21 85 0 "" 0,  -- 83: IfPos
  vdbeReturn 23 0 0 "" 0,  -- 84: Return
  vdbeRowid 0 19 0 "" 0,  -- 85: Rowid
  vdbeDecrJumpZero 20 81 0 "" 0,  -- 86: DecrJumpZero
  vdbeReturn 23 0 0 "" 0,  -- 87: Return
  vdbeInteger 0 21 0 "" 0,  -- 88: Integer
  vdbeReturn 24 0 0 "" 0,  -- 89: Return
  vdbeReturn 18 59 1 "" 0,  -- 90: Return
  vdbeIfNot 19 103 1 "" 0,  -- 91: IfNot
  vdbeRowid 0 27 0 "" 0,  -- 92: Rowid
  vdbeSeekRowid 1 103 27 "" 0,  -- 93: SeekRowid
  vdbeIfNullRow 0 96 5 "" 0,  -- 94: IfNullRow
  vdbeString8 0 5 0 "Y" 0,  -- 95: String8
  vdbeIfNullRow 1 98 28 "" 0,  -- 96: IfNullRow
  vdbeString8 0 28 0 "Y" 0,  -- 97: String8
  vdbeNe 28 103 5 "BINARY-8" 81,  -- 98: Ne
  vdbeRowid 0 29 0 "" 0,  -- 99: Rowid
  vdbeIfNullRow 0 102 30 "" 0,  -- 100: IfNullRow
  vdbeString8 0 30 0 "Y" 0,  -- 101: String8
  vdbeResultRow 29 2 0 "" 0,  -- 102: ResultRow
  vdbeReturn 1 53 0 "" 0,  -- 103: Return
  vdbeHalt 0 0 0 "" 0,  -- 104: Halt
  vdbeTransaction 0 0 1 "0" 1,  -- 105: Transaction
  vdbeInteger 10 16 0 "" 0,  -- 106: Integer
  vdbeInteger 0 17 0 "" 0,  -- 107: Integer
  vdbeGoto 0 1 0 "" 0  -- 108: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000151
