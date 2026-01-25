import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000082

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=

  Query: SELECT * FROM test1 a, (select 5, 6) LIMIT 1
    

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     20    0                    0   
  1     InitCoroutine  1     6     2                    0   
  2     Integer        5     2     0                    0   
  3     Integer        6     3     0                    0   
  4     Yield          1     0     0                    0   
  5     EndCoroutine   1     0     0                    0   
  6     Integer        1     4     0                    0   
  7     OpenRead       0     2     0     2              0   
  8     InitCoroutine  1     0     2                    0   
  9     Yield          1     19    0                    0   
  10    Rewind         0     19    0                    0   
  11    Column         0     0     5                    0   
  12    Column         0     1     6                    0   
  13    Copy           2     7     0                    2   
  14    Copy           3     8     0                    2   
  15    ResultRow      5     4     0                    0   
  16    DecrJumpZero   4     19    0                    0   
  17    Next           0     11    0                    1   
  18    Goto           0     9     0                    0   
  19    Halt           0     0     0                    0   
  20    Transaction    0     0     8     0              1   
  21    Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 20 0 "" 0,  -- 0: Init
  vdbeInitCoroutine 1 6 2 "" 0,  -- 1: InitCoroutine
  vdbeInteger 5 2 0 "" 0,  -- 2: Integer
  vdbeInteger 6 3 0 "" 0,  -- 3: Integer
  vdbeYield 1 0 0 "" 0,  -- 4: Yield
  vdbeEndCoroutine 1 0 0 "" 0,  -- 5: EndCoroutine
  vdbeInteger 1 4 0 "" 0,  -- 6: Integer
  vdbeOpenRead 0 2 0 "2" 0,  -- 7: OpenRead
  vdbeInitCoroutine 1 0 2 "" 0,  -- 8: InitCoroutine
  vdbeYield 1 19 0 "" 0,  -- 9: Yield
  vdbeRewind 0 19 0 "" 0,  -- 10: Rewind
  vdbeColumn 0 0 5 "" 0,  -- 11: Column
  vdbeColumn 0 1 6 "" 0,  -- 12: Column
  vdbeCopy 2 7 0 "" 2,  -- 13: Copy
  vdbeCopy 3 8 0 "" 2,  -- 14: Copy
  vdbeResultRow 5 4 0 "" 0,  -- 15: ResultRow
  vdbeDecrJumpZero 4 19 0 "" 0,  -- 16: DecrJumpZero
  vdbeNext 0 11 0 "" 1,  -- 17: Next
  vdbeGoto 0 9 0 "" 0,  -- 18: Goto
  vdbeHalt 0 0 0 "" 0,  -- 19: Halt
  vdbeTransaction 0 0 8 "0" 1,  -- 20: Transaction
  vdbeGoto 0 1 0 "" 0  -- 21: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000082
