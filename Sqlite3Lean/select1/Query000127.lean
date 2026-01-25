import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000127

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
  .init 0 20 0 0 0,  -- 0: Init
  .openEphemeral 1 2 0 "k(2,B,B)" 0,  -- 1: OpenEphemeral
  .integer 3 1 0 0 0,  -- 2: Integer
  .integer 4 2 0 0 0,  -- 3: Integer
  .makeRecord 1 2 3 0 0,  -- 4: MakeRecord
  .idxInsert 1 3 1 2 0,  -- 5: IdxInsert
  .openRead 0 3 0 2 0,  -- 6: OpenRead
  .rewind 0 13 0 0 0,  -- 7: Rewind
  .column 0 0 1 0 0,  -- 8: Column
  .column 0 1 2 0 0,  -- 9: Column
  .makeRecord 1 2 3 0 0,  -- 10: MakeRecord
  .idxInsert 1 3 1 2 0,  -- 11: IdxInsert
  .next 0 8 0 0 1,  -- 12: Next
  .rewind 1 18 0 0 0,  -- 13: Rewind
  .column 1 0 4 0 0,  -- 14: Column
  .column 1 1 5 0 0,  -- 15: Column
  .resultRow 4 2 0 0 0,  -- 16: ResultRow
  .next 1 14 0 0 0,  -- 17: Next
  .close 1 0 0 0 0,  -- 18: Close
  .halt 0 0 0 0 0,  -- 19: Halt
  .transaction 0 0 9 0 1,  -- 20: Transaction
  .goto 0 1 0 0 0  -- 21: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000127
