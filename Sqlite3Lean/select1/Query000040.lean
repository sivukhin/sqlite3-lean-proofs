import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000040

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=

  Query: SELECT SUM(min(f1,f2)) FROM test1

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     14    0                    0   
  1     Null           0     1     3                    0   
  2     OpenRead       0     2     0     2              0   
  3     Rewind         0     10    0                    0   
  4     Column         0     0     5                    0   
  5     Column         0     1     6                    0   
  6     CollSeq        0     0     0     BINARY-8       0   
  7     Function       0     5     4     min(-3)        0   
  8     AggStep        0     4     3     sum(1)         1   
  9     Next           0     4     0                    1   
  10    AggFinal       3     1     0     sum(1)         0   
  11    Copy           3     7     0                    0   
  12    ResultRow      7     1     0                    0   
  13    Halt           0     0     0                    0   
  14    Transaction    0     0     5     0              1   
  15    Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 14 0 "" 0,  -- 0: Init
  vdbeNull 0 1 3 "" 0,  -- 1: Null
  vdbeOpenRead 0 2 0 "2" 0,  -- 2: OpenRead
  vdbeRewind 0 10 0 "" 0,  -- 3: Rewind
  vdbeColumn 0 0 5 "" 0,  -- 4: Column
  vdbeColumn 0 1 6 "" 0,  -- 5: Column
  vdbeCollSeq 0 0 0 "BINARY-8" 0,  -- 6: CollSeq
  vdbeFunction 0 5 4 "min(-3)" 0,  -- 7: Function
  vdbeAggStep 0 4 3 "sum(1)" 1,  -- 8: AggStep
  vdbeNext 0 4 0 "" 1,  -- 9: Next
  vdbeAggFinal 3 1 0 "sum(1)" 0,  -- 10: AggFinal
  vdbeCopy 3 7 0 "" 0,  -- 11: Copy
  vdbeResultRow 7 1 0 "" 0,  -- 12: ResultRow
  vdbeHalt 0 0 0 "" 0,  -- 13: Halt
  vdbeTransaction 0 0 5 "0" 1,  -- 14: Transaction
  vdbeGoto 0 1 0 "" 0  -- 15: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000040
