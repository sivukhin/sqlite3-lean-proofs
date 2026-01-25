import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000022

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=

  Query: SELECT COUNT(*)+1 FROM test1

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     10    0                    0   
  1     Null           0     1     1                    0   
  2     OpenRead       0     2     0     0              0   
  3     Rewind         0     6     0                    0   
  4     AggStep        0     0     1     count(0)       0   
  5     Next           0     4     0                    1   
  6     AggFinal       1     0     0     count(0)       0   
  7     Add            4     1     2                    0   
  8     ResultRow      2     1     0                    0   
  9     Halt           0     0     0                    0   
  10    Transaction    0     0     5     0              1   
  11    Integer        1     4     0                    0   
  12    Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 10 0 "" 0,  -- 0: Init
  vdbeNull 0 1 1 "" 0,  -- 1: Null
  vdbeOpenRead 0 2 0 "0" 0,  -- 2: OpenRead
  vdbeRewind 0 6 0 "" 0,  -- 3: Rewind
  vdbeAggStep 0 0 1 "count(0)" 0,  -- 4: AggStep
  vdbeNext 0 4 0 "" 1,  -- 5: Next
  vdbeAggFinal 1 0 0 "count(0)" 0,  -- 6: AggFinal
  vdbeAdd 4 1 2 "" 0,  -- 7: Add
  vdbeResultRow 2 1 0 "" 0,  -- 8: ResultRow
  vdbeHalt 0 0 0 "" 0,  -- 9: Halt
  vdbeTransaction 0 0 5 "0" 1,  -- 10: Transaction
  vdbeInteger 1 4 0 "" 0,  -- 11: Integer
  vdbeGoto 0 1 0 "" 0  -- 12: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000022
