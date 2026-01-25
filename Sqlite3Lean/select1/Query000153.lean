import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000153

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=4 rootpage=3 db=0 mode=read name=
    cursor=2 rootpage=4 db=0 mode=read name=
    cursor=3 rootpage=4 db=0 mode=read name=

  Query: SELECT a,(+a)b,(+a)b,(+a)b,NOT EXISTS(SELECT null FROM t2),CASE z WHEN 487 THEN 992 WHEN 391 THEN 203 WHEN 10 THEN '?k<D Q' END,'' FROM t1 LEFT JOIN v1a ON z=b;

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     52    0                    0   
  1     OpenRead       4     3     0     k(2,,)         0   
  2     OpenRead       2     4     0     1              0   
  3     Rewind         4     51    1     0              0   
  4     Integer        0     1     0                    0   
  5     Rewind         2     47    0                    0   
  6     IfNullRow      2     11    2                    0   
  7     Integer        1     2     0                    0   
  8     Column         2     0     3                    0   
  9     IsNull         3     11    0                    0   
  10    Integer        0     2     0                    0   
  11    Column         4     0     3                    0   
  12    Ne             3     46    2     BINARY-8       80  
  13    Integer        1     1     0                    0   
  14    Column         4     0     4                    0   
  15    Column         4     0     5                    0   
  16    Column         4     0     6                    0   
  17    Column         4     0     7                    0   
  18    BeginSubrtn    0     11    0                    0   
  19    Once           0     27    0                    0   
  20    Integer        0     12    0                    0   
  21    Integer        1     13    0                    0   
  22    OpenRead       3     4     0     0              0   
  23    Rewind         3     27    0                    0   
  24    Integer        1     12    0                    0   
  25    DecrJumpZero   13    27    0                    0   
  26    Next           3     24    0                    1   
  27    Return         11    19    1                    0   
  28    Not            12    8     0                    0   
  29    IfNullRow      2     34    3                    0   
  30    Integer        1     3     0                    0   
  31    Column         2     0     15                   0   
  32    IsNull         15    34    0                    0   
  33    Integer        0     3     0                    0   
  34    Ne             16    37    3     BINARY-8       80  
  35    Integer        992   9     0                    0   
  36    Goto           0     44    0                    0   
  37    Ne             17    40    3     BINARY-8       80  
  38    Integer        203   9     0                    0   
  39    Goto           0     44    0                    0   
  40    Ne             18    43    3     BINARY-8       80  
  41    String8        0     9     0     ?k<D Q         0   
  42    Goto           0     44    0                    0   
  43    Null           0     9     0                    0   
  44    String8        0     10    0                    0   
  45    ResultRow      4     7     0                    0   
  46    Next           2     6     0                    1   
  47    IfPos          1     50    0                    0   
  48    NullRow        2     0     0                    0   
  49    Goto           0     13    0                    0   
  50    Next           4     4     0                    1   
  51    Halt           0     0     0                    0   
  52    Transaction    0     0     3     0              1   
  53    Integer        487   16    0                    0   
  54    Integer        391   17    0                    0   
  55    Integer        10    18    0                    0   
  56    Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 52 0 "" 0,  -- 0: Init
  vdbeOpenRead 4 3 0 "k(2,,)" 0,  -- 1: OpenRead
  vdbeOpenRead 2 4 0 "1" 0,  -- 2: OpenRead
  vdbeRewind 4 51 1 "0" 0,  -- 3: Rewind
  vdbeInteger 0 1 0 "" 0,  -- 4: Integer
  vdbeRewind 2 47 0 "" 0,  -- 5: Rewind
  vdbeIfNullRow 2 11 2 "" 0,  -- 6: IfNullRow
  vdbeInteger 1 2 0 "" 0,  -- 7: Integer
  vdbeColumn 2 0 3 "" 0,  -- 8: Column
  vdbeIsNull 3 11 0 "" 0,  -- 9: IsNull
  vdbeInteger 0 2 0 "" 0,  -- 10: Integer
  vdbeColumn 4 0 3 "" 0,  -- 11: Column
  vdbeNe 3 46 2 "BINARY-8" 80,  -- 12: Ne
  vdbeInteger 1 1 0 "" 0,  -- 13: Integer
  vdbeColumn 4 0 4 "" 0,  -- 14: Column
  vdbeColumn 4 0 5 "" 0,  -- 15: Column
  vdbeColumn 4 0 6 "" 0,  -- 16: Column
  vdbeColumn 4 0 7 "" 0,  -- 17: Column
  vdbeBeginSubrtn 0 11 0 "" 0,  -- 18: BeginSubrtn
  vdbeOnce 0 27 0 "" 0,  -- 19: Once
  vdbeInteger 0 12 0 "" 0,  -- 20: Integer
  vdbeInteger 1 13 0 "" 0,  -- 21: Integer
  vdbeOpenRead 3 4 0 "0" 0,  -- 22: OpenRead
  vdbeRewind 3 27 0 "" 0,  -- 23: Rewind
  vdbeInteger 1 12 0 "" 0,  -- 24: Integer
  vdbeDecrJumpZero 13 27 0 "" 0,  -- 25: DecrJumpZero
  vdbeNext 3 24 0 "" 1,  -- 26: Next
  vdbeReturn 11 19 1 "" 0,  -- 27: Return
  vdbeNot 12 8 0 "" 0,  -- 28: Not
  vdbeIfNullRow 2 34 3 "" 0,  -- 29: IfNullRow
  vdbeInteger 1 3 0 "" 0,  -- 30: Integer
  vdbeColumn 2 0 15 "" 0,  -- 31: Column
  vdbeIsNull 15 34 0 "" 0,  -- 32: IsNull
  vdbeInteger 0 3 0 "" 0,  -- 33: Integer
  vdbeNe 16 37 3 "BINARY-8" 80,  -- 34: Ne
  vdbeInteger 992 9 0 "" 0,  -- 35: Integer
  vdbeGoto 0 44 0 "" 0,  -- 36: Goto
  vdbeNe 17 40 3 "BINARY-8" 80,  -- 37: Ne
  vdbeInteger 203 9 0 "" 0,  -- 38: Integer
  vdbeGoto 0 44 0 "" 0,  -- 39: Goto
  vdbeNe 18 43 3 "BINARY-8" 80,  -- 40: Ne
  vdbeString8 0 9 0 "?k<D Q" 0,  -- 41: String8
  vdbeGoto 0 44 0 "" 0,  -- 42: Goto
  vdbeNull 0 9 0 "" 0,  -- 43: Null
  vdbeString8 0 10 0 "" 0,  -- 44: String8
  vdbeResultRow 4 7 0 "" 0,  -- 45: ResultRow
  vdbeNext 2 6 0 "" 1,  -- 46: Next
  vdbeIfPos 1 50 0 "" 0,  -- 47: IfPos
  vdbeNullRow 2 0 0 "" 0,  -- 48: NullRow
  vdbeGoto 0 13 0 "" 0,  -- 49: Goto
  vdbeNext 4 4 0 "" 1,  -- 50: Next
  vdbeHalt 0 0 0 "" 0,  -- 51: Halt
  vdbeTransaction 0 0 3 "0" 1,  -- 52: Transaction
  vdbeInteger 487 16 0 "" 0,  -- 53: Integer
  vdbeInteger 391 17 0 "" 0,  -- 54: Integer
  vdbeInteger 10 18 0 "" 0,  -- 55: Integer
  vdbeGoto 0 1 0 "" 0  -- 56: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000153
