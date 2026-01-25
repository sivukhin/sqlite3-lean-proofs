import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000041

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=

  Query: SELECT f1 FROM test1 WHERE f1<11

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     9     0                    0   
  1     OpenRead       0     2     0     1              0   
  2     Rewind         0     8     0                    0   
  3     Column         0     0     1                    0   
  4     Ge             2     7     1     BINARY-8       84  
  5     Column         0     0     3                    0   
  6     ResultRow      3     1     0                    0   
  7     Next           0     3     0                    1   
  8     Halt           0     0     0                    0   
  9     Transaction    0     0     6     0              1   
  10    Integer        11    2     0                    0   
  11    Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 9 0 "" 0,  -- 0: Init
  vdbeOpenRead 0 2 0 "1" 0,  -- 1: OpenRead
  vdbeRewind 0 8 0 "" 0,  -- 2: Rewind
  vdbeColumn 0 0 1 "" 0,  -- 3: Column
  vdbeGe 2 7 1 "BINARY-8" 84,  -- 4: Ge
  vdbeColumn 0 0 3 "" 0,  -- 5: Column
  vdbeResultRow 3 1 0 "" 0,  -- 6: ResultRow
  vdbeNext 0 3 0 "" 1,  -- 7: Next
  vdbeHalt 0 0 0 "" 0,  -- 8: Halt
  vdbeTransaction 0 0 6 "0" 1,  -- 9: Transaction
  vdbeInteger 11 2 0 "" 0,  -- 10: Integer
  vdbeGoto 0 1 0 "" 0  -- 11: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000041
