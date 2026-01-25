import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000129

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=3 db=0 mode=read name=

  Query: SELECT * FROM t3 WHERE a=(SELECT 2);

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
  9     Integer        2     4     0                    0   
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
  vdbeInit 0 18 0 "" 0,  -- 0: Init
  vdbeOpenRead 0 3 0 "2" 0,  -- 1: OpenRead
  vdbeRewind 0 17 0 "" 0,  -- 2: Rewind
  vdbeColumn 0 0 1 "" 0,  -- 3: Column
  vdbeIsNull 1 16 0 "" 0,  -- 4: IsNull
  vdbeBeginSubrtn 0 3 0 "" 0,  -- 5: BeginSubrtn
  vdbeOnce 0 11 0 "" 0,  -- 6: Once
  vdbeNull 0 4 4 "" 0,  -- 7: Null
  vdbeInteger 1 5 0 "" 0,  -- 8: Integer
  vdbeInteger 2 4 0 "" 0,  -- 9: Integer
  vdbeDecrJumpZero 5 11 0 "" 0,  -- 10: DecrJumpZero
  vdbeReturn 3 6 1 "" 0,  -- 11: Return
  vdbeNe 4 16 1 "BINARY-8" 81,  -- 12: Ne
  vdbeColumn 0 0 6 "" 0,  -- 13: Column
  vdbeColumn 0 1 7 "" 0,  -- 14: Column
  vdbeResultRow 6 2 0 "" 0,  -- 15: ResultRow
  vdbeNext 0 3 0 "" 1,  -- 16: Next
  vdbeHalt 0 0 0 "" 0,  -- 17: Halt
  vdbeTransaction 0 0 9 "0" 1,  -- 18: Transaction
  vdbeGoto 0 1 0 "" 0  -- 19: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000129
