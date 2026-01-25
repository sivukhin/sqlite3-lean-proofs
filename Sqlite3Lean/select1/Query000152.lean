import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000152

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
  vdbeInit 0 27 0 "" 0,  -- 0: Init
  vdbeNull 0 1 3 "" 0,  -- 1: Null
  vdbeOpenRead 0 2 0 "1" 0,  -- 2: OpenRead
  vdbeRewind 0 19 0 "" 0,  -- 3: Rewind
  vdbeBeginSubrtn 0 5 0 "" 0,  -- 4: BeginSubrtn
  vdbeOnce 0 10 0 "" 0,  -- 5: Once
  vdbeNull 0 6 6 "" 0,  -- 6: Null
  vdbeInteger 1 7 0 "" 0,  -- 7: Integer
  vdbeInteger 123 6 0 "" 0,  -- 8: Integer
  vdbeDecrJumpZero 7 10 0 "" 0,  -- 9: DecrJumpZero
  vdbeReturn 5 5 1 "" 0,  -- 10: Return
  vdbeCopy 6 4 0 "" 0,  -- 11: Copy
  vdbeCollSeq 8 0 0 "BINARY-8" 0,  -- 12: CollSeq
  vdbeAggStep 0 4 2 "max(1)" 1,  -- 13: AggStep
  vdbeRowid 0 4 0 "" 0,  -- 14: Rowid
  vdbeAggStep 0 4 3 "count(1)" 1,  -- 15: AggStep
  vdbeIf 8 18 0 "" 0,  -- 16: If
  vdbeRowid 0 1 0 "" 0,  -- 17: Rowid
  vdbeNext 0 4 0 "" 1,  -- 18: Next
  vdbeAggFinal 2 1 0 "max(1)" 0,  -- 19: AggFinal
  vdbeAggFinal 3 1 0 "count(1)" 0,  -- 20: AggFinal
  vdbeScopy 1 9 0 "" 0,  -- 21: SCopy
  vdbeNotNull 9 24 0 "" 0,  -- 22: NotNull
  vdbeCopy 2 9 0 "" 1,  -- 23: Copy
  vdbeCopy 3 10 0 "" 0,  -- 24: Copy
  vdbeResultRow 9 2 0 "" 0,  -- 25: ResultRow
  vdbeHalt 0 0 0 "" 0,  -- 26: Halt
  vdbeTransaction 0 0 1 "0" 1,  -- 27: Transaction
  vdbeGoto 0 1 0 "" 0  -- 28: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000152
