import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000050

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=

  Query: SELECT f1 FROM test1 ORDER BY -f1

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     17    0                    0   
  1     SorterOpen     1     3     0     k(1,B)         0   
  2     OpenRead       0     2     0     1              0   
  3     Rewind         0     10    0                    0   
  4     Column         0     0     2                    0   
  5     Column         0     0     4                    0   
  6     Subtract       4     3     1                    0   
  7     MakeRecord     1     2     5                    0   
  8     SorterInsert   1     5     1     2              0   
  9     Next           0     4     0                    1   
  10    OpenPseudo     2     6     3                    0   
  11    SorterSort     1     16    0                    0   
  12    SorterData     1     6     2                    0   
  13    Column         2     1     2                    0   
  14    ResultRow      2     1     0                    0   
  15    SorterNext     1     12    0                    0   
  16    Halt           0     0     0                    0   
  17    Transaction    0     0     6     0              1   
  18    Integer        0     3     0                    0   
  19    Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 17 0 "" 0,  -- 0: Init
  vdbeSorterOpen 1 3 0 "k(1,B)" 0,  -- 1: SorterOpen
  vdbeOpenRead 0 2 0 "1" 0,  -- 2: OpenRead
  vdbeRewind 0 10 0 "" 0,  -- 3: Rewind
  vdbeColumn 0 0 2 "" 0,  -- 4: Column
  vdbeColumn 0 0 4 "" 0,  -- 5: Column
  vdbeSubtract 4 3 1 "" 0,  -- 6: Subtract
  vdbeMakeRecord 1 2 5 "" 0,  -- 7: MakeRecord
  vdbeSorterInsert 1 5 1 "2" 0,  -- 8: SorterInsert
  vdbeNext 0 4 0 "" 1,  -- 9: Next
  vdbeOpenPseudo 2 6 3 "" 0,  -- 10: OpenPseudo
  vdbeSorterSort 1 16 0 "" 0,  -- 11: SorterSort
  vdbeSorterData 1 6 2 "" 0,  -- 12: SorterData
  vdbeColumn 2 1 2 "" 0,  -- 13: Column
  vdbeResultRow 2 1 0 "" 0,  -- 14: ResultRow
  vdbeSorterNext 1 12 0 "" 0,  -- 15: SorterNext
  vdbeHalt 0 0 0 "" 0,  -- 16: Halt
  vdbeTransaction 0 0 6 "0" 1,  -- 17: Transaction
  vdbeInteger 0 3 0 "" 0,  -- 18: Integer
  vdbeGoto 0 1 0 "" 0  -- 19: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000050
