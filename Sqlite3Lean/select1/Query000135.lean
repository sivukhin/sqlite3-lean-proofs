import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000135

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=1 db=0 mode=read name=

  Query: SELECT * FROM sqlite_master WHERE rowid=10;

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     11    0                    0   
  1     OpenRead       0     1     0     5              0   
  2     Integer        10    1     0                    0   
  3     SeekRowid      0     10    1                    0   
  4     Column         0     0     2                    0   
  5     Column         0     1     3                    0   
  6     Column         0     2     4                    0   
  7     Column         0     3     5                    0   
  8     Column         0     4     6                    0   
  9     ResultRow      2     5     0                    0   
  10    Halt           0     0     0                    0   
  11    Transaction    0     0     18    0              1   
  12    Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 11 0 "" 0,  -- 0: Init
  vdbeOpenRead 0 1 0 "5" 0,  -- 1: OpenRead
  vdbeInteger 10 1 0 "" 0,  -- 2: Integer
  vdbeSeekRowid 0 10 1 "" 0,  -- 3: SeekRowid
  vdbeColumn 0 0 2 "" 0,  -- 4: Column
  vdbeColumn 0 1 3 "" 0,  -- 5: Column
  vdbeColumn 0 2 4 "" 0,  -- 6: Column
  vdbeColumn 0 3 5 "" 0,  -- 7: Column
  vdbeColumn 0 4 6 "" 0,  -- 8: Column
  vdbeResultRow 2 5 0 "" 0,  -- 9: ResultRow
  vdbeHalt 0 0 0 "" 0,  -- 10: Halt
  vdbeTransaction 0 0 18 "0" 1,  -- 11: Transaction
  vdbeGoto 0 1 0 "" 0  -- 12: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000135
