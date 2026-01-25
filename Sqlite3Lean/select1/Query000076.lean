import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000076

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=
    cursor=1 rootpage=8 db=0 mode=read name=

  Query: SELECT A.f1, t1 FROM test1 as A, test2 
           ORDER BY f2

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     21    0                    0   
  1     SorterOpen     2     4     0     k(1,B)         0   
  2     OpenRead       0     2     0     2              0   
  3     OpenRead       1     8     0     1              0   
  4     Rewind         0     13    0                    0   
  5     Rewind         1     13    0                    0   
  6     Column         0     0     2                    0   
  7     Column         1     0     3                    0   
  8     Column         0     1     1                    0   
  9     MakeRecord     1     3     4                    0   
  10    SorterInsert   2     4     1     3              0   
  11    Next           1     6     0                    1   
  12    Next           0     5     0                    1   
  13    OpenPseudo     3     5     4                    0   
  14    SorterSort     2     20    0                    0   
  15    SorterData     2     5     3                    0   
  16    Column         3     2     3                    0   
  17    Column         3     1     2                    0   
  18    ResultRow      2     2     0                    0   
  19    SorterNext     2     15    0                    0   
  20    Halt           0     0     0                    0   
  21    Transaction    0     0     8     0              1   
  22    Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 21 0 "" 0,  -- 0: Init
  vdbeSorterOpen 2 4 0 "k(1,B)" 0,  -- 1: SorterOpen
  vdbeOpenRead 0 2 0 "2" 0,  -- 2: OpenRead
  vdbeOpenRead 1 8 0 "1" 0,  -- 3: OpenRead
  vdbeRewind 0 13 0 "" 0,  -- 4: Rewind
  vdbeRewind 1 13 0 "" 0,  -- 5: Rewind
  vdbeColumn 0 0 2 "" 0,  -- 6: Column
  vdbeColumn 1 0 3 "" 0,  -- 7: Column
  vdbeColumn 0 1 1 "" 0,  -- 8: Column
  vdbeMakeRecord 1 3 4 "" 0,  -- 9: MakeRecord
  vdbeSorterInsert 2 4 1 "3" 0,  -- 10: SorterInsert
  vdbeNext 1 6 0 "" 1,  -- 11: Next
  vdbeNext 0 5 0 "" 1,  -- 12: Next
  vdbeOpenPseudo 3 5 4 "" 0,  -- 13: OpenPseudo
  vdbeSorterSort 2 20 0 "" 0,  -- 14: SorterSort
  vdbeSorterData 2 5 3 "" 0,  -- 15: SorterData
  vdbeColumn 3 2 3 "" 0,  -- 16: Column
  vdbeColumn 3 1 2 "" 0,  -- 17: Column
  vdbeResultRow 2 2 0 "" 0,  -- 18: ResultRow
  vdbeSorterNext 2 15 0 "" 0,  -- 19: SorterNext
  vdbeHalt 0 0 0 "" 0,  -- 20: Halt
  vdbeTransaction 0 0 8 "0" 1,  -- 21: Transaction
  vdbeGoto 0 1 0 "" 0  -- 22: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000076
