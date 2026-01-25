import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000010

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=
    cursor=1 rootpage=3 db=0 mode=read name=

  Query: SELECT *, 'hi' FROM test1, test2

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     16    0                    0   
  1     OpenRead       0     2     0     2              0   
  2     OpenRead       1     3     0     2              0   
  3     Rewind         0     15    0                    0   
  4     Rewind         1     15    0                    0   
  5     Column         0     0     1                    0   
  6     Column         0     1     2                    0   
  7     Column         1     0     3                    0   
  8     RealAffinity   3     0     0                    0   
  9     Column         1     1     4                    0   
  10    RealAffinity   4     0     0                    0   
  11    String8        0     5     0     hi             0   
  12    ResultRow      1     5     0                    0   
  13    Next           1     5     0                    1   
  14    Next           0     4     0                    1   
  15    Halt           0     0     0                    0   
  16    Transaction    0     0     2     0              1   
  17    Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 16 0 "" 0,  -- 0: Init
  vdbeOpenRead 0 2 0 "2" 0,  -- 1: OpenRead
  vdbeOpenRead 1 3 0 "2" 0,  -- 2: OpenRead
  vdbeRewind 0 15 0 "" 0,  -- 3: Rewind
  vdbeRewind 1 15 0 "" 0,  -- 4: Rewind
  vdbeColumn 0 0 1 "" 0,  -- 5: Column
  vdbeColumn 0 1 2 "" 0,  -- 6: Column
  vdbeColumn 1 0 3 "" 0,  -- 7: Column
  vdbeRealAffinity 3 0 0 "" 0,  -- 8: RealAffinity
  vdbeColumn 1 1 4 "" 0,  -- 9: Column
  vdbeRealAffinity 4 0 0 "" 0,  -- 10: RealAffinity
  vdbeString8 0 5 0 "hi" 0,  -- 11: String8
  vdbeResultRow 1 5 0 "" 0,  -- 12: ResultRow
  vdbeNext 1 5 0 "" 1,  -- 13: Next
  vdbeNext 0 4 0 "" 1,  -- 14: Next
  vdbeHalt 0 0 0 "" 0,  -- 15: Halt
  vdbeTransaction 0 0 2 "0" 1,  -- 16: Transaction
  vdbeGoto 0 1 0 "" 0  -- 17: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000010
