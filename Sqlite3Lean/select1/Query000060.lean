import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000060

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=

  Query: SELECT max(f1) FROM test1 ORDER BY f2

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     15    0                    0   
  1     SorterOpen     1     3     0     k(1,B)         0   
  2     Null           0     1     3                    0   
  3     OpenRead       0     2     0     2              0   
  4     Rewind         0     11    0                    0   
  5     Column         0     0     4                    0   
  6     CollSeq        5     0     0     BINARY-8       0   
  7     AggStep        0     4     3     max(1)         1   
  8     If             5     10    0                    0   
  9     Column         0     1     1                    0   
  10    Next           0     5     0                    1   
  11    AggFinal       3     1     0     max(1)         0   
  12    Copy           3     6     0                    0   
  13    ResultRow      6     1     0                    0   
  14    Halt           0     0     0                    0   
  15    Transaction    0     0     7     0              1   
  16    Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 15 0 "" 0,  -- 0: Init
  vdbeSorterOpen 1 3 0 "k(1,B)" 0,  -- 1: SorterOpen
  vdbeNull 0 1 3 "" 0,  -- 2: Null
  vdbeOpenRead 0 2 0 "2" 0,  -- 3: OpenRead
  vdbeRewind 0 11 0 "" 0,  -- 4: Rewind
  vdbeColumn 0 0 4 "" 0,  -- 5: Column
  vdbeCollSeq 5 0 0 "BINARY-8" 0,  -- 6: CollSeq
  vdbeAggStep 0 4 3 "max(1)" 1,  -- 7: AggStep
  vdbeIf 5 10 0 "" 0,  -- 8: If
  vdbeColumn 0 1 1 "" 0,  -- 9: Column
  vdbeNext 0 5 0 "" 1,  -- 10: Next
  vdbeAggFinal 3 1 0 "max(1)" 0,  -- 11: AggFinal
  vdbeCopy 3 6 0 "" 0,  -- 12: Copy
  vdbeResultRow 6 1 0 "" 0,  -- 13: ResultRow
  vdbeHalt 0 0 0 "" 0,  -- 14: Halt
  vdbeTransaction 0 0 7 "0" 1,  -- 15: Transaction
  vdbeGoto 0 1 0 "" 0  -- 16: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000060
