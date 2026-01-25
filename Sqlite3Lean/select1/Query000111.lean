import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000111

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=

  Query: SELECT f1 COLLATE nocase AS x FROM test1 ORDER BY x
    

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     15    0                    0   
  1     SorterOpen     1     3     0     k(1,NOCASE)    0   
  2     OpenRead       0     2     0     1              0   
  3     Rewind         0     8     0                    0   
  4     Column         0     0     1                    0   
  5     MakeRecord     1     1     3                    0   
  6     SorterInsert   1     3     1     1              0   
  7     Next           0     4     0                    1   
  8     OpenPseudo     2     4     3                    0   
  9     SorterSort     1     14    0                    0   
  10    SorterData     1     4     2                    0   
  11    Column         2     0     2                    0   
  12    ResultRow      2     1     0                    0   
  13    SorterNext     1     10    0                    0   
  14    Halt           0     0     0                    0   
  15    Transaction    0     0     9     0              1   
  16    Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 15 0 "" 0,  -- 0: Init
  vdbeSorterOpen 1 3 0 "k(1,NOCASE)" 0,  -- 1: SorterOpen
  vdbeOpenRead 0 2 0 "1" 0,  -- 2: OpenRead
  vdbeRewind 0 8 0 "" 0,  -- 3: Rewind
  vdbeColumn 0 0 1 "" 0,  -- 4: Column
  vdbeMakeRecord 1 1 3 "" 0,  -- 5: MakeRecord
  vdbeSorterInsert 1 3 1 "1" 0,  -- 6: SorterInsert
  vdbeNext 0 4 0 "" 1,  -- 7: Next
  vdbeOpenPseudo 2 4 3 "" 0,  -- 8: OpenPseudo
  vdbeSorterSort 1 14 0 "" 0,  -- 9: SorterSort
  vdbeSorterData 1 4 2 "" 0,  -- 10: SorterData
  vdbeColumn 2 0 2 "" 0,  -- 11: Column
  vdbeResultRow 2 1 0 "" 0,  -- 12: ResultRow
  vdbeSorterNext 1 10 0 "" 0,  -- 13: SorterNext
  vdbeHalt 0 0 0 "" 0,  -- 14: Halt
  vdbeTransaction 0 0 9 "0" 1,  -- 15: Transaction
  vdbeGoto 0 1 0 "" 0  -- 16: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000111
