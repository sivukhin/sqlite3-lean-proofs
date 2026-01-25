import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000127

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=3 db=0 mode=read name=

  Query: SELECT 3, 4 UNION SELECT * FROM t3;

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     20    0                    0   
  1     OpenEphemeral  1     2     0     k(2,B,B)       0   
  2     Integer        3     1     0                    0   
  3     Integer        4     2     0                    0   
  4     MakeRecord     1     2     3                    0   
  5     IdxInsert      1     3     1     2              0   
  6     OpenRead       0     3     0     2              0   
  7     Rewind         0     13    0                    0   
  8     Column         0     0     1                    0   
  9     Column         0     1     2                    0   
  10    MakeRecord     1     2     3                    0   
  11    IdxInsert      1     3     1     2              0   
  12    Next           0     8     0                    1   
  13    Rewind         1     18    0                    0   
  14    Column         1     0     4                    0   
  15    Column         1     1     5                    0   
  16    ResultRow      4     2     0                    0   
  17    Next           1     14    0                    0   
  18    Close          1     0     0                    0   
  19    Halt           0     0     0                    0   
  20    Transaction    0     0     9     0              1   
  21    Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 20 0 "" 0,  -- 0: Init
  vdbeOpenEphemeral 1 2 0 "k(2,B,B)" 0,  -- 1: OpenEphemeral
  vdbeInteger 3 1 0 "" 0,  -- 2: Integer
  vdbeInteger 4 2 0 "" 0,  -- 3: Integer
  vdbeMakeRecord 1 2 3 "" 0,  -- 4: MakeRecord
  vdbeIdxInsert 1 3 1 "2" 0,  -- 5: IdxInsert
  vdbeOpenRead 0 3 0 "2" 0,  -- 6: OpenRead
  vdbeRewind 0 13 0 "" 0,  -- 7: Rewind
  vdbeColumn 0 0 1 "" 0,  -- 8: Column
  vdbeColumn 0 1 2 "" 0,  -- 9: Column
  vdbeMakeRecord 1 2 3 "" 0,  -- 10: MakeRecord
  vdbeIdxInsert 1 3 1 "2" 0,  -- 11: IdxInsert
  vdbeNext 0 8 0 "" 1,  -- 12: Next
  vdbeRewind 1 18 0 "" 0,  -- 13: Rewind
  vdbeColumn 1 0 4 "" 0,  -- 14: Column
  vdbeColumn 1 1 5 "" 0,  -- 15: Column
  vdbeResultRow 4 2 0 "" 0,  -- 16: ResultRow
  vdbeNext 1 14 0 "" 0,  -- 17: Next
  vdbeClose 1 0 0 "" 0,  -- 18: Close
  vdbeHalt 0 0 0 "" 0,  -- 19: Halt
  vdbeTransaction 0 0 9 "0" 1,  -- 20: Transaction
  vdbeGoto 0 1 0 "" 0  -- 21: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000127
