import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000049

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=

  Query: SELECT f1 FROM test1 ORDER BY f1

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     15    0                    0   
  1     SorterOpen     1     3     0     k(1,B)         0   
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
  15    Transaction    0     0     6     0              1   
  16    Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 15 0 0 0,  -- 0: Init
  .sorterOpen 1 3 0 "k(1,B)" 0,  -- 1: SorterOpen
  .openRead 0 2 0 1 0,  -- 2: OpenRead
  .rewind 0 8 0 0 0,  -- 3: Rewind
  .column 0 0 1 0 0,  -- 4: Column
  .makeRecord 1 1 3 0 0,  -- 5: MakeRecord
  .sorterInsert 1 3 1 1 0,  -- 6: SorterInsert
  .next 0 4 0 0 1,  -- 7: Next
  .openPseudo 2 4 3 0 0,  -- 8: OpenPseudo
  .sorterSort 1 14 0 0 0,  -- 9: SorterSort
  .sorterData 1 4 2 0 0,  -- 10: SorterData
  .column 2 0 2 0 0,  -- 11: Column
  .resultRow 2 1 0 0 0,  -- 12: ResultRow
  .sorterNext 1 10 0 0 0,  -- 13: SorterNext
  .halt 0 0 0 0 0,  -- 14: Halt
  .transaction 0 0 6 0 1,  -- 15: Transaction
  .goto 0 1 0 0 0  -- 16: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000049
