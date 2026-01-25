import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000065

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=

  Query: SELECT DISTINCT * FROM test1 WHERE f1==11

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     14    0                    0   
  1     OpenEphemeral  1     0     0     k(2,B,B)       8   
  2     OpenRead       0     2     0     2              0   
  3     Rewind         0     13    0                    0   
  4     Column         0     0     1                    0   
  5     Ne             2     12    1     BINARY-8       84  
  6     Column         0     0     3                    0   
  7     Column         0     1     4                    0   
  8     Found          1     12    3     2              0   
  9     MakeRecord     3     2     1                    0   
  10    IdxInsert      1     1     3     2              16  
  11    ResultRow      3     2     0                    0   
  12    Next           0     4     0                    1   
  13    Halt           0     0     0                    0   
  14    Transaction    0     0     8     0              1   
  15    Integer        11    2     0                    0   
  16    Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 14 0 "" 0,  -- 0: Init
  vdbeOpenEphemeral 1 0 0 "k(2,B,B)" 8,  -- 1: OpenEphemeral
  vdbeOpenRead 0 2 0 "2" 0,  -- 2: OpenRead
  vdbeRewind 0 13 0 "" 0,  -- 3: Rewind
  vdbeColumn 0 0 1 "" 0,  -- 4: Column
  vdbeNe 2 12 1 "BINARY-8" 84,  -- 5: Ne
  vdbeColumn 0 0 3 "" 0,  -- 6: Column
  vdbeColumn 0 1 4 "" 0,  -- 7: Column
  vdbeFound 1 12 3 "2" 0,  -- 8: Found
  vdbeMakeRecord 3 2 1 "" 0,  -- 9: MakeRecord
  vdbeIdxInsert 1 1 3 "2" 16,  -- 10: IdxInsert
  vdbeResultRow 3 2 0 "" 0,  -- 11: ResultRow
  vdbeNext 0 4 0 "" 1,  -- 12: Next
  vdbeHalt 0 0 0 "" 0,  -- 13: Halt
  vdbeTransaction 0 0 8 "0" 1,  -- 14: Transaction
  vdbeInteger 11 2 0 "" 0,  -- 15: Integer
  vdbeGoto 0 1 0 "" 0  -- 16: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000065
