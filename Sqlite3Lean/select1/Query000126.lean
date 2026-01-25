import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000126

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=3 db=0 mode=read name=

  Query: SELECT * FROM t3 UNION SELECT 3 AS 'a', 4 ORDER BY a;

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     59    0                    0   
  1     Integer        0     1     0                    0   
  2     InitCoroutine  4     19    3                    0   
  3     SorterOpen     1     5     0     k(2,B,B)       0   
  4     OpenRead       0     3     0     2              0   
  5     Rewind         0     11    0                    0   
  6     Column         0     0     8                    0   
  7     Column         0     1     9                    0   
  8     MakeRecord     8     2     12                   0   
  9     SorterInsert   1     12    8     2              0   
  10    Next           0     6     0                    1   
  11    OpenPseudo     2     13    5                    0   
  12    SorterSort     1     18    0                    0   
  13    SorterData     1     13    2                    0   
  14    Column         2     1     11                   0   
  15    Column         2     0     10                   0   
  16    Yield          4     0     0                    0   
  17    SorterNext     1     13    0                    0   
  18    EndCoroutine   4     0     0                    0   
  19    InitCoroutine  5     53    20                   0   
  20    Noop           3     5     0                    0   
  21    Integer        3     14    0                    0   
  22    Integer        4     15    0                    0   
  23    Yield          5     0     0                    0   
  24    EndCoroutine   5     0     0                    0   
  25    IfNot          1     28    0                    0   
  26    Compare        10    2     2     k(2,B,B)       0   
  27    Jump           28    31    28                   0   
  28    Copy           10    2     1                    0   
  29    Integer        1     1     0                    0   
  30    ResultRow      10    2     0                    0   
  31    Return         6     0     0                    0   
  32    IfNot          1     35    0                    0   
  33    Compare        14    2     2     k(2,B,B)       0   
  34    Jump           35    38    35                   0   
  35    Copy           14    2     1                    0   
  36    Integer        1     1     0                    0   
  37    ResultRow      14    2     0                    0   
  38    Return         7     0     0                    0   
  39    Gosub          7     32    0                    0   
  40    Yield          5     58    0                    0   
  41    Goto           0     39    0                    0   
  42    Gosub          6     25    0                    0   
  43    Yield          4     58    0                    0   
  44    Goto           0     42    0                    0   
  45    Gosub          6     25    0                    0   
  46    Yield          4     39    0                    0   
  47    Goto           0     55    0                    0   
  48    Yield          4     39    0                    0   
  49    Goto           0     55    0                    0   
  50    Gosub          7     32    0                    0   
  51    Yield          5     42    0                    0   
  52    Goto           0     55    0                    0   
  53    Yield          4     40    0                    0   
  54    Yield          5     42    0                    0   
  55    Permutation    0     0     0     [0,1]          0   
  56    Compare        10    14    2     k(3,B,B,)      1   
  57    Jump           45    48    50                   0   
  58    Halt           0     0     0                    0   
  59    Transaction    0     0     9     0              1   
  60    Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 59 0 0 0,  -- 0: Init
  .integer 0 1 0 0 0,  -- 1: Integer
  .initCoroutine 4 19 3 0 0,  -- 2: InitCoroutine
  .sorterOpen 1 5 0 "k(2,B,B)" 0,  -- 3: SorterOpen
  .openRead 0 3 0 2 0,  -- 4: OpenRead
  .rewind 0 11 0 0 0,  -- 5: Rewind
  .column 0 0 8 0 0,  -- 6: Column
  .column 0 1 9 0 0,  -- 7: Column
  .makeRecord 8 2 12 0 0,  -- 8: MakeRecord
  .sorterInsert 1 12 8 2 0,  -- 9: SorterInsert
  .next 0 6 0 0 1,  -- 10: Next
  .openPseudo 2 13 5 0 0,  -- 11: OpenPseudo
  .sorterSort 1 18 0 0 0,  -- 12: SorterSort
  .sorterData 1 13 2 0 0,  -- 13: SorterData
  .column 2 1 11 0 0,  -- 14: Column
  .column 2 0 10 0 0,  -- 15: Column
  .yield 4 0 0 0 0,  -- 16: Yield
  .sorterNext 1 13 0 0 0,  -- 17: SorterNext
  .endCoroutine 4 0 0 0 0,  -- 18: EndCoroutine
  .initCoroutine 5 53 20 0 0,  -- 19: InitCoroutine
  .noop 3 5 0 0 0,  -- 20: Noop
  .integer 3 14 0 0 0,  -- 21: Integer
  .integer 4 15 0 0 0,  -- 22: Integer
  .yield 5 0 0 0 0,  -- 23: Yield
  .endCoroutine 5 0 0 0 0,  -- 24: EndCoroutine
  .ifNot 1 28 0 0 0,  -- 25: IfNot
  .compare 10 2 2 "k(2,B,B)" 0,  -- 26: Compare
  .jump 28 31 28 0 0,  -- 27: Jump
  .copy 10 2 1 0 0,  -- 28: Copy
  .integer 1 1 0 0 0,  -- 29: Integer
  .resultRow 10 2 0 0 0,  -- 30: ResultRow
  .return 6 0 0 0 0,  -- 31: Return
  .ifNot 1 35 0 0 0,  -- 32: IfNot
  .compare 14 2 2 "k(2,B,B)" 0,  -- 33: Compare
  .jump 35 38 35 0 0,  -- 34: Jump
  .copy 14 2 1 0 0,  -- 35: Copy
  .integer 1 1 0 0 0,  -- 36: Integer
  .resultRow 14 2 0 0 0,  -- 37: ResultRow
  .return 7 0 0 0 0,  -- 38: Return
  .gosub 7 32 0 0 0,  -- 39: Gosub
  .yield 5 58 0 0 0,  -- 40: Yield
  .goto 0 39 0 0 0,  -- 41: Goto
  .gosub 6 25 0 0 0,  -- 42: Gosub
  .yield 4 58 0 0 0,  -- 43: Yield
  .goto 0 42 0 0 0,  -- 44: Goto
  .gosub 6 25 0 0 0,  -- 45: Gosub
  .yield 4 39 0 0 0,  -- 46: Yield
  .goto 0 55 0 0 0,  -- 47: Goto
  .yield 4 39 0 0 0,  -- 48: Yield
  .goto 0 55 0 0 0,  -- 49: Goto
  .gosub 7 32 0 0 0,  -- 50: Gosub
  .yield 5 42 0 0 0,  -- 51: Yield
  .goto 0 55 0 0 0,  -- 52: Goto
  .yield 4 40 0 0 0,  -- 53: Yield
  .yield 5 42 0 0 0,  -- 54: Yield
  .permutation 0 0 0 "[0,1]" 0,  -- 55: Permutation
  .compare 10 14 2 "k(3,B,B,)" 1,  -- 56: Compare
  .jump 45 48 50 0 0,  -- 57: Jump
  .halt 0 0 0 0 0,  -- 58: Halt
  .transaction 0 0 9 0 1,  -- 59: Transaction
  .goto 0 1 0 0 0  -- 60: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000126
