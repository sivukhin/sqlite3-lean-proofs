import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000144

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=2 rootpage=4 db=0 mode=read name=
    cursor=4 rootpage=5 db=0 mode=read name=
    cursor=0 rootpage=3 db=0 mode=read name=

  Query: SELECT * FROM t1,(SELECT * FROM t2 WHERE y=2 ORDER BY y,z LIMIT 4);

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     48    0                    0   
  1     InitCoroutine  1     37    2                    0   
  2     OpenEphemeral  3     3     0     k(1,B)         0   
  3     Integer        4     2     0                    0   
  4     OpenRead       2     4     0     2              0   
  5     OpenRead       4     5     0     k(2,,)         2   
  6     Integer        2     3     0                    0   
  7     SeekGE         4     28    3     1              0   
  8     IdxGT          4     28    3     1              0   
  9     DeferredSeek   4     0     2                    0   
  10    Column         4     0     4                    0   
  11    Column         2     1     5                    0   
  12    Sequence       3     6     0                    0   
  13    Column         4     0     7                    0   
  14    MakeRecord     5     3     9                    0   
  15    IfNot          6     21    0                    0   
  16    Compare        10    4     1     k(2,B,B)       0   
  17    Jump           18    22    18                   0   
  18    Gosub          11    30    0                    0   
  19    ResetSorter    3     0     0                    0   
  20    IfNot          2     36    0                    0   
  21    Move           4     10    1                    0   
  22    IfNotZero      2     26    0                    0   
  23    Last           3     0     0                    0   
  24    IdxLE          3     27    5     1              0   
  25    Delete         3     0     0                    0   
  26    IdxInsert      3     9     5     3              0   
  27    Next           4     8     1                    0   
  28    Gosub          11    30    0                    0   
  29    Goto           0     36    0                    0   
  30    Sort           3     36    0                    0   
  31    Column         3     0     8                    0   
  32    Column         3     2     7                    0   
  33    Yield          1     0     0                    0   
  34    Next           3     31    0                    0   
  35    Return         11    0     0                    0   
  36    EndCoroutine   1     0     0                    0   
  37    OpenRead       0     3     0     1              0   
  38    InitCoroutine  1     0     2                    0   
  39    Yield          1     47    0                    0   
  40    Rewind         0     47    0                    0   
  41    Column         0     0     12                   0   
  42    Copy           7     13    0                    2   
  43    Copy           8     14    0                    2   
  44    ResultRow      12    3     0                    0   
  45    Next           0     41    0                    1   
  46    Goto           0     39    0                    0   
  47    Halt           0     0     0                    0   
  48    Transaction    0     0     25    1              1   
  49    Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 48 0 0 0,  -- 0: Init
  .initCoroutine 1 37 2 0 0,  -- 1: InitCoroutine
  .openEphemeral 3 3 0 "k(1,B)" 0,  -- 2: OpenEphemeral
  .integer 4 2 0 0 0,  -- 3: Integer
  .openRead 2 4 0 2 0,  -- 4: OpenRead
  .openRead 4 5 0 "k(2,,)" 2,  -- 5: OpenRead
  .integer 2 3 0 0 0,  -- 6: Integer
  .seekGE 4 28 3 1 0,  -- 7: SeekGE
  .idxGT 4 28 3 1 0,  -- 8: IdxGT
  .deferredSeek 4 0 2 0 0,  -- 9: DeferredSeek
  .column 4 0 4 0 0,  -- 10: Column
  .column 2 1 5 0 0,  -- 11: Column
  .sequence 3 6 0 0 0,  -- 12: Sequence
  .column 4 0 7 0 0,  -- 13: Column
  .makeRecord 5 3 9 0 0,  -- 14: MakeRecord
  .ifNot 6 21 0 0 0,  -- 15: IfNot
  .compare 10 4 1 "k(2,B,B)" 0,  -- 16: Compare
  .jump 18 22 18 0 0,  -- 17: Jump
  .gosub 11 30 0 0 0,  -- 18: Gosub
  .resetSorter 3 0 0 0 0,  -- 19: ResetSorter
  .ifNot 2 36 0 0 0,  -- 20: IfNot
  .move 4 10 1 0 0,  -- 21: Move
  .ifNotZero 2 26 0 0 0,  -- 22: IfNotZero
  .last 3 0 0 0 0,  -- 23: Last
  .idxLE 3 27 5 1 0,  -- 24: IdxLE
  .delete 3 0 0 0 0,  -- 25: Delete
  .idxInsert 3 9 5 3 0,  -- 26: IdxInsert
  .next 4 8 1 0 0,  -- 27: Next
  .gosub 11 30 0 0 0,  -- 28: Gosub
  .goto 0 36 0 0 0,  -- 29: Goto
  .sort 3 36 0 0 0,  -- 30: Sort
  .column 3 0 8 0 0,  -- 31: Column
  .column 3 2 7 0 0,  -- 32: Column
  .yield 1 0 0 0 0,  -- 33: Yield
  .next 3 31 0 0 0,  -- 34: Next
  .return 11 0 0 0 0,  -- 35: Return
  .endCoroutine 1 0 0 0 0,  -- 36: EndCoroutine
  .openRead 0 3 0 1 0,  -- 37: OpenRead
  .initCoroutine 1 0 2 0 0,  -- 38: InitCoroutine
  .yield 1 47 0 0 0,  -- 39: Yield
  .rewind 0 47 0 0 0,  -- 40: Rewind
  .column 0 0 12 0 0,  -- 41: Column
  .copy 7 13 0 0 2,  -- 42: Copy
  .copy 8 14 0 0 2,  -- 43: Copy
  .resultRow 12 3 0 0 0,  -- 44: ResultRow
  .next 0 41 0 0 1,  -- 45: Next
  .goto 0 39 0 0 0,  -- 46: Goto
  .halt 0 0 0 0 0,  -- 47: Halt
  .transaction 0 0 25 1 1,  -- 48: Transaction
  .goto 0 1 0 0 0  -- 49: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000144
