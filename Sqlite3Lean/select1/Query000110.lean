import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000110

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=

  Query: SELECT f1-22 AS x, f2-22 as y FROM test1 WHERE x>0 AND y<50
    

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     16    0                    0   
  1     OpenRead       0     2     0     2              0   
  2     Rewind         0     15    0                    0   
  3     Column         0     0     2                    0   
  4     Subtract       3     2     1                    0   
  5     Le             4     14    1                    80  
  6     Column         0     1     2                    0   
  7     Subtract       3     2     1                    0   
  8     Ge             5     14    1                    80  
  9     Column         0     0     1                    0   
  10    Subtract       3     1     6                    0   
  11    Column         0     1     1                    0   
  12    Subtract       3     1     7                    0   
  13    ResultRow      6     2     0                    0   
  14    Next           0     3     0                    1   
  15    Halt           0     0     0                    0   
  16    Transaction    0     0     9     0              1   
  17    Integer        22    3     0                    0   
  18    Integer        0     4     0                    0   
  19    Integer        50    5     0                    0   
  20    Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 16 0 0 0,  -- 0: Init
  .openRead 0 2 0 2 0,  -- 1: OpenRead
  .rewind 0 15 0 0 0,  -- 2: Rewind
  .column 0 0 2 0 0,  -- 3: Column
  .subtract 3 2 1 0 0,  -- 4: Subtract
  .le 4 14 1 0 80,  -- 5: Le
  .column 0 1 2 0 0,  -- 6: Column
  .subtract 3 2 1 0 0,  -- 7: Subtract
  .ge 5 14 1 0 80,  -- 8: Ge
  .column 0 0 1 0 0,  -- 9: Column
  .subtract 3 1 6 0 0,  -- 10: Subtract
  .column 0 1 1 0 0,  -- 11: Column
  .subtract 3 1 7 0 0,  -- 12: Subtract
  .resultRow 6 2 0 0 0,  -- 13: ResultRow
  .next 0 3 0 0 1,  -- 14: Next
  .halt 0 0 0 0 0,  -- 15: Halt
  .transaction 0 0 9 0 1,  -- 16: Transaction
  .integer 22 3 0 0 0,  -- 17: Integer
  .integer 0 4 0 0 0,  -- 18: Integer
  .integer 50 5 0 0 0,  -- 19: Integer
  .goto 0 1 0 0 0  -- 20: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000110
