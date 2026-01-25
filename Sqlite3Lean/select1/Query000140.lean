import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000140

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=1 rootpage=1 db=0 mode=read name=

  Query: SELECT 10 IN (SELECT rowid FROM sqlite_master);

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     15    0                    0   
  1     Null           0     1     0                    0   
  2     Once           0     4     0                    0   
  3     OpenRead       1     1     0     5              0   
  4     Integer        10    2     0                    0   
  5     SeekRowid      1     12    2                    0   
  6     Goto           0     11    0                    0   
  7     Rewind         1     12    0                    0   
  8     Column         1     0     3                    0   
  9     Ne             2     12    3                    0   
  10    Goto           0     13    0                    0   
  11    Integer        1     1     0                    0   
  12    AddImm         1     0     0                    0   
  13    ResultRow      1     1     0                    0   
  14    Halt           0     0     0                    0   
  15    Transaction    0     0     18    0              1   
  16    Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 15 0 0 0,  -- 0: Init
  .null 0 1 0 0 0,  -- 1: Null
  .once 0 4 0 0 0,  -- 2: Once
  .openRead 1 1 0 5 0,  -- 3: OpenRead
  .integer 10 2 0 0 0,  -- 4: Integer
  .seekRowid 1 12 2 0 0,  -- 5: SeekRowid
  .goto 0 11 0 0 0,  -- 6: Goto
  .rewind 1 12 0 0 0,  -- 7: Rewind
  .column 1 0 3 0 0,  -- 8: Column
  .ne 2 12 3 0 0,  -- 9: Ne
  .goto 0 13 0 0 0,  -- 10: Goto
  .integer 1 1 0 0 0,  -- 11: Integer
  .addImm 1 0 0 0 0,  -- 12: AddImm
  .resultRow 1 1 0 0 0,  -- 13: ResultRow
  .halt 0 0 0 0 0,  -- 14: Halt
  .transaction 0 0 18 0 1,  -- 15: Transaction
  .goto 0 1 0 0 0  -- 16: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000140
