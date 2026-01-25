import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000149

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=3 db=0 mode=read name=
    cursor=5 rootpage=5 db=0 mode=read name=
    cursor=3 rootpage=4 db=0 mode=read name=

  Query: SELECT 1 FROM t1, t2 WHERE (
      SELECT 3 FROM (
        SELECT x FROM t2 WHERE x=c OR x=(SELECT x FROM (VALUES(0)))
      ) WHERE x>c OR x=c
    );

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     59    0                    0   
  1     OpenRead       0     3     0     1              0   
  2     OpenRead       5     5     0     k(2,,)         0   
  3     Rewind         0     58    0                    0   
  4     BeginSubrtn    0     2     0                    0   
  5     Null           0     3     3                    0   
  6     Integer        1     4     0                    0   
  7     OpenRead       3     4     0     1              0   
  8     Null           0     6     0                    0   
  9     Integer        28    5     0                    0   
  10    ReopenIdx      6     5     0     k(2,,)         0   
  11    Column         0     0     8                    0   
  12    IsNull         8     19    0                    0   
  13    SeekGT         6     19    8     1              0   
  14    DeferredSeek   6     0     3     [1,0]          0   
  15    IdxRowid       6     7     0                    0   
  16    RowSetTest     6     18    7     0              0   
  17    Gosub          5     29    0                    0   
  18    Next           6     14    0                    0   
  19    ReopenIdx      6     5     0     k(2,,)         2   
  20    Column         0     0     9                    0   
  21    IsNull         9     28    0                    0   
  22    SeekGE         6     28    9     1              0   
  23    IdxGT          6     28    9     1              0   
  24    DeferredSeek   6     0     3     [1,0]          0   
  25    IdxRowid       6     7     0                    0   
  26    RowSetTest     6     28    7     1              0   
  27    Gosub          5     29    0                    0   
  28    Goto           0     51    0                    0   
  29    Column         6     0     10                   0   
  30    Column         0     0     11                   0   
  31    Eq             11    48    10    BINARY-8       65  
  32    Column         6     0     11                   0   
  33    IsNull         11    50    0                    0   
  34    BeginSubrtn    0     12    0                    0   
  35    Null           0     13    13                   0   
  36    InitCoroutine  14    40    37                   0   
  37    Null           0     15    0                    0   
  38    Yield          14    0     0                    0   
  39    EndCoroutine   14    0     0                    0   
  40    Integer        1     16    0                    0   
  41    InitCoroutine  14    0     37                   0   
  42    Yield          14    46    0                    0   
  43    Column         6     0     13                   0   
  44    DecrJumpZero   16    46    0                    0   
  45    Goto           0     42    0                    0   
  46    Return         12    35    1                    0   
  47    Ne             13    50    11    BINARY-8       81  
  48    Integer        3     3     0                    0   
  49    DecrJumpZero   4     51    0                    0   
  50    Return         5     29    0                    0   
  51    Return         2     5     1                    0   
  52    IfNot          3     57    1                    0   
  53    Rewind         5     57    17    0              0   
  54    Integer        1     17    0                    0   
  55    ResultRow      17    1     0                    0   
  56    Next           5     54    0                    1   
  57    Next           0     4     0                    1   
  58    Halt           0     0     0                    0   
  59    Transaction    0     0     33    1              1   
  60    Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 59 0 "" 0,  -- 0: Init
  vdbeOpenRead 0 3 0 "1" 0,  -- 1: OpenRead
  vdbeOpenRead 5 5 0 "k(2,,)" 0,  -- 2: OpenRead
  vdbeRewind 0 58 0 "" 0,  -- 3: Rewind
  vdbeBeginSubrtn 0 2 0 "" 0,  -- 4: BeginSubrtn
  vdbeNull 0 3 3 "" 0,  -- 5: Null
  vdbeInteger 1 4 0 "" 0,  -- 6: Integer
  vdbeOpenRead 3 4 0 "1" 0,  -- 7: OpenRead
  vdbeNull 0 6 0 "" 0,  -- 8: Null
  vdbeInteger 28 5 0 "" 0,  -- 9: Integer
  vdbeReopenIdx 6 5 0 "k(2,,)" 0,  -- 10: ReopenIdx
  vdbeColumn 0 0 8 "" 0,  -- 11: Column
  vdbeIsNull 8 19 0 "" 0,  -- 12: IsNull
  vdbeSeekGT 6 19 8 "1" 0,  -- 13: SeekGT
  vdbeDeferredSeek 6 0 3 "[1,0]" 0,  -- 14: DeferredSeek
  vdbeIdxRowid 6 7 0 "" 0,  -- 15: IdxRowid
  vdbeRowSetTest 6 18 7 "0" 0,  -- 16: RowSetTest
  vdbeGosub 5 29 0 "" 0,  -- 17: Gosub
  vdbeNext 6 14 0 "" 0,  -- 18: Next
  vdbeReopenIdx 6 5 0 "k(2,,)" 2,  -- 19: ReopenIdx
  vdbeColumn 0 0 9 "" 0,  -- 20: Column
  vdbeIsNull 9 28 0 "" 0,  -- 21: IsNull
  vdbeSeekGE 6 28 9 "1" 0,  -- 22: SeekGE
  vdbeIdxGT 6 28 9 "1" 0,  -- 23: IdxGT
  vdbeDeferredSeek 6 0 3 "[1,0]" 0,  -- 24: DeferredSeek
  vdbeIdxRowid 6 7 0 "" 0,  -- 25: IdxRowid
  vdbeRowSetTest 6 28 7 "1" 0,  -- 26: RowSetTest
  vdbeGosub 5 29 0 "" 0,  -- 27: Gosub
  vdbeGoto 0 51 0 "" 0,  -- 28: Goto
  vdbeColumn 6 0 10 "" 0,  -- 29: Column
  vdbeColumn 0 0 11 "" 0,  -- 30: Column
  vdbeEq 11 48 10 "BINARY-8" 65,  -- 31: Eq
  vdbeColumn 6 0 11 "" 0,  -- 32: Column
  vdbeIsNull 11 50 0 "" 0,  -- 33: IsNull
  vdbeBeginSubrtn 0 12 0 "" 0,  -- 34: BeginSubrtn
  vdbeNull 0 13 13 "" 0,  -- 35: Null
  vdbeInitCoroutine 14 40 37 "" 0,  -- 36: InitCoroutine
  vdbeNull 0 15 0 "" 0,  -- 37: Null
  vdbeYield 14 0 0 "" 0,  -- 38: Yield
  vdbeEndCoroutine 14 0 0 "" 0,  -- 39: EndCoroutine
  vdbeInteger 1 16 0 "" 0,  -- 40: Integer
  vdbeInitCoroutine 14 0 37 "" 0,  -- 41: InitCoroutine
  vdbeYield 14 46 0 "" 0,  -- 42: Yield
  vdbeColumn 6 0 13 "" 0,  -- 43: Column
  vdbeDecrJumpZero 16 46 0 "" 0,  -- 44: DecrJumpZero
  vdbeGoto 0 42 0 "" 0,  -- 45: Goto
  vdbeReturn 12 35 1 "" 0,  -- 46: Return
  vdbeNe 13 50 11 "BINARY-8" 81,  -- 47: Ne
  vdbeInteger 3 3 0 "" 0,  -- 48: Integer
  vdbeDecrJumpZero 4 51 0 "" 0,  -- 49: DecrJumpZero
  vdbeReturn 5 29 0 "" 0,  -- 50: Return
  vdbeReturn 2 5 1 "" 0,  -- 51: Return
  vdbeIfNot 3 57 1 "" 0,  -- 52: IfNot
  vdbeRewind 5 57 17 "0" 0,  -- 53: Rewind
  vdbeInteger 1 17 0 "" 0,  -- 54: Integer
  vdbeResultRow 17 1 0 "" 0,  -- 55: ResultRow
  vdbeNext 5 54 0 "" 1,  -- 56: Next
  vdbeNext 0 4 0 "" 1,  -- 57: Next
  vdbeHalt 0 0 0 "" 0,  -- 58: Halt
  vdbeTransaction 0 0 33 "1" 1,  -- 59: Transaction
  vdbeGoto 0 1 0 "" 0  -- 60: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000149
