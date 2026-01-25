import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000141

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=1 rootpage=4 db=0 mode=read name=

  Query: SELECT 2 IN (SELECT a FROM t1) 

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     19    0                    0   
  1     Null           0     1     0                    0   
  2     Once           0     7     0                    0   
  3     OpenRead       1     4     0     k(2,,)         0   
  4     Integer        0     2     0                    0   
  5     Rewind         1     7     0                    0   
  6     Column         1     0     2                    128  
  7     Integer        2     3     0                    0   
  8     Affinity       3     1     0     A              0   
  9     Found          1     15    3     1              0   
  10    NotNull        2     16    0                    0   
  11    Rewind         1     16    0                    0   
  12    Column         1     0     4                    0   
  13    Ne             3     16    4                    0   
  14    Goto           0     17    0                    0   
  15    Integer        1     1     0                    0   
  16    AddImm         1     0     0                    0   
  17    ResultRow      1     1     0                    0   
  18    Halt           0     0     0                    0   
  19    Transaction    0     0     20    0              1   
  20    Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 19 0 "" 0,  -- 0: Init
  vdbeNull 0 1 0 "" 0,  -- 1: Null
  vdbeOnce 0 7 0 "" 0,  -- 2: Once
  vdbeOpenRead 1 4 0 "k(2,,)" 0,  -- 3: OpenRead
  vdbeInteger 0 2 0 "" 0,  -- 4: Integer
  vdbeRewind 1 7 0 "" 0,  -- 5: Rewind
  vdbeColumn 1 0 2 "" 128,  -- 6: Column
  vdbeInteger 2 3 0 "" 0,  -- 7: Integer
  vdbeAffinity 3 1 0 "A" 0,  -- 8: Affinity
  vdbeFound 1 15 3 "1" 0,  -- 9: Found
  vdbeNotNull 2 16 0 "" 0,  -- 10: NotNull
  vdbeRewind 1 16 0 "" 0,  -- 11: Rewind
  vdbeColumn 1 0 4 "" 0,  -- 12: Column
  vdbeNe 3 16 4 "" 0,  -- 13: Ne
  vdbeGoto 0 17 0 "" 0,  -- 14: Goto
  vdbeInteger 1 1 0 "" 0,  -- 15: Integer
  vdbeAddImm 1 0 0 "" 0,  -- 16: AddImm
  vdbeResultRow 1 1 0 "" 0,  -- 17: ResultRow
  vdbeHalt 0 0 0 "" 0,  -- 18: Halt
  vdbeTransaction 0 0 20 "0" 1,  -- 19: Transaction
  vdbeGoto 0 1 0 "" 0  -- 20: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000141
