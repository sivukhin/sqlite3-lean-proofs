import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000017

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=
    cursor=1 rootpage=3 db=0 mode=read name=

  Query: SELECT min(test1.f1,test2.r1), max(test1.f2,test2.r2)
             FROM test1, test2

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     19    0                    0   
  1     OpenRead       0     2     0     2              0   
  2     OpenRead       1     3     0     2              0   
  3     Rewind         0     18    0                    0   
  4     Rewind         1     18    0                    0   
  5     Column         0     0     3                    0   
  6     Column         1     0     4                    0   
  7     RealAffinity   4     0     0                    0   
  8     CollSeq        0     0     0     BINARY-8       0   
  9     Function       0     3     1     min(-3)        0   
  10    Column         0     1     3                    0   
  11    Column         1     1     4                    0   
  12    RealAffinity   4     0     0                    0   
  13    CollSeq        0     0     0     BINARY-8       0   
  14    Function       0     3     2     max(-3)        0   
  15    ResultRow      1     2     0                    0   
  16    Next           1     5     0                    1   
  17    Next           0     4     0                    1   
  18    Halt           0     0     0                    0   
  19    Transaction    0     0     2     0              1   
  20    Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 19 0 "" 0,  -- 0: Init
  vdbeOpenRead 0 2 0 "2" 0,  -- 1: OpenRead
  vdbeOpenRead 1 3 0 "2" 0,  -- 2: OpenRead
  vdbeRewind 0 18 0 "" 0,  -- 3: Rewind
  vdbeRewind 1 18 0 "" 0,  -- 4: Rewind
  vdbeColumn 0 0 3 "" 0,  -- 5: Column
  vdbeColumn 1 0 4 "" 0,  -- 6: Column
  vdbeRealAffinity 4 0 0 "" 0,  -- 7: RealAffinity
  vdbeCollSeq 0 0 0 "BINARY-8" 0,  -- 8: CollSeq
  vdbeFunction 0 3 1 "min(-3)" 0,  -- 9: Function
  vdbeColumn 0 1 3 "" 0,  -- 10: Column
  vdbeColumn 1 1 4 "" 0,  -- 11: Column
  vdbeRealAffinity 4 0 0 "" 0,  -- 12: RealAffinity
  vdbeCollSeq 0 0 0 "BINARY-8" 0,  -- 13: CollSeq
  vdbeFunction 0 3 2 "max(-3)" 0,  -- 14: Function
  vdbeResultRow 1 2 0 "" 0,  -- 15: ResultRow
  vdbeNext 1 5 0 "" 1,  -- 16: Next
  vdbeNext 0 4 0 "" 1,  -- 17: Next
  vdbeHalt 0 0 0 "" 0,  -- 18: Halt
  vdbeTransaction 0 0 2 "0" 1,  -- 19: Transaction
  vdbeGoto 0 1 0 "" 0  -- 20: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000017
