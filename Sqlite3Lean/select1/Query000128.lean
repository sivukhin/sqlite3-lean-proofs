import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000128

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=3 db=0 mode=read name=

  Query: SELECT * FROM t3 WHERE a=(SELECT 1);

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     18    0                    0   
  1     OpenRead       0     3     0     2              0   
  2     Rewind         0     17    0                    0   
  3     Column         0     0     1                    0   
  4     IsNull         1     16    0                    0   
  5     BeginSubrtn    0     3     0                    0   
  6     Once           0     11    0                    0   
  7     Null           0     4     4                    0   
  8     Integer        1     5     0                    0   
  9     Integer        1     4     0                    0   
  10    DecrJumpZero   5     11    0                    0   
  11    Return         3     6     1                    0   
  12    Ne             4     16    1     BINARY-8       81  
  13    Column         0     0     6                    0   
  14    Column         0     1     7                    0   
  15    ResultRow      6     2     0                    0   
  16    Next           0     3     0                    1   
  17    Halt           0     0     0                    0   
  18    Transaction    0     0     9     0              1   
  19    Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 18 0 0 0,  -- 0: Init
  .openRead 0 3 0 2 0,  -- 1: OpenRead
  .rewind 0 17 0 0 0,  -- 2: Rewind
  .column 0 0 1 0 0,  -- 3: Column
  .isNull 1 16 0 0 0,  -- 4: IsNull
  .beginSubrtn 0 3 0 0 0,  -- 5: BeginSubrtn
  .once 0 11 0 0 0,  -- 6: Once
  .null 0 4 4 0 0,  -- 7: Null
  .integer 1 5 0 0 0,  -- 8: Integer
  .integer 1 4 0 0 0,  -- 9: Integer
  .decrJumpZero 5 11 0 0 0,  -- 10: DecrJumpZero
  .return 3 6 1 0 0,  -- 11: Return
  .ne 4 16 1 "BINARY-8" 81,  -- 12: Ne
  .column 0 0 6 0 0,  -- 13: Column
  .column 0 1 7 0 0,  -- 14: Column
  .resultRow 6 2 0 0 0,  -- 15: ResultRow
  .next 0 3 0 0 1,  -- 16: Next
  .halt 0 0 0 0 0,  -- 17: Halt
  .transaction 0 0 9 0 1,  -- 18: Transaction
  .goto 0 1 0 0 0  -- 19: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000128
