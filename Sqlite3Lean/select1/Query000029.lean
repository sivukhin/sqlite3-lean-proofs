import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000029

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=3 db=0 mode=read name=

  Query: SELECT min(coalesce(a,'xyzzy')) FROM t3

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     14    0                    0   
  1     Null           0     1     2                    0   
  2     OpenRead       0     3     0     1              0   
  3     Rewind         0     10    0                    0   
  4     Column         0     0     3                    0   
  5     NotNull        3     7     0                    0   
  6     String8        0     3     0     xyzzy          0   
  7     CollSeq        0     0     0     BINARY-8       0   
  8     AggStep        0     3     2     min(1)         1   
  9     Next           0     4     0                    1   
  10    AggFinal       2     1     0     min(1)         0   
  11    Copy           2     4     0                    0   
  12    ResultRow      4     1     0                    0   
  13    Halt           0     0     0                    0   
  14    Transaction    0     0     5     0              1   
  15    Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 14 0 "" 0,  -- 0: Init
  vdbeNull 0 1 2 "" 0,  -- 1: Null
  vdbeOpenRead 0 3 0 "1" 0,  -- 2: OpenRead
  vdbeRewind 0 10 0 "" 0,  -- 3: Rewind
  vdbeColumn 0 0 3 "" 0,  -- 4: Column
  vdbeNotNull 3 7 0 "" 0,  -- 5: NotNull
  vdbeString8 0 3 0 "xyzzy" 0,  -- 6: String8
  vdbeCollSeq 0 0 0 "BINARY-8" 0,  -- 7: CollSeq
  vdbeAggStep 0 3 2 "min(1)" 1,  -- 8: AggStep
  vdbeNext 0 4 0 "" 1,  -- 9: Next
  vdbeAggFinal 2 1 0 "min(1)" 0,  -- 10: AggFinal
  vdbeCopy 2 4 0 "" 0,  -- 11: Copy
  vdbeResultRow 4 1 0 "" 0,  -- 12: ResultRow
  vdbeHalt 0 0 0 "" 0,  -- 13: Halt
  vdbeTransaction 0 0 5 "0" 1,  -- 14: Transaction
  vdbeGoto 0 1 0 "" 0  -- 15: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000029
