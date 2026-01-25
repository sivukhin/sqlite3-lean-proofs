import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000071

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=

  Query: SELECT f1+F2 as xyzzy FROM test1 ORDER BY f2

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     18    0                    0   
  1     SorterOpen     1     3     0     k(1,B)         0   
  2     OpenRead       0     2     0     2              0   
  3     Rewind         0     11    0                    0   
  4     Column         0     0     3                    0   
  5     Column         0     1     4                    0   
  6     Add            4     3     2                    0   
  7     Column         0     1     1                    0   
  8     MakeRecord     1     2     5                    0   
  9     SorterInsert   1     5     1     2              0   
  10    Next           0     4     0                    1   
  11    OpenPseudo     2     6     3                    0   
  12    SorterSort     1     17    0                    0   
  13    SorterData     1     6     2                    0   
  14    Column         2     1     2                    0   
  15    ResultRow      2     1     0                    0   
  16    SorterNext     1     13    0                    0   
  17    Halt           0     0     0                    0   
  18    Transaction    0     0     8     0              1   
  19    Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 18 0 "" 0,  -- 0: Init
  vdbeSorterOpen 1 3 0 "k(1,B)" 0,  -- 1: SorterOpen
  vdbeOpenRead 0 2 0 "2" 0,  -- 2: OpenRead
  vdbeRewind 0 11 0 "" 0,  -- 3: Rewind
  vdbeColumn 0 0 3 "" 0,  -- 4: Column
  vdbeColumn 0 1 4 "" 0,  -- 5: Column
  vdbeAdd 4 3 2 "" 0,  -- 6: Add
  vdbeColumn 0 1 1 "" 0,  -- 7: Column
  vdbeMakeRecord 1 2 5 "" 0,  -- 8: MakeRecord
  vdbeSorterInsert 1 5 1 "2" 0,  -- 9: SorterInsert
  vdbeNext 0 4 0 "" 1,  -- 10: Next
  vdbeOpenPseudo 2 6 3 "" 0,  -- 11: OpenPseudo
  vdbeSorterSort 1 17 0 "" 0,  -- 12: SorterSort
  vdbeSorterData 1 6 2 "" 0,  -- 13: SorterData
  vdbeColumn 2 1 2 "" 0,  -- 14: Column
  vdbeResultRow 2 1 0 "" 0,  -- 15: ResultRow
  vdbeSorterNext 1 13 0 "" 0,  -- 16: SorterNext
  vdbeHalt 0 0 0 "" 0,  -- 17: Halt
  vdbeTransaction 0 0 8 "0" 1,  -- 18: Transaction
  vdbeGoto 0 1 0 "" 0  -- 19: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000071
