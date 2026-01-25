import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000104

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=

  Query: SELECT * FROM test1 WHERE f1<0 ORDER BY f1

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     19    0                    0   
  1     SorterOpen     1     4     0     k(1,B)         0   
  2     OpenRead       0     2     0     2              0   
  3     Rewind         0     11    0                    0   
  4     Column         0     0     1                    0   
  5     Ge             2     10    1     BINARY-8       84  
  6     Column         0     1     4                    0   
  7     Column         0     0     3                    0   
  8     MakeRecord     3     2     6                    0   
  9     SorterInsert   1     6     3     2              0   
  10    Next           0     4     0                    1   
  11    OpenPseudo     2     7     4                    0   
  12    SorterSort     1     18    0                    0   
  13    SorterData     1     7     2                    0   
  14    Column         2     1     5                    0   
  15    Column         2     0     4                    0   
  16    ResultRow      4     2     0                    0   
  17    SorterNext     1     13    0                    0   
  18    Halt           0     0     0                    0   
  19    Transaction    0     0     9     0              1   
  20    Integer        0     2     0                    0   
  21    Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 19 0 "" 0,  -- 0: Init
  vdbeSorterOpen 1 4 0 "k(1,B)" 0,  -- 1: SorterOpen
  vdbeOpenRead 0 2 0 "2" 0,  -- 2: OpenRead
  vdbeRewind 0 11 0 "" 0,  -- 3: Rewind
  vdbeColumn 0 0 1 "" 0,  -- 4: Column
  vdbeGe 2 10 1 "BINARY-8" 84,  -- 5: Ge
  vdbeColumn 0 1 4 "" 0,  -- 6: Column
  vdbeColumn 0 0 3 "" 0,  -- 7: Column
  vdbeMakeRecord 3 2 6 "" 0,  -- 8: MakeRecord
  vdbeSorterInsert 1 6 3 "2" 0,  -- 9: SorterInsert
  vdbeNext 0 4 0 "" 1,  -- 10: Next
  vdbeOpenPseudo 2 7 4 "" 0,  -- 11: OpenPseudo
  vdbeSorterSort 1 18 0 "" 0,  -- 12: SorterSort
  vdbeSorterData 1 7 2 "" 0,  -- 13: SorterData
  vdbeColumn 2 1 5 "" 0,  -- 14: Column
  vdbeColumn 2 0 4 "" 0,  -- 15: Column
  vdbeResultRow 4 2 0 "" 0,  -- 16: ResultRow
  vdbeSorterNext 1 13 0 "" 0,  -- 17: SorterNext
  vdbeHalt 0 0 0 "" 0,  -- 18: Halt
  vdbeTransaction 0 0 9 "0" 1,  -- 19: Transaction
  vdbeInteger 0 2 0 "" 0,  -- 20: Integer
  vdbeGoto 0 1 0 "" 0  -- 21: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000104
