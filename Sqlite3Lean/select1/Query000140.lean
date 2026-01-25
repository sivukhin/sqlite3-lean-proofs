import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000140

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=1 rootpage=1 db=0 mode=read name=

  Query: SELECT 10 IN (SELECT rowid FROM sqlite_master);

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     15    0                    0   
  1     Null           0     1     0                    0   
  2     Once           0     4     0                    0   
  3     OpenRead       1     1     0     5              0   
  4     Integer        10    2     0                    0   
  5     SeekRowid      1     12    2                    0   
  6     Goto           0     11    0                    0   
  7     Rewind         1     12    0                    0   
  8     Column         1     0     3                    0   
  9     Ne             2     12    3                    0   
  10    Goto           0     13    0                    0   
  11    Integer        1     1     0                    0   
  12    AddImm         1     0     0                    0   
  13    ResultRow      1     1     0                    0   
  14    Halt           0     0     0                    0   
  15    Transaction    0     0     18    0              1   
  16    Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 15 0 "" 0,  -- 0: Init
  vdbeNull 0 1 0 "" 0,  -- 1: Null
  vdbeOnce 0 4 0 "" 0,  -- 2: Once
  vdbeOpenRead 1 1 0 "5" 0,  -- 3: OpenRead
  vdbeInteger 10 2 0 "" 0,  -- 4: Integer
  vdbeSeekRowid 1 12 2 "" 0,  -- 5: SeekRowid
  vdbeGoto 0 11 0 "" 0,  -- 6: Goto
  vdbeRewind 1 12 0 "" 0,  -- 7: Rewind
  vdbeColumn 1 0 3 "" 0,  -- 8: Column
  vdbeNe 2 12 3 "" 0,  -- 9: Ne
  vdbeGoto 0 13 0 "" 0,  -- 10: Goto
  vdbeInteger 1 1 0 "" 0,  -- 11: Integer
  vdbeAddImm 1 0 0 "" 0,  -- 12: AddImm
  vdbeResultRow 1 1 0 "" 0,  -- 13: ResultRow
  vdbeHalt 0 0 0 "" 0,  -- 14: Halt
  vdbeTransaction 0 0 18 "0" 1,  -- 15: Transaction
  vdbeGoto 0 1 0 "" 0  -- 16: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000140
