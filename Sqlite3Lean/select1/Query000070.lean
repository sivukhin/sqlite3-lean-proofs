import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000070

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=

  Query: SELECT f1 as 'xyzzy ' FROM test1 ORDER BY f2

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     16    0                    0   
  1     SorterOpen     1     3     0     k(1,B)         0   
  2     OpenRead       0     2     0     2              0   
  3     Rewind         0     9     0                    0   
  4     Column         0     0     2                    0   
  5     Column         0     1     1                    0   
  6     MakeRecord     1     2     3                    0   
  7     SorterInsert   1     3     1     2              0   
  8     Next           0     4     0                    1   
  9     OpenPseudo     2     4     3                    0   
  10    SorterSort     1     15    0                    0   
  11    SorterData     1     4     2                    0   
  12    Column         2     1     2                    0   
  13    ResultRow      2     1     0                    0   
  14    SorterNext     1     11    0                    0   
  15    Halt           0     0     0                    0   
  16    Transaction    0     0     8     0              1   
  17    Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 16 0 "" 0,  -- 0: Init
  vdbeSorterOpen 1 3 0 "k(1,B)" 0,  -- 1: SorterOpen
  vdbeOpenRead 0 2 0 "2" 0,  -- 2: OpenRead
  vdbeRewind 0 9 0 "" 0,  -- 3: Rewind
  vdbeColumn 0 0 2 "" 0,  -- 4: Column
  vdbeColumn 0 1 1 "" 0,  -- 5: Column
  vdbeMakeRecord 1 2 3 "" 0,  -- 6: MakeRecord
  vdbeSorterInsert 1 3 1 "2" 0,  -- 7: SorterInsert
  vdbeNext 0 4 0 "" 1,  -- 8: Next
  vdbeOpenPseudo 2 4 3 "" 0,  -- 9: OpenPseudo
  vdbeSorterSort 1 15 0 "" 0,  -- 10: SorterSort
  vdbeSorterData 1 4 2 "" 0,  -- 11: SorterData
  vdbeColumn 2 1 2 "" 0,  -- 12: Column
  vdbeResultRow 2 1 0 "" 0,  -- 13: ResultRow
  vdbeSorterNext 1 11 0 "" 0,  -- 14: SorterNext
  vdbeHalt 0 0 0 "" 0,  -- 15: Halt
  vdbeTransaction 0 0 8 "0" 1,  -- 16: Transaction
  vdbeGoto 0 1 0 "" 0  -- 17: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000070
