import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000033

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=

  Query: SELECT MAX(f1,f2)+1 FROM test1

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     11    0                    0   
  1     OpenRead       0     2     0     2              0   
  2     Rewind         0     10    0                    0   
  3     Column         0     0     3                    0   
  4     Column         0     1     4                    0   
  5     CollSeq        0     0     0     BINARY-8       0   
  6     Function       0     3     2     max(-3)        0   
  7     Add            5     2     1                    0   
  8     ResultRow      1     1     0                    0   
  9     Next           0     3     0                    1   
  10    Halt           0     0     0                    0   
  11    Transaction    0     0     5     0              1   
  12    Integer        1     5     0                    0   
  13    Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 11 0 "" 0,  -- 0: Init
  vdbeOpenRead 0 2 0 "2" 0,  -- 1: OpenRead
  vdbeRewind 0 10 0 "" 0,  -- 2: Rewind
  vdbeColumn 0 0 3 "" 0,  -- 3: Column
  vdbeColumn 0 1 4 "" 0,  -- 4: Column
  vdbeCollSeq 0 0 0 "BINARY-8" 0,  -- 5: CollSeq
  vdbeFunction 0 3 2 "max(-3)" 0,  -- 6: Function
  vdbeAdd 5 2 1 "" 0,  -- 7: Add
  vdbeResultRow 1 1 0 "" 0,  -- 8: ResultRow
  vdbeNext 0 3 0 "" 1,  -- 9: Next
  vdbeHalt 0 0 0 "" 0,  -- 10: Halt
  vdbeTransaction 0 0 5 "0" 1,  -- 11: Transaction
  vdbeInteger 1 5 0 "" 0,  -- 12: Integer
  vdbeGoto 0 1 0 "" 0  -- 13: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000033
