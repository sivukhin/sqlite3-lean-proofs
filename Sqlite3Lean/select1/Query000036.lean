import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000036

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=3 db=0 mode=read name=

  Query: SELECT max(coalesce(a,'xyzzy')) FROM t3

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
  8     AggStep        0     3     2     max(1)         1   
  9     Next           0     4     0                    1   
  10    AggFinal       2     1     0     max(1)         0   
  11    Copy           2     4     0                    0   
  12    ResultRow      4     1     0                    0   
  13    Halt           0     0     0                    0   
  14    Transaction    0     0     5     0              1   
  15    Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 14 0 0 0,  -- 0: Init
  .null 0 1 2 0 0,  -- 1: Null
  .openRead 0 3 0 1 0,  -- 2: OpenRead
  .rewind 0 10 0 0 0,  -- 3: Rewind
  .column 0 0 3 0 0,  -- 4: Column
  .notNull 3 7 0 0 0,  -- 5: NotNull
  .string8 0 3 0 "xyzzy" 0,  -- 6: String8
  .collSeq 0 0 0 "BINARY-8" 0,  -- 7: CollSeq
  .aggStep 0 3 2 "max(1)" 1,  -- 8: AggStep
  .next 0 4 0 0 1,  -- 9: Next
  .aggFinal 2 1 0 "max(1)" 0,  -- 10: AggFinal
  .copy 2 4 0 0 0,  -- 11: Copy
  .resultRow 4 1 0 0 0,  -- 12: ResultRow
  .halt 0 0 0 0 0,  -- 13: Halt
  .transaction 0 0 5 0 1,  -- 14: Transaction
  .goto 0 1 0 0 0  -- 15: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000036
