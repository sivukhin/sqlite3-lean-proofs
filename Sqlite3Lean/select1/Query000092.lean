import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000092

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=1 rootpage=2 db=0 mode=read name=
    cursor=0 rootpage=2 db=0 mode=read name=

  Query: SELECT f1 FROM test1 UNION SELECT f2 FROM test1
      ORDER BY f2;

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     66    0                    0   
  1     Integer        0     1     0                    0   
  2     InitCoroutine  3     17    3                    0   
  3     SorterOpen     2     3     0     k(1,B)         0   
  4     OpenRead       1     2     0     2              0   
  5     Rewind         1     10    0                    0   
  6     Column         1     0     7                    0   
  7     MakeRecord     7     1     9                    0   
  8     SorterInsert   2     9     7     1              0   
  9     Next           1     6     0                    1   
  10    OpenPseudo     3     10    3                    0   
  11    SorterSort     2     16    0                    0   
  12    SorterData     2     10    3                    0   
  13    Column         3     0     8                    0   
  14    Yield          3     0     0                    0   
  15    SorterNext     2     12    0                    0   
  16    EndCoroutine   3     0     0                    0   
  17    InitCoroutine  4     60    18                   0   
  18    SorterOpen     4     3     0     k(1,B)         0   
  19    OpenRead       0     2     0     2              0   
  20    Rewind         0     25    0                    0   
  21    Column         0     1     11                   0   
  22    MakeRecord     11    1     13                   0   
  23    SorterInsert   4     13    11    1              0   
  24    Next           0     21    0                    1   
  25    OpenPseudo     5     14    3                    0   
  26    SorterSort     4     31    0                    0   
  27    SorterData     4     14    5                    0   
  28    Column         5     0     12                   0   
  29    Yield          4     0     0                    0   
  30    SorterNext     4     27    0                    0   
  31    EndCoroutine   4     0     0                    0   
  32    IfNot          1     35    0                    0   
  33    Compare        8     2     1     k(1,B)         0   
  34    Jump           35    38    35                   0   
  35    Copy           8     2     0                    0   
  36    Integer        1     1     0                    0   
  37    ResultRow      8     1     0                    0   
  38    Return         5     0     0                    0   
  39    IfNot          1     42    0                    0   
  40    Compare        12    2     1     k(1,B)         0   
  41    Jump           42    45    42                   0   
  42    Copy           12    2     0                    0   
  43    Integer        1     1     0                    0   
  44    ResultRow      12    1     0                    0   
  45    Return         6     0     0                    0   
  46    Gosub          6     39    0                    0   
  47    Yield          4     65    0                    0   
  48    Goto           0     46    0                    0   
  49    Gosub          5     32    0                    0   
  50    Yield          3     65    0                    0   
  51    Goto           0     49    0                    0   
  52    Gosub          5     32    0                    0   
  53    Yield          3     46    0                    0   
  54    Goto           0     62    0                    0   
  55    Yield          3     46    0                    0   
  56    Goto           0     62    0                    0   
  57    Gosub          6     39    0                    0   
  58    Yield          4     49    0                    0   
  59    Goto           0     62    0                    0   
  60    Yield          3     47    0                    0   
  61    Yield          4     49    0                    0   
  62    Permutation    0     0     0     [0]            0   
  63    Compare        8     12    1     k(2,B,)        1   
  64    Jump           52    55    57                   0   
  65    Halt           0     0     0                    0   
  66    Transaction    0     0     8     0              1   
  67    Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 66 0 0 0,  -- 0: Init
  .integer 0 1 0 0 0,  -- 1: Integer
  .initCoroutine 3 17 3 0 0,  -- 2: InitCoroutine
  .sorterOpen 2 3 0 "k(1,B)" 0,  -- 3: SorterOpen
  .openRead 1 2 0 2 0,  -- 4: OpenRead
  .rewind 1 10 0 0 0,  -- 5: Rewind
  .column 1 0 7 0 0,  -- 6: Column
  .makeRecord 7 1 9 0 0,  -- 7: MakeRecord
  .sorterInsert 2 9 7 1 0,  -- 8: SorterInsert
  .next 1 6 0 0 1,  -- 9: Next
  .openPseudo 3 10 3 0 0,  -- 10: OpenPseudo
  .sorterSort 2 16 0 0 0,  -- 11: SorterSort
  .sorterData 2 10 3 0 0,  -- 12: SorterData
  .column 3 0 8 0 0,  -- 13: Column
  .yield 3 0 0 0 0,  -- 14: Yield
  .sorterNext 2 12 0 0 0,  -- 15: SorterNext
  .endCoroutine 3 0 0 0 0,  -- 16: EndCoroutine
  .initCoroutine 4 60 18 0 0,  -- 17: InitCoroutine
  .sorterOpen 4 3 0 "k(1,B)" 0,  -- 18: SorterOpen
  .openRead 0 2 0 2 0,  -- 19: OpenRead
  .rewind 0 25 0 0 0,  -- 20: Rewind
  .column 0 1 11 0 0,  -- 21: Column
  .makeRecord 11 1 13 0 0,  -- 22: MakeRecord
  .sorterInsert 4 13 11 1 0,  -- 23: SorterInsert
  .next 0 21 0 0 1,  -- 24: Next
  .openPseudo 5 14 3 0 0,  -- 25: OpenPseudo
  .sorterSort 4 31 0 0 0,  -- 26: SorterSort
  .sorterData 4 14 5 0 0,  -- 27: SorterData
  .column 5 0 12 0 0,  -- 28: Column
  .yield 4 0 0 0 0,  -- 29: Yield
  .sorterNext 4 27 0 0 0,  -- 30: SorterNext
  .endCoroutine 4 0 0 0 0,  -- 31: EndCoroutine
  .ifNot 1 35 0 0 0,  -- 32: IfNot
  .compare 8 2 1 "k(1,B)" 0,  -- 33: Compare
  .jump 35 38 35 0 0,  -- 34: Jump
  .copy 8 2 0 0 0,  -- 35: Copy
  .integer 1 1 0 0 0,  -- 36: Integer
  .resultRow 8 1 0 0 0,  -- 37: ResultRow
  .return 5 0 0 0 0,  -- 38: Return
  .ifNot 1 42 0 0 0,  -- 39: IfNot
  .compare 12 2 1 "k(1,B)" 0,  -- 40: Compare
  .jump 42 45 42 0 0,  -- 41: Jump
  .copy 12 2 0 0 0,  -- 42: Copy
  .integer 1 1 0 0 0,  -- 43: Integer
  .resultRow 12 1 0 0 0,  -- 44: ResultRow
  .return 6 0 0 0 0,  -- 45: Return
  .gosub 6 39 0 0 0,  -- 46: Gosub
  .yield 4 65 0 0 0,  -- 47: Yield
  .goto 0 46 0 0 0,  -- 48: Goto
  .gosub 5 32 0 0 0,  -- 49: Gosub
  .yield 3 65 0 0 0,  -- 50: Yield
  .goto 0 49 0 0 0,  -- 51: Goto
  .gosub 5 32 0 0 0,  -- 52: Gosub
  .yield 3 46 0 0 0,  -- 53: Yield
  .goto 0 62 0 0 0,  -- 54: Goto
  .yield 3 46 0 0 0,  -- 55: Yield
  .goto 0 62 0 0 0,  -- 56: Goto
  .gosub 6 39 0 0 0,  -- 57: Gosub
  .yield 4 49 0 0 0,  -- 58: Yield
  .goto 0 62 0 0 0,  -- 59: Goto
  .yield 3 47 0 0 0,  -- 60: Yield
  .yield 4 49 0 0 0,  -- 61: Yield
  .permutation 0 0 0 "[0]" 0,  -- 62: Permutation
  .compare 8 12 1 "k(2,B,)" 1,  -- 63: Compare
  .jump 52 55 57 0 0,  -- 64: Jump
  .halt 0 0 0 0 0,  -- 65: Halt
  .transaction 0 0 8 0 1,  -- 66: Transaction
  .goto 0 1 0 0 0  -- 67: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000092
