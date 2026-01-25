import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000011

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=
    cursor=1 rootpage=3 db=0 mode=read name=

  Query: SELECT 'one', *, 'two', * FROM test1, test2

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     23    0                    0   
  1     OpenRead       0     2     0     2              0   
  2     OpenRead       1     3     0     2              0   
  3     Rewind         0     22    0                    0   
  4     Rewind         1     22    0                    0   
  5     String8        0     1     0     one            0   
  6     Column         0     0     2                    0   
  7     Column         0     1     3                    0   
  8     Column         1     0     4                    0   
  9     RealAffinity   4     0     0                    0   
  10    Column         1     1     5                    0   
  11    RealAffinity   5     0     0                    0   
  12    String8        0     6     0     two            0   
  13    Column         0     0     7                    0   
  14    Column         0     1     8                    0   
  15    Column         1     0     9                    0   
  16    RealAffinity   9     0     0                    0   
  17    Column         1     1     10                   0   
  18    RealAffinity   10    0     0                    0   
  19    ResultRow      1     10    0                    0   
  20    Next           1     5     0                    1   
  21    Next           0     4     0                    1   
  22    Halt           0     0     0                    0   
  23    Transaction    0     0     2     0              1   
  24    Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 23 0 "" 0,  -- 0: Init
  vdbeOpenRead 0 2 0 "2" 0,  -- 1: OpenRead
  vdbeOpenRead 1 3 0 "2" 0,  -- 2: OpenRead
  vdbeRewind 0 22 0 "" 0,  -- 3: Rewind
  vdbeRewind 1 22 0 "" 0,  -- 4: Rewind
  vdbeString8 0 1 0 "one" 0,  -- 5: String8
  vdbeColumn 0 0 2 "" 0,  -- 6: Column
  vdbeColumn 0 1 3 "" 0,  -- 7: Column
  vdbeColumn 1 0 4 "" 0,  -- 8: Column
  vdbeRealAffinity 4 0 0 "" 0,  -- 9: RealAffinity
  vdbeColumn 1 1 5 "" 0,  -- 10: Column
  vdbeRealAffinity 5 0 0 "" 0,  -- 11: RealAffinity
  vdbeString8 0 6 0 "two" 0,  -- 12: String8
  vdbeColumn 0 0 7 "" 0,  -- 13: Column
  vdbeColumn 0 1 8 "" 0,  -- 14: Column
  vdbeColumn 1 0 9 "" 0,  -- 15: Column
  vdbeRealAffinity 9 0 0 "" 0,  -- 16: RealAffinity
  vdbeColumn 1 1 10 "" 0,  -- 17: Column
  vdbeRealAffinity 10 0 0 "" 0,  -- 18: RealAffinity
  vdbeResultRow 1 10 0 "" 0,  -- 19: ResultRow
  vdbeNext 1 5 0 "" 1,  -- 20: Next
  vdbeNext 0 4 0 "" 1,  -- 21: Next
  vdbeHalt 0 0 0 "" 0,  -- 22: Halt
  vdbeTransaction 0 0 2 "0" 1,  -- 23: Transaction
  vdbeGoto 0 1 0 "" 0  -- 24: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000011
