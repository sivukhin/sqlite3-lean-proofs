import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000025

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=4 db=0 mode=read name=

  Query: SELECT count(*),count(a),count(b) FROM t4 WHERE b=5

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     18    0                    0   
  1     Null           0     1     5                    0   
  2     OpenRead       0     4     0     2              0   
  3     Rewind         0     12    0                    0   
  4     Column         0     1     6                    0   
  5     Ne             7     11    6     BINARY-8       81  
  6     AggStep        0     0     3     count(0)       0   
  7     Column         0     0     6                    0   
  8     AggStep        0     6     4     count(1)       1   
  9     Column         0     1     6                    0   
  10    AggStep        0     6     5     count(1)       1   
  11    Next           0     4     0                    1   
  12    AggFinal       3     0     0     count(0)       0   
  13    AggFinal       4     1     0     count(1)       0   
  14    AggFinal       5     1     0     count(1)       0   
  15    Copy           3     8     2                    0   
  16    ResultRow      8     3     0                    0   
  17    Halt           0     0     0                    0   
  18    Transaction    0     0     5     0              1   
  19    Integer        5     7     0                    0   
  20    Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 18 0 "" 0,  -- 0: Init
  vdbeNull 0 1 5 "" 0,  -- 1: Null
  vdbeOpenRead 0 4 0 "2" 0,  -- 2: OpenRead
  vdbeRewind 0 12 0 "" 0,  -- 3: Rewind
  vdbeColumn 0 1 6 "" 0,  -- 4: Column
  vdbeNe 7 11 6 "BINARY-8" 81,  -- 5: Ne
  vdbeAggStep 0 0 3 "count(0)" 0,  -- 6: AggStep
  vdbeColumn 0 0 6 "" 0,  -- 7: Column
  vdbeAggStep 0 6 4 "count(1)" 1,  -- 8: AggStep
  vdbeColumn 0 1 6 "" 0,  -- 9: Column
  vdbeAggStep 0 6 5 "count(1)" 1,  -- 10: AggStep
  vdbeNext 0 4 0 "" 1,  -- 11: Next
  vdbeAggFinal 3 0 0 "count(0)" 0,  -- 12: AggFinal
  vdbeAggFinal 4 1 0 "count(1)" 0,  -- 13: AggFinal
  vdbeAggFinal 5 1 0 "count(1)" 0,  -- 14: AggFinal
  vdbeCopy 3 8 2 "" 0,  -- 15: Copy
  vdbeResultRow 8 3 0 "" 0,  -- 16: ResultRow
  vdbeHalt 0 0 0 "" 0,  -- 17: Halt
  vdbeTransaction 0 0 5 "0" 1,  -- 18: Transaction
  vdbeInteger 5 7 0 "" 0,  -- 19: Integer
  vdbeGoto 0 1 0 "" 0  -- 20: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000025
