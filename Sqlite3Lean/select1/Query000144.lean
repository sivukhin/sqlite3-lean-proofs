import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000144

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
  vdbeInit 0 48 0 "" 0,  -- 0: Init
  vdbeInitCoroutine 1 37 2 "" 0,  -- 1: InitCoroutine
  vdbeOpenEphemeral 3 3 0 "k(1,B)" 0,  -- 2: OpenEphemeral
  vdbeInteger 4 2 0 "" 0,  -- 3: Integer
  vdbeOpenRead 2 4 0 "2" 0,  -- 4: OpenRead
  vdbeOpenRead 4 5 0 "k(2,,)" 2,  -- 5: OpenRead
  vdbeInteger 2 3 0 "" 0,  -- 6: Integer
  vdbeSeekGE 4 28 3 "1" 0,  -- 7: SeekGE
  vdbeIdxGT 4 28 3 "1" 0,  -- 8: IdxGT
  vdbeDeferredSeek 4 0 2 "" 0,  -- 9: DeferredSeek
  vdbeColumn 4 0 4 "" 0,  -- 10: Column
  vdbeColumn 2 1 5 "" 0,  -- 11: Column
  vdbeSequence 3 6 0 "" 0,  -- 12: Sequence
  vdbeColumn 4 0 7 "" 0,  -- 13: Column
  vdbeMakeRecord 5 3 9 "" 0,  -- 14: MakeRecord
  vdbeIfNot 6 21 0 "" 0,  -- 15: IfNot
  vdbeCompare 10 4 1 "k(2,B,B)" 0,  -- 16: Compare
  vdbeJump 18 22 18 "" 0,  -- 17: Jump
  vdbeGosub 11 30 0 "" 0,  -- 18: Gosub
  vdbeResetSorter 3 0 0 "" 0,  -- 19: ResetSorter
  vdbeIfNot 2 36 0 "" 0,  -- 20: IfNot
  vdbeMove 4 10 1 "" 0,  -- 21: Move
  vdbeIfNotZero 2 26 0 "" 0,  -- 22: IfNotZero
  vdbeLast 3 0 0 "" 0,  -- 23: Last
  vdbeIdxLE 3 27 5 "1" 0,  -- 24: IdxLE
  vdbeDelete 3 0 0 "" 0,  -- 25: Delete
  vdbeIdxInsert 3 9 5 "3" 0,  -- 26: IdxInsert
  vdbeNext 4 8 1 "" 0,  -- 27: Next
  vdbeGosub 11 30 0 "" 0,  -- 28: Gosub
  vdbeGoto 0 36 0 "" 0,  -- 29: Goto
  vdbeSort 3 36 0 "" 0,  -- 30: Sort
  vdbeColumn 3 0 8 "" 0,  -- 31: Column
  vdbeColumn 3 2 7 "" 0,  -- 32: Column
  vdbeYield 1 0 0 "" 0,  -- 33: Yield
  vdbeNext 3 31 0 "" 0,  -- 34: Next
  vdbeReturn 11 0 0 "" 0,  -- 35: Return
  vdbeEndCoroutine 1 0 0 "" 0,  -- 36: EndCoroutine
  vdbeOpenRead 0 3 0 "1" 0,  -- 37: OpenRead
  vdbeInitCoroutine 1 0 2 "" 0,  -- 38: InitCoroutine
  vdbeYield 1 47 0 "" 0,  -- 39: Yield
  vdbeRewind 0 47 0 "" 0,  -- 40: Rewind
  vdbeColumn 0 0 12 "" 0,  -- 41: Column
  vdbeCopy 7 13 0 "" 2,  -- 42: Copy
  vdbeCopy 8 14 0 "" 2,  -- 43: Copy
  vdbeResultRow 12 3 0 "" 0,  -- 44: ResultRow
  vdbeNext 0 41 0 "" 1,  -- 45: Next
  vdbeGoto 0 39 0 "" 0,  -- 46: Goto
  vdbeHalt 0 0 0 "" 0,  -- 47: Halt
  vdbeTransaction 0 0 25 "1" 1,  -- 48: Transaction
  vdbeGoto 0 1 0 "" 0  -- 49: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000144
