import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000130

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=2 rootpage=3 db=0 mode=read name=
    cursor=1 rootpage=4 db=0 mode=read name=

  Query: SELECT x FROM (
          SELECT a AS x, b AS y FROM t3 UNION SELECT a,b FROM t4 ORDER BY a,b
        ) ORDER BY x;

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     38    0                    0   
  1     InitCoroutine  1     24    2                    0   
  2     OpenEphemeral  3     2     0     k(2,B,B)       0   
  3     OpenRead       2     3     0     2              0   
  4     Rewind         2     10    0                    0   
  5     Column         2     0     2                    0   
  6     Column         2     1     3                    0   
  7     MakeRecord     2     2     4                    0   
  8     IdxInsert      3     4     2     2              0   
  9     Next           2     5     0                    1   
  10    OpenRead       1     4     0     2              0   
  11    Rewind         1     17    0                    0   
  12    Column         1     0     2                    0   
  13    Column         1     1     3                    0   
  14    MakeRecord     2     2     4                    0   
  15    IdxInsert      3     4     2     2              0   
  16    Next           1     12    0                    1   
  17    Rewind         3     22    0                    0   
  18    Column         3     0     5                    0   
  19    Column         3     1     6                    0   
  20    Yield          1     0     0                    0   
  21    Next           3     18    0                    0   
  22    Close          3     0     0                    0   
  23    EndCoroutine   1     0     0                    0   
  24    SorterOpen     4     3     0     k(1,B)         0   
  25    InitCoroutine  1     0     2                    0   
  26    Yield          1     31    0                    0   
  27    Copy           5     7     0                    2   
  28    MakeRecord     7     1     9                    0   
  29    SorterInsert   4     9     7     1              0   
  30    Goto           0     26    0                    0   
  31    OpenPseudo     5     10    3                    0   
  32    SorterSort     4     37    0                    0   
  33    SorterData     4     10    5                    0   
  34    Column         5     0     8                    0   
  35    ResultRow      8     1     0                    0   
  36    SorterNext     4     33    0                    0   
  37    Halt           0     0     0                    0   
  38    Transaction    0     0     9     0              1   
  39    Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 38 0 "" 0,  -- 0: Init
  vdbeInitCoroutine 1 24 2 "" 0,  -- 1: InitCoroutine
  vdbeOpenEphemeral 3 2 0 "k(2,B,B)" 0,  -- 2: OpenEphemeral
  vdbeOpenRead 2 3 0 "2" 0,  -- 3: OpenRead
  vdbeRewind 2 10 0 "" 0,  -- 4: Rewind
  vdbeColumn 2 0 2 "" 0,  -- 5: Column
  vdbeColumn 2 1 3 "" 0,  -- 6: Column
  vdbeMakeRecord 2 2 4 "" 0,  -- 7: MakeRecord
  vdbeIdxInsert 3 4 2 "2" 0,  -- 8: IdxInsert
  vdbeNext 2 5 0 "" 1,  -- 9: Next
  vdbeOpenRead 1 4 0 "2" 0,  -- 10: OpenRead
  vdbeRewind 1 17 0 "" 0,  -- 11: Rewind
  vdbeColumn 1 0 2 "" 0,  -- 12: Column
  vdbeColumn 1 1 3 "" 0,  -- 13: Column
  vdbeMakeRecord 2 2 4 "" 0,  -- 14: MakeRecord
  vdbeIdxInsert 3 4 2 "2" 0,  -- 15: IdxInsert
  vdbeNext 1 12 0 "" 1,  -- 16: Next
  vdbeRewind 3 22 0 "" 0,  -- 17: Rewind
  vdbeColumn 3 0 5 "" 0,  -- 18: Column
  vdbeColumn 3 1 6 "" 0,  -- 19: Column
  vdbeYield 1 0 0 "" 0,  -- 20: Yield
  vdbeNext 3 18 0 "" 0,  -- 21: Next
  vdbeClose 3 0 0 "" 0,  -- 22: Close
  vdbeEndCoroutine 1 0 0 "" 0,  -- 23: EndCoroutine
  vdbeSorterOpen 4 3 0 "k(1,B)" 0,  -- 24: SorterOpen
  vdbeInitCoroutine 1 0 2 "" 0,  -- 25: InitCoroutine
  vdbeYield 1 31 0 "" 0,  -- 26: Yield
  vdbeCopy 5 7 0 "" 2,  -- 27: Copy
  vdbeMakeRecord 7 1 9 "" 0,  -- 28: MakeRecord
  vdbeSorterInsert 4 9 7 "1" 0,  -- 29: SorterInsert
  vdbeGoto 0 26 0 "" 0,  -- 30: Goto
  vdbeOpenPseudo 5 10 3 "" 0,  -- 31: OpenPseudo
  vdbeSorterSort 4 37 0 "" 0,  -- 32: SorterSort
  vdbeSorterData 4 10 5 "" 0,  -- 33: SorterData
  vdbeColumn 5 0 8 "" 0,  -- 34: Column
  vdbeResultRow 8 1 0 "" 0,  -- 35: ResultRow
  vdbeSorterNext 4 33 0 "" 0,  -- 36: SorterNext
  vdbeHalt 0 0 0 "" 0,  -- 37: Halt
  vdbeTransaction 0 0 9 "0" 1,  -- 38: Transaction
  vdbeGoto 0 1 0 "" 0  -- 39: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000130
