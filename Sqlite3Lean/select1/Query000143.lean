import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000143

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=2 rootpage=4 db=0 mode=read name=
    cursor=3 rootpage=5 db=0 mode=read name=
    cursor=0 rootpage=3 db=0 mode=read name=

  Query: SELECT * FROM t1,(SELECT * FROM t2 WHERE y=2 ORDER BY y,z);

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     16    0                    0   
  1     OpenRead       2     4     0     2              0   
  2     OpenRead       3     5     0     k(2,,)         2   
  3     OpenRead       0     3     0     1              0   
  4     Integer        2     1     0                    0   
  5     SeekGE         3     15    1     1              0   
  6     IdxGT          3     15    1     1              0   
  7     DeferredSeek   3     0     2                    0   
  8     Rewind         0     15    0                    0   
  9     Column         0     0     2                    0   
  10    Column         3     0     3                    0   
  11    Column         2     1     4                    0   
  12    ResultRow      2     3     0                    0   
  13    Next           0     9     0                    1   
  14    Next           3     6     1                    0   
  15    Halt           0     0     0                    0   
  16    Transaction    0     0     25    1              1   
  17    Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 16 0 0 0,  -- 0: Init
  .openRead 2 4 0 2 0,  -- 1: OpenRead
  .openRead 3 5 0 "k(2,,)" 2,  -- 2: OpenRead
  .openRead 0 3 0 1 0,  -- 3: OpenRead
  .integer 2 1 0 0 0,  -- 4: Integer
  .seekGE 3 15 1 1 0,  -- 5: SeekGE
  .idxGT 3 15 1 1 0,  -- 6: IdxGT
  .deferredSeek 3 0 2 0 0,  -- 7: DeferredSeek
  .rewind 0 15 0 0 0,  -- 8: Rewind
  .column 0 0 2 0 0,  -- 9: Column
  .column 3 0 3 0 0,  -- 10: Column
  .column 2 1 4 0 0,  -- 11: Column
  .resultRow 2 3 0 0 0,  -- 12: ResultRow
  .next 0 9 0 0 1,  -- 13: Next
  .next 3 6 1 0 0,  -- 14: Next
  .halt 0 0 0 0 0,  -- 15: Halt
  .transaction 0 0 25 1 1,  -- 16: Transaction
  .goto 0 1 0 0 0  -- 17: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000143
