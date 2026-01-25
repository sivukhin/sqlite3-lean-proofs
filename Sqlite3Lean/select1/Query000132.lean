import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000132

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=10 db=0 mode=read name=
    cursor=2 rootpage=11 db=0 mode=read name=

  Query: SELECT count(
          (SELECT a FROM abc WHERE a = NULL AND b >= upper.c) 
        ) FROM abc AS upper;

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     25    0                    0   
  1     Null           0     1     2                    0   
  2     OpenRead       0     10    0     3              0   
  3     Rewind         0     21    0                    0   
  4     BeginSubrtn    0     4     0                    0   
  5     Null           0     5     5                    0   
  6     Integer        1     6     0                    0   
  7     OpenRead       2     11    0     k(3,,,)        0   
  8     Null           0     7     0                    0   
  9     IsNull         7     17    0                    0   
  10    Column         0     2     8                    0   
  11    IsNull         8     17    0                    0   
  12    SeekGE         2     17    7     2              0   
  13    IdxGT          2     17    7     1              0   
  14    Column         2     0     5                    0   
  15    DecrJumpZero   6     17    0                    0   
  16    Next           2     13    0                    0   
  17    Return         4     5     1                    0   
  18    Copy           5     3     0                    0   
  19    AggStep        0     3     2     count(1)       1   
  20    Next           0     4     0                    1   
  21    AggFinal       2     1     0     count(1)       0   
  22    Copy           2     9     0                    0   
  23    ResultRow      9     1     0                    0   
  24    Halt           0     0     0                    0   
  25    Transaction    0     0     10    0              1   
  26    Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 25 0 "" 0,  -- 0: Init
  vdbeNull 0 1 2 "" 0,  -- 1: Null
  vdbeOpenRead 0 10 0 "3" 0,  -- 2: OpenRead
  vdbeRewind 0 21 0 "" 0,  -- 3: Rewind
  vdbeBeginSubrtn 0 4 0 "" 0,  -- 4: BeginSubrtn
  vdbeNull 0 5 5 "" 0,  -- 5: Null
  vdbeInteger 1 6 0 "" 0,  -- 6: Integer
  vdbeOpenRead 2 11 0 "k(3,,,)" 0,  -- 7: OpenRead
  vdbeNull 0 7 0 "" 0,  -- 8: Null
  vdbeIsNull 7 17 0 "" 0,  -- 9: IsNull
  vdbeColumn 0 2 8 "" 0,  -- 10: Column
  vdbeIsNull 8 17 0 "" 0,  -- 11: IsNull
  vdbeSeekGE 2 17 7 "2" 0,  -- 12: SeekGE
  vdbeIdxGT 2 17 7 "1" 0,  -- 13: IdxGT
  vdbeColumn 2 0 5 "" 0,  -- 14: Column
  vdbeDecrJumpZero 6 17 0 "" 0,  -- 15: DecrJumpZero
  vdbeNext 2 13 0 "" 0,  -- 16: Next
  vdbeReturn 4 5 1 "" 0,  -- 17: Return
  vdbeCopy 5 3 0 "" 0,  -- 18: Copy
  vdbeAggStep 0 3 2 "count(1)" 1,  -- 19: AggStep
  vdbeNext 0 4 0 "" 1,  -- 20: Next
  vdbeAggFinal 2 1 0 "count(1)" 0,  -- 21: AggFinal
  vdbeCopy 2 9 0 "" 0,  -- 22: Copy
  vdbeResultRow 9 1 0 "" 0,  -- 23: ResultRow
  vdbeHalt 0 0 0 "" 0,  -- 24: Halt
  vdbeTransaction 0 0 10 "0" 1,  -- 25: Transaction
  vdbeGoto 0 1 0 "" 0  -- 26: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000132
