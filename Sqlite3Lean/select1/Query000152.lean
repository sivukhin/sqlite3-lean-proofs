import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000152

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=

  Query: SELECT ifnull(a, max((SELECT 123))), count(a) FROM t1 ;

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     27    0                    0   
  1     Null           0     1     3                    0   
  2     OpenRead       0     2     0     1              0   
  3     Rewind         0     19    0                    0   
  4     BeginSubrtn    0     5     0                    0   
  5     Once           0     10    0                    0   
  6     Null           0     6     6                    0   
  7     Integer        1     7     0                    0   
  8     Integer        123   6     0                    0   
  9     DecrJumpZero   7     10    0                    0   
  10    Return         5     5     1                    0   
  11    Copy           6     4     0                    0   
  12    CollSeq        8     0     0     BINARY-8       0   
  13    AggStep        0     4     2     max(1)         1   
  14    Rowid          0     4     0                    0   
  15    AggStep        0     4     3     count(1)       1   
  16    If             8     18    0                    0   
  17    Rowid          0     1     0                    0   
  18    Next           0     4     0                    1   
  19    AggFinal       2     1     0     max(1)         0   
  20    AggFinal       3     1     0     count(1)       0   
  21    SCopy          1     9     0                    0   
  22    NotNull        9     24    0                    0   
  23    Copy           2     9     0                    1   
  24    Copy           3     10    0                    0   
  25    ResultRow      9     2     0                    0   
  26    Halt           0     0     0                    0   
  27    Transaction    0     0     1     0              1   
  28    Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 27 0 0 0,  -- 0: Init
  .null 0 1 3 0 0,  -- 1: Null
  .openRead 0 2 0 1 0,  -- 2: OpenRead
  .rewind 0 19 0 0 0,  -- 3: Rewind
  .beginSubrtn 0 5 0 0 0,  -- 4: BeginSubrtn
  .once 0 10 0 0 0,  -- 5: Once
  .null 0 6 6 0 0,  -- 6: Null
  .integer 1 7 0 0 0,  -- 7: Integer
  .integer 123 6 0 0 0,  -- 8: Integer
  .decrJumpZero 7 10 0 0 0,  -- 9: DecrJumpZero
  .return 5 5 1 0 0,  -- 10: Return
  .copy 6 4 0 0 0,  -- 11: Copy
  .collSeq 8 0 0 "BINARY-8" 0,  -- 12: CollSeq
  .aggStep 0 4 2 "max(1)" 1,  -- 13: AggStep
  .rowid 0 4 0 0 0,  -- 14: Rowid
  .aggStep 0 4 3 "count(1)" 1,  -- 15: AggStep
  .if 8 18 0 0 0,  -- 16: If
  .rowid 0 1 0 0 0,  -- 17: Rowid
  .next 0 4 0 0 1,  -- 18: Next
  .aggFinal 2 1 0 "max(1)" 0,  -- 19: AggFinal
  .aggFinal 3 1 0 "count(1)" 0,  -- 20: AggFinal
  .scopy 1 9 0 0 0,  -- 21: SCopy
  .notNull 9 24 0 0 0,  -- 22: NotNull
  .copy 2 9 0 0 1,  -- 23: Copy
  .copy 3 10 0 0 0,  -- 24: Copy
  .resultRow 9 2 0 0 0,  -- 25: ResultRow
  .halt 0 0 0 0 0,  -- 26: Halt
  .transaction 0 0 1 0 1,  -- 27: Transaction
  .goto 0 1 0 0 0  -- 28: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000152
