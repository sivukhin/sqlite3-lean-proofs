import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000075

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=
    cursor=1 rootpage=8 db=0 mode=read name=

  Query: SELECT test1.f1+F2, t1 FROM test1, test2 
           ORDER BY f2

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     23    0                    0   
  1     SorterOpen     2     4     0     k(1,B)         0   
  2     OpenRead       0     2     0     2              0   
  3     OpenRead       1     8     0     1              0   
  4     Rewind         0     15    0                    0   
  5     Rewind         1     15    0                    0   
  6     Column         0     0     4                    0   
  7     Column         0     1     5                    0   
  8     Add            5     4     2                    0   
  9     Column         1     0     3                    0   
  10    Column         0     1     1                    0   
  11    MakeRecord     1     3     6                    0   
  12    SorterInsert   2     6     1     3              0   
  13    Next           1     6     0                    1   
  14    Next           0     5     0                    1   
  15    OpenPseudo     3     7     4                    0   
  16    SorterSort     2     22    0                    0   
  17    SorterData     2     7     3                    0   
  18    Column         3     2     3                    0   
  19    Column         3     1     2                    0   
  20    ResultRow      2     2     0                    0   
  21    SorterNext     2     17    0                    0   
  22    Halt           0     0     0                    0   
  23    Transaction    0     0     8     0              1   
  24    Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 23 0 "" 0,  -- 0: Init
  vdbeSorterOpen 2 4 0 "k(1,B)" 0,  -- 1: SorterOpen
  vdbeOpenRead 0 2 0 "2" 0,  -- 2: OpenRead
  vdbeOpenRead 1 8 0 "1" 0,  -- 3: OpenRead
  vdbeRewind 0 15 0 "" 0,  -- 4: Rewind
  vdbeRewind 1 15 0 "" 0,  -- 5: Rewind
  vdbeColumn 0 0 4 "" 0,  -- 6: Column
  vdbeColumn 0 1 5 "" 0,  -- 7: Column
  vdbeAdd 5 4 2 "" 0,  -- 8: Add
  vdbeColumn 1 0 3 "" 0,  -- 9: Column
  vdbeColumn 0 1 1 "" 0,  -- 10: Column
  vdbeMakeRecord 1 3 6 "" 0,  -- 11: MakeRecord
  vdbeSorterInsert 2 6 1 "3" 0,  -- 12: SorterInsert
  vdbeNext 1 6 0 "" 1,  -- 13: Next
  vdbeNext 0 5 0 "" 1,  -- 14: Next
  vdbeOpenPseudo 3 7 4 "" 0,  -- 15: OpenPseudo
  vdbeSorterSort 2 22 0 "" 0,  -- 16: SorterSort
  vdbeSorterData 2 7 3 "" 0,  -- 17: SorterData
  vdbeColumn 3 2 3 "" 0,  -- 18: Column
  vdbeColumn 3 1 2 "" 0,  -- 19: Column
  vdbeResultRow 2 2 0 "" 0,  -- 20: ResultRow
  vdbeSorterNext 2 17 0 "" 0,  -- 21: SorterNext
  vdbeHalt 0 0 0 "" 0,  -- 22: Halt
  vdbeTransaction 0 0 8 "0" 1,  -- 23: Transaction
  vdbeGoto 0 1 0 "" 0  -- 24: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000075
