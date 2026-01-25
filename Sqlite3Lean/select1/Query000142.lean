import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000142

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=3 db=0 mode=read name=

  Query: SELECT 2 IN (SELECT a FROM t1) 

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     30    0                    0   
  1     Null           0     1     0                    0   
  2     BeginSubrtn    0     3     0     subrtnsig:1,A  0   
  3     Once           0     14    4                    0   
  4     OpenEphemeral  1     1     0     k(1,B)         0   
  5     Blob           10000  4     0                    0   
  6     OpenRead       0     3     0     1              0   
  7     Rewind         0     13    0                    0   
  8     Column         0     0     5                    0   
  9     MakeRecord     5     1     6     A              0   
  10    IdxInsert      1     6     5     1              0   
  11    FilterAdd      4     0     5     1              0   
  12    Next           0     8     0                    1   
  13    NullRow        1     0     0                    0   
  14    Return         3     3     1                    0   
  15    Integer        0     2     0                    0   
  16    Rewind         1     18    0                    0   
  17    Column         1     0     2                    128  
  18    Integer        2     7     0                    0   
  19    Affinity       7     1     0     A              0   
  20    Found          1     26    7     1              0   
  21    NotNull        2     27    0                    0   
  22    Rewind         1     27    0                    0   
  23    Column         1     0     8                    0   
  24    Ne             7     27    8                    0   
  25    Goto           0     28    0                    0   
  26    Integer        1     1     0                    0   
  27    AddImm         1     0     0                    0   
  28    ResultRow      1     1     0                    0   
  29    Halt           0     0     0                    0   
  30    Transaction    0     0     21    1              1   
  31    Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 30 0 "" 0,  -- 0: Init
  vdbeNull 0 1 0 "" 0,  -- 1: Null
  vdbeBeginSubrtn 0 3 0 "subrtnsig:1,A" 0,  -- 2: BeginSubrtn
  vdbeOnce 0 14 4 "" 0,  -- 3: Once
  vdbeOpenEphemeral 1 1 0 "k(1,B)" 0,  -- 4: OpenEphemeral
  vdbeBlob 10000 4 0 "" 0,  -- 5: Blob
  vdbeOpenRead 0 3 0 "1" 0,  -- 6: OpenRead
  vdbeRewind 0 13 0 "" 0,  -- 7: Rewind
  vdbeColumn 0 0 5 "" 0,  -- 8: Column
  vdbeMakeRecord 5 1 6 "A" 0,  -- 9: MakeRecord
  vdbeIdxInsert 1 6 5 "1" 0,  -- 10: IdxInsert
  vdbeFilterAdd 4 0 5 "1" 0,  -- 11: FilterAdd
  vdbeNext 0 8 0 "" 1,  -- 12: Next
  vdbeNullRow 1 0 0 "" 0,  -- 13: NullRow
  vdbeReturn 3 3 1 "" 0,  -- 14: Return
  vdbeInteger 0 2 0 "" 0,  -- 15: Integer
  vdbeRewind 1 18 0 "" 0,  -- 16: Rewind
  vdbeColumn 1 0 2 "" 128,  -- 17: Column
  vdbeInteger 2 7 0 "" 0,  -- 18: Integer
  vdbeAffinity 7 1 0 "A" 0,  -- 19: Affinity
  vdbeFound 1 26 7 "1" 0,  -- 20: Found
  vdbeNotNull 2 27 0 "" 0,  -- 21: NotNull
  vdbeRewind 1 27 0 "" 0,  -- 22: Rewind
  vdbeColumn 1 0 8 "" 0,  -- 23: Column
  vdbeNe 7 27 8 "" 0,  -- 24: Ne
  vdbeGoto 0 28 0 "" 0,  -- 25: Goto
  vdbeInteger 1 1 0 "" 0,  -- 26: Integer
  vdbeAddImm 1 0 0 "" 0,  -- 27: AddImm
  vdbeResultRow 1 1 0 "" 0,  -- 28: ResultRow
  vdbeHalt 0 0 0 "" 0,  -- 29: Halt
  vdbeTransaction 0 0 21 "1" 1,  -- 30: Transaction
  vdbeGoto 0 1 0 "" 0  -- 31: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000142
