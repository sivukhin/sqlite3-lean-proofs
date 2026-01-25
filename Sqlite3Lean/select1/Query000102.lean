import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000102

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=
    cursor=2 rootpage=8 db=0 mode=read name=

  Query: SELECT * FROM test1 WHERE f1<(select count(*) from test2)

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     21    0                    0   
  1     OpenRead       0     2     0     2              0   
  2     Rewind         0     20    0                    0   
  3     Column         0     0     1                    0   
  4     IsNull         1     19    0                    0   
  5     BeginSubrtn    0     3     0                    0   
  6     Once           0     14    0                    0   
  7     Null           0     4     4                    0   
  8     Integer        1     5     0                    0   
  9     OpenRead       2     8     0     1              0   
  10    Count          2     6     0                    0   
  11    Close          2     0     0                    0   
  12    Copy           6     4     0                    0   
  13    DecrJumpZero   5     14    0                    0   
  14    Return         3     6     1                    0   
  15    Ge             4     19    1     BINARY-8       84  
  16    Column         0     0     7                    0   
  17    Column         0     1     8                    0   
  18    ResultRow      7     2     0                    0   
  19    Next           0     3     0                    1   
  20    Halt           0     0     0                    0   
  21    Transaction    0     0     9     0              1   
  22    Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 21 0 0 0,  -- 0: Init
  .openRead 0 2 0 2 0,  -- 1: OpenRead
  .rewind 0 20 0 0 0,  -- 2: Rewind
  .column 0 0 1 0 0,  -- 3: Column
  .isNull 1 19 0 0 0,  -- 4: IsNull
  .beginSubrtn 0 3 0 0 0,  -- 5: BeginSubrtn
  .once 0 14 0 0 0,  -- 6: Once
  .null 0 4 4 0 0,  -- 7: Null
  .integer 1 5 0 0 0,  -- 8: Integer
  .openRead 2 8 0 1 0,  -- 9: OpenRead
  .count 2 6 0 0 0,  -- 10: Count
  .close 2 0 0 0 0,  -- 11: Close
  .copy 6 4 0 0 0,  -- 12: Copy
  .decrJumpZero 5 14 0 0 0,  -- 13: DecrJumpZero
  .return 3 6 1 0 0,  -- 14: Return
  .ge 4 19 1 "BINARY-8" 84,  -- 15: Ge
  .column 0 0 7 0 0,  -- 16: Column
  .column 0 1 8 0 0,  -- 17: Column
  .resultRow 7 2 0 0 0,  -- 18: ResultRow
  .next 0 3 0 0 1,  -- 19: Next
  .halt 0 0 0 0 0,  -- 20: Halt
  .transaction 0 0 9 0 1,  -- 21: Transaction
  .goto 0 1 0 0 0  -- 22: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000102
