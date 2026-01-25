import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000148

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=3 db=0 mode=read name=
    cursor=5 rootpage=5 db=0 mode=read name=
    cursor=3 rootpage=4 db=0 mode=read name=

  Query: SELECT 1 FROM t1 WHERE (
      SELECT 2 FROM t2 WHERE (
        SELECT 3 FROM (
          SELECT x FROM t2 WHERE x=c OR x=(SELECT x FROM (VALUES(0)))
        ) WHERE x>c OR x=c
      )
    );

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     66    0                    0   
  1     OpenRead       0     3     0     1              0   
  2     Rewind         0     65    0                    0   
  3     BeginSubrtn    0     2     0                    0   
  4     Null           0     3     3                    0   
  5     Integer        1     4     0                    0   
  6     OpenRead       5     5     0     k(2,,)         0   
  7     Rewind         5     60    5     0              0   
  8     BeginSubrtn    0     6     0                    0   
  9     Null           0     7     7                    0   
  10    Integer        1     8     0                    0   
  11    OpenRead       3     4     0     1              0   
  12    Null           0     10    0                    0   
  13    Integer        32    9     0                    0   
  14    ReopenIdx      6     5     0     k(2,,)         0   
  15    Column         0     0     12                   0   
  16    IsNull         12    23    0                    0   
  17    SeekGT         6     23    12    1              0   
  18    DeferredSeek   6     0     3     [1,0]          0   
  19    IdxRowid       6     11    0                    0   
  20    RowSetTest     10    22    11    0              0   
  21    Gosub          9     33    0                    0   
  22    Next           6     18    0                    0   
  23    ReopenIdx      6     5     0     k(2,,)         2   
  24    Column         0     0     13                   0   
  25    IsNull         13    32    0                    0   
  26    SeekGE         6     32    13    1              0   
  27    IdxGT          6     32    13    1              0   
  28    DeferredSeek   6     0     3     [1,0]          0   
  29    IdxRowid       6     11    0                    0   
  30    RowSetTest     10    32    11    1              0   
  31    Gosub          9     33    0                    0   
  32    Goto           0     55    0                    0   
  33    Column         6     0     14                   0   
  34    Column         0     0     15                   0   
  35    Eq             15    52    14    BINARY-8       65  
  36    Column         6     0     15                   0   
  37    IsNull         15    54    0                    0   
  38    BeginSubrtn    0     16    0                    0   
  39    Null           0     17    17                   0   
  40    InitCoroutine  18    44    41                   0   
  41    Null           0     19    0                    0   
  42    Yield          18    0     0                    0   
  43    EndCoroutine   18    0     0                    0   
  44    Integer        1     20    0                    0   
  45    InitCoroutine  18    0     41                   0   
  46    Yield          18    50    0                    0   
  47    Column         6     0     17                   0   
  48    DecrJumpZero   20    50    0                    0   
  49    Goto           0     46    0                    0   
  50    Return         16    39    1                    0   
  51    Ne             17    54    15    BINARY-8       81  
  52    Integer        3     7     0                    0   
  53    DecrJumpZero   8     55    0                    0   
  54    Return         9     33    0                    0   
  55    Return         6     9     1                    0   
  56    IfNot          7     59    1                    0   
  57    Integer        2     3     0                    0   
  58    DecrJumpZero   4     60    0                    0   
  59    Next           5     8     0                    1   
  60    Return         2     4     1                    0   
  61    IfNot          3     64    1                    0   
  62    Integer        1     21    0                    0   
  63    ResultRow      21    1     0                    0   
  64    Next           0     3     0                    1   
  65    Halt           0     0     0                    0   
  66    Transaction    0     0     33    1              1   
  67    Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 66 0 "" 0,  -- 0: Init
  vdbeOpenRead 0 3 0 "1" 0,  -- 1: OpenRead
  vdbeRewind 0 65 0 "" 0,  -- 2: Rewind
  vdbeBeginSubrtn 0 2 0 "" 0,  -- 3: BeginSubrtn
  vdbeNull 0 3 3 "" 0,  -- 4: Null
  vdbeInteger 1 4 0 "" 0,  -- 5: Integer
  vdbeOpenRead 5 5 0 "k(2,,)" 0,  -- 6: OpenRead
  vdbeRewind 5 60 5 "0" 0,  -- 7: Rewind
  vdbeBeginSubrtn 0 6 0 "" 0,  -- 8: BeginSubrtn
  vdbeNull 0 7 7 "" 0,  -- 9: Null
  vdbeInteger 1 8 0 "" 0,  -- 10: Integer
  vdbeOpenRead 3 4 0 "1" 0,  -- 11: OpenRead
  vdbeNull 0 10 0 "" 0,  -- 12: Null
  vdbeInteger 32 9 0 "" 0,  -- 13: Integer
  vdbeReopenIdx 6 5 0 "k(2,,)" 0,  -- 14: ReopenIdx
  vdbeColumn 0 0 12 "" 0,  -- 15: Column
  vdbeIsNull 12 23 0 "" 0,  -- 16: IsNull
  vdbeSeekGT 6 23 12 "1" 0,  -- 17: SeekGT
  vdbeDeferredSeek 6 0 3 "[1,0]" 0,  -- 18: DeferredSeek
  vdbeIdxRowid 6 11 0 "" 0,  -- 19: IdxRowid
  vdbeRowSetTest 10 22 11 "0" 0,  -- 20: RowSetTest
  vdbeGosub 9 33 0 "" 0,  -- 21: Gosub
  vdbeNext 6 18 0 "" 0,  -- 22: Next
  vdbeReopenIdx 6 5 0 "k(2,,)" 2,  -- 23: ReopenIdx
  vdbeColumn 0 0 13 "" 0,  -- 24: Column
  vdbeIsNull 13 32 0 "" 0,  -- 25: IsNull
  vdbeSeekGE 6 32 13 "1" 0,  -- 26: SeekGE
  vdbeIdxGT 6 32 13 "1" 0,  -- 27: IdxGT
  vdbeDeferredSeek 6 0 3 "[1,0]" 0,  -- 28: DeferredSeek
  vdbeIdxRowid 6 11 0 "" 0,  -- 29: IdxRowid
  vdbeRowSetTest 10 32 11 "1" 0,  -- 30: RowSetTest
  vdbeGosub 9 33 0 "" 0,  -- 31: Gosub
  vdbeGoto 0 55 0 "" 0,  -- 32: Goto
  vdbeColumn 6 0 14 "" 0,  -- 33: Column
  vdbeColumn 0 0 15 "" 0,  -- 34: Column
  vdbeEq 15 52 14 "BINARY-8" 65,  -- 35: Eq
  vdbeColumn 6 0 15 "" 0,  -- 36: Column
  vdbeIsNull 15 54 0 "" 0,  -- 37: IsNull
  vdbeBeginSubrtn 0 16 0 "" 0,  -- 38: BeginSubrtn
  vdbeNull 0 17 17 "" 0,  -- 39: Null
  vdbeInitCoroutine 18 44 41 "" 0,  -- 40: InitCoroutine
  vdbeNull 0 19 0 "" 0,  -- 41: Null
  vdbeYield 18 0 0 "" 0,  -- 42: Yield
  vdbeEndCoroutine 18 0 0 "" 0,  -- 43: EndCoroutine
  vdbeInteger 1 20 0 "" 0,  -- 44: Integer
  vdbeInitCoroutine 18 0 41 "" 0,  -- 45: InitCoroutine
  vdbeYield 18 50 0 "" 0,  -- 46: Yield
  vdbeColumn 6 0 17 "" 0,  -- 47: Column
  vdbeDecrJumpZero 20 50 0 "" 0,  -- 48: DecrJumpZero
  vdbeGoto 0 46 0 "" 0,  -- 49: Goto
  vdbeReturn 16 39 1 "" 0,  -- 50: Return
  vdbeNe 17 54 15 "BINARY-8" 81,  -- 51: Ne
  vdbeInteger 3 7 0 "" 0,  -- 52: Integer
  vdbeDecrJumpZero 8 55 0 "" 0,  -- 53: DecrJumpZero
  vdbeReturn 9 33 0 "" 0,  -- 54: Return
  vdbeReturn 6 9 1 "" 0,  -- 55: Return
  vdbeIfNot 7 59 1 "" 0,  -- 56: IfNot
  vdbeInteger 2 3 0 "" 0,  -- 57: Integer
  vdbeDecrJumpZero 4 60 0 "" 0,  -- 58: DecrJumpZero
  vdbeNext 5 8 0 "" 1,  -- 59: Next
  vdbeReturn 2 4 1 "" 0,  -- 60: Return
  vdbeIfNot 3 64 1 "" 0,  -- 61: IfNot
  vdbeInteger 1 21 0 "" 0,  -- 62: Integer
  vdbeResultRow 21 1 0 "" 0,  -- 63: ResultRow
  vdbeNext 0 3 0 "" 1,  -- 64: Next
  vdbeHalt 0 0 0 "" 0,  -- 65: Halt
  vdbeTransaction 0 0 33 "1" 1,  -- 66: Transaction
  vdbeGoto 0 1 0 "" 0  -- 67: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000148
