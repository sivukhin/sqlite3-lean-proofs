import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000149

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
  .init 0 59 0 0 0,  -- 0: Init
  .openRead 0 3 0 1 0,  -- 1: OpenRead
  .openRead 5 5 0 "k(2,,)" 0,  -- 2: OpenRead
  .rewind 0 58 0 0 0,  -- 3: Rewind
  .beginSubrtn 0 2 0 0 0,  -- 4: BeginSubrtn
  .null 0 3 3 0 0,  -- 5: Null
  .integer 1 4 0 0 0,  -- 6: Integer
  .openRead 3 4 0 1 0,  -- 7: OpenRead
  .null 0 6 0 0 0,  -- 8: Null
  .integer 28 5 0 0 0,  -- 9: Integer
  .reopenIdx 6 5 0 "k(2,,)" 0,  -- 10: ReopenIdx
  .column 0 0 8 0 0,  -- 11: Column
  .isNull 8 19 0 0 0,  -- 12: IsNull
  .seekGT 6 19 8 1 0,  -- 13: SeekGT
  .deferredSeek 6 0 3 "[1,0]" 0,  -- 14: DeferredSeek
  .idxRowid 6 7 0 0 0,  -- 15: IdxRowid
  .rowSetTest 6 18 7 0 0,  -- 16: RowSetTest
  .gosub 5 29 0 0 0,  -- 17: Gosub
  .next 6 14 0 0 0,  -- 18: Next
  .reopenIdx 6 5 0 "k(2,,)" 2,  -- 19: ReopenIdx
  .column 0 0 9 0 0,  -- 20: Column
  .isNull 9 28 0 0 0,  -- 21: IsNull
  .seekGE 6 28 9 1 0,  -- 22: SeekGE
  .idxGT 6 28 9 1 0,  -- 23: IdxGT
  .deferredSeek 6 0 3 "[1,0]" 0,  -- 24: DeferredSeek
  .idxRowid 6 7 0 0 0,  -- 25: IdxRowid
  .rowSetTest 6 28 7 1 0,  -- 26: RowSetTest
  .gosub 5 29 0 0 0,  -- 27: Gosub
  .goto 0 51 0 0 0,  -- 28: Goto
  .column 6 0 10 0 0,  -- 29: Column
  .column 0 0 11 0 0,  -- 30: Column
  .eq 11 48 10 "BINARY-8" 65,  -- 31: Eq
  .column 6 0 11 0 0,  -- 32: Column
  .isNull 11 50 0 0 0,  -- 33: IsNull
  .beginSubrtn 0 12 0 0 0,  -- 34: BeginSubrtn
  .null 0 13 13 0 0,  -- 35: Null
  .initCoroutine 14 40 37 0 0,  -- 36: InitCoroutine
  .null 0 15 0 0 0,  -- 37: Null
  .yield 14 0 0 0 0,  -- 38: Yield
  .endCoroutine 14 0 0 0 0,  -- 39: EndCoroutine
  .integer 1 16 0 0 0,  -- 40: Integer
  .initCoroutine 14 0 37 0 0,  -- 41: InitCoroutine
  .yield 14 46 0 0 0,  -- 42: Yield
  .column 6 0 13 0 0,  -- 43: Column
  .decrJumpZero 16 46 0 0 0,  -- 44: DecrJumpZero
  .goto 0 42 0 0 0,  -- 45: Goto
  .return 12 35 1 0 0,  -- 46: Return
  .ne 13 50 11 "BINARY-8" 81,  -- 47: Ne
  .integer 3 3 0 0 0,  -- 48: Integer
  .decrJumpZero 4 51 0 0 0,  -- 49: DecrJumpZero
  .return 5 29 0 0 0,  -- 50: Return
  .return 2 5 1 0 0,  -- 51: Return
  .ifNot 3 57 1 0 0,  -- 52: IfNot
  .rewind 5 57 17 0 0,  -- 53: Rewind
  .integer 1 17 0 0 0,  -- 54: Integer
  .resultRow 17 1 0 0 0,  -- 55: ResultRow
  .next 5 54 0 0 1,  -- 56: Next
  .next 0 4 0 0 1,  -- 57: Next
  .halt 0 0 0 0 0,  -- 58: Halt
  .transaction 0 0 33 1 1,  -- 59: Transaction
  .goto 0 1 0 0 0  -- 60: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000149
