import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000102

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
  vdbeInit 0 21 0 "" 0,  -- 0: Init
  vdbeOpenRead 0 2 0 "2" 0,  -- 1: OpenRead
  vdbeRewind 0 20 0 "" 0,  -- 2: Rewind
  vdbeColumn 0 0 1 "" 0,  -- 3: Column
  vdbeIsNull 1 19 0 "" 0,  -- 4: IsNull
  vdbeBeginSubrtn 0 3 0 "" 0,  -- 5: BeginSubrtn
  vdbeOnce 0 14 0 "" 0,  -- 6: Once
  vdbeNull 0 4 4 "" 0,  -- 7: Null
  vdbeInteger 1 5 0 "" 0,  -- 8: Integer
  vdbeOpenRead 2 8 0 "1" 0,  -- 9: OpenRead
  vdbeCount 2 6 0 "" 0,  -- 10: Count
  vdbeClose 2 0 0 "" 0,  -- 11: Close
  vdbeCopy 6 4 0 "" 0,  -- 12: Copy
  vdbeDecrJumpZero 5 14 0 "" 0,  -- 13: DecrJumpZero
  vdbeReturn 3 6 1 "" 0,  -- 14: Return
  vdbeGe 4 19 1 "BINARY-8" 84,  -- 15: Ge
  vdbeColumn 0 0 7 "" 0,  -- 16: Column
  vdbeColumn 0 1 8 "" 0,  -- 17: Column
  vdbeResultRow 7 2 0 "" 0,  -- 18: ResultRow
  vdbeNext 0 3 0 "" 1,  -- 19: Next
  vdbeHalt 0 0 0 "" 0,  -- 20: Halt
  vdbeTransaction 0 0 9 "0" 1,  -- 21: Transaction
  vdbeGoto 0 1 0 "" 0  -- 22: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000102
