import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000067

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
  .init 0 14 0 0 0,  -- 0: Init
  .openEphemeral 1 0 0 "k(2,B,B)" 8,  -- 1: OpenEphemeral
  .openRead 0 2 0 2 0,  -- 2: OpenRead
  .rewind 0 13 0 0 0,  -- 3: Rewind
  .column 0 0 1 0 0,  -- 4: Column
  .ne 2 12 1 "BINARY-8" 84,  -- 5: Ne
  .column 0 0 3 0 0,  -- 6: Column
  .column 0 1 4 0 0,  -- 7: Column
  .found 1 12 3 2 0,  -- 8: Found
  .makeRecord 3 2 1 0 0,  -- 9: MakeRecord
  .idxInsert 1 1 3 2 16,  -- 10: IdxInsert
  .resultRow 3 2 0 0 0,  -- 11: ResultRow
  .next 0 4 0 0 1,  -- 12: Next
  .halt 0 0 0 0 0,  -- 13: Halt
  .transaction 0 0 8 0 1,  -- 14: Transaction
  .integer 11 2 0 0 0,  -- 15: Integer
  .goto 0 1 0 0 0  -- 16: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000067
