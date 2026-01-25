import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000006

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=

  Query: SELECT *, * FROM test1

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     10    0                    0   
  1     OpenRead       0     2     0     2              0   
  2     Rewind         0     9     0                    0   
  3     Column         0     0     1                    0   
  4     Column         0     1     2                    0   
  5     Column         0     0     3                    0   
  6     Column         0     1     4                    0   
  7     ResultRow      1     4     0                    0   
  8     Next           0     3     0                    1   
  9     Halt           0     0     0                    0   
  10    Transaction    0     0     1     0              1   
  11    Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 10 0 "" 0,  -- 0: Init
  vdbeOpenRead 0 2 0 "2" 0,  -- 1: OpenRead
  vdbeRewind 0 9 0 "" 0,  -- 2: Rewind
  vdbeColumn 0 0 1 "" 0,  -- 3: Column
  vdbeColumn 0 1 2 "" 0,  -- 4: Column
  vdbeColumn 0 0 3 "" 0,  -- 5: Column
  vdbeColumn 0 1 4 "" 0,  -- 6: Column
  vdbeResultRow 1 4 0 "" 0,  -- 7: ResultRow
  vdbeNext 0 3 0 "" 1,  -- 8: Next
  vdbeHalt 0 0 0 "" 0,  -- 9: Halt
  vdbeTransaction 0 0 1 "0" 1,  -- 10: Transaction
  vdbeGoto 0 1 0 "" 0  -- 11: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000006
