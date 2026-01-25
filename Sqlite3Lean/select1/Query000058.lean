import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000058

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=7 db=0 mode=read name=

  Query: SELECT * FROM t5 ORDER BY 1 DESC, b;

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     17    0                    0   
  1     SorterOpen     1     5     0     k(2,-B,B)      0   
  2     OpenRead       0     7     0     2              0   
  3     Rewind         0     9     0                    0   
  4     Column         0     0     1                    0   
  5     Column         0     1     2                    0   
  6     MakeRecord     1     2     5                    0   
  7     SorterInsert   1     5     1     2              0   
  8     Next           0     4     0                    1   
  9     OpenPseudo     2     6     5                    0   
  10    SorterSort     1     16    0                    0   
  11    SorterData     1     6     2                    0   
  12    Column         2     1     4                    0   
  13    Column         2     0     3                    0   
  14    ResultRow      3     2     0                    0   
  15    SorterNext     1     11    0                    0   
  16    Halt           0     0     0                    0   
  17    Transaction    0     0     7     0              1   
  18    Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 17 0 0 0,  -- 0: Init
  .sorterOpen 1 5 0 "k(2,-B,B)" 0,  -- 1: SorterOpen
  .openRead 0 7 0 2 0,  -- 2: OpenRead
  .rewind 0 9 0 0 0,  -- 3: Rewind
  .column 0 0 1 0 0,  -- 4: Column
  .column 0 1 2 0 0,  -- 5: Column
  .makeRecord 1 2 5 0 0,  -- 6: MakeRecord
  .sorterInsert 1 5 1 2 0,  -- 7: SorterInsert
  .next 0 4 0 0 1,  -- 8: Next
  .openPseudo 2 6 5 0 0,  -- 9: OpenPseudo
  .sorterSort 1 16 0 0 0,  -- 10: SorterSort
  .sorterData 1 6 2 0 0,  -- 11: SorterData
  .column 2 1 4 0 0,  -- 12: Column
  .column 2 0 3 0 0,  -- 13: Column
  .resultRow 3 2 0 0 0,  -- 14: ResultRow
  .sorterNext 1 11 0 0 0,  -- 15: SorterNext
  .halt 0 0 0 0 0,  -- 16: Halt
  .transaction 0 0 7 0 1,  -- 17: Transaction
  .goto 0 1 0 0 0  -- 18: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000058
