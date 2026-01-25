import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000073

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=

  Query: SELECT test1.f1+F2 FROM test1 ORDER BY f2

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
  .init 0 18 0 0 0,  -- 0: Init
  .sorterOpen 1 3 0 "k(1,B)" 0,  -- 1: SorterOpen
  .openRead 0 2 0 2 0,  -- 2: OpenRead
  .rewind 0 11 0 0 0,  -- 3: Rewind
  .column 0 0 3 0 0,  -- 4: Column
  .column 0 1 4 0 0,  -- 5: Column
  .add 4 3 2 0 0,  -- 6: Add
  .column 0 1 1 0 0,  -- 7: Column
  .makeRecord 1 2 5 0 0,  -- 8: MakeRecord
  .sorterInsert 1 5 1 2 0,  -- 9: SorterInsert
  .next 0 4 0 0 1,  -- 10: Next
  .openPseudo 2 6 3 0 0,  -- 11: OpenPseudo
  .sorterSort 1 17 0 0 0,  -- 12: SorterSort
  .sorterData 1 6 2 0 0,  -- 13: SorterData
  .column 2 1 2 0 0,  -- 14: Column
  .resultRow 2 1 0 0 0,  -- 15: ResultRow
  .sorterNext 1 13 0 0 0,  -- 16: SorterNext
  .halt 0 0 0 0 0,  -- 17: Halt
  .transaction 0 0 8 0 1,  -- 18: Transaction
  .goto 0 1 0 0 0  -- 19: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000073
