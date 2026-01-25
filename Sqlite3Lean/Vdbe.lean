/-
  SQLite3 VDBE (Virtual Database Engine) Formalization

  This module formalizes the core concepts of SQLite's virtual machine:
  - Basic data types (Null, Integer, Float, Blob, Text)
  - Tuples (sequences of values)
  - BTrees as ordered lists of tuples
  - Cursors for btree traversal
  - VM state with registers and cursors
  - VDBE opcodes for query execution
-/

namespace Sqlite3Lean.Vdbe

/-! ## Basic Data Types -/

/-- SQLite basic data types (affinity types) -/
inductive Value where
  | null : Value
  | integer : Int → Value
  | float : Float → Value
  | blob : ByteArray → Value
  | text : String → Value
  deriving BEq

instance : Repr Value where
  reprPrec v _ := match v with
    | .null => "null"
    | .integer i => s!"integer {repr i}"
    | .float f => s!"float {repr f}"
    | .blob b => s!"blob[{b.size}]"
    | .text t => s!"text {repr t}"

/-- A tuple is a sequence of values -/
abbrev Tuple := List Value

/-! ## BTree Data Model -/

/-- BTree identifier (table or index root page) -/
abbrev BTreeId := Nat

/--
  A BTree is modeled as a list of tuples ordered by some prefix.
  In SQLite, tables are BTrees where tuples are ordered by rowid,
  and indexes are BTrees ordered by the indexed columns.

  The `keyLength` specifies how many columns form the ordering key.
-/
structure BTree where
  id : BTreeId
  keyLength : Nat
  tuples : List Tuple
  deriving Repr

/-- Database schema: mapping from btree ids to btrees -/
abbrev Database := BTreeId → Option BTree

def btreeSize (db : Database) (btreeId : BTreeId): Nat := match db btreeId with
  | none => 0
  | some btree => btree.tuples.length

/-! ## Cursor Model -/

/-- Direction of cursor traversal -/
inductive Direction where
  | forward : Direction
  | backward : Direction
  deriving Repr, BEq

/-- Cursor identifier -/
abbrev CursorId := Nat

/--
  A cursor points to a position in a BTree.
  - `btreeId`: which btree this cursor is attached to
  - `position`: current index in the tuple list (None if before first or after last)
  - `direction`: traversal direction (set by Rewind/Last)
-/
structure Cursor where
  btreeId : BTreeId
  position : Option Nat  -- None means cursor is not positioned
  direction : Direction
  deriving Repr

/-! ## Register Model -/

/-- Register identifier -/
abbrev RegisterId := Nat

/-- Registers store values -/
abbrev Registers := RegisterId → Value

def Registers.empty : Registers := fun _ => Value.null

def Registers.get (regs : Registers) (r : RegisterId) : Value := regs r

def Registers.set (regs : Registers) (r : RegisterId) (v : Value) : Registers :=
  fun r' => if r' == r then v else regs r'

/-! ## VDBE Opcodes -/

/-- Aggregate function types -/
inductive AggFunc where
  | count : AggFunc
  deriving Repr, BEq

/--
  VDBE opcodes for a basic SELECT query.
  Each opcode has parameters p1, p2, p3, p4, p5 with opcode-specific meanings.
  All opcodes have exactly 5 parameters for uniformity.
  p4 is always a String (used for comments/info in SQLite).
-/
inductive Opcode where
  /-- Init: Jump to p2 on first execution. p1 is ignored for now. -/
  | init (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode
  /-- Null: Set register p2 to NULL. p1 is ignored. -/
  | null (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode
  /-- OpenRead: Open cursor p1 on btree with root page p2, database p3. p4 is table name. -/
  | openRead (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode
  /-- Rewind: Position cursor p1 to first row. Jump to p2 if table is empty. -/
  | rewind (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode
  /-- Column: Read column p2 from cursor p1, store in register p3. -/
  | column (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode
  /-- String8: Set register p2 to string p4. -/
  | string8 (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode
  /-- Eq: If r[p1]==r[p3] then jump to p2. -/
  | eq (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode
  /-- Ne: If r[p1]!=r[p3] then jump to p2. -/
  | ne (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode
  /-- Integer: Set register p2 to integer value p1. -/
  | integer (p1 : Int) (p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode
  /-- AggStep: Step aggregate function p4 with argument r[p2] into accumulator r[p3]. -/
  | aggStep (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode
  /-- AggFinal: Finalize aggregate function p4 in register p2. -/
  | aggFinal (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode
  /-- Copy: Copy r[p1] to r[p2]. -/
  | copy (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode
  /-- ResultRow: Output registers p1 through p1+p2-1 as a result row. -/
  | resultRow (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode
  /-- Next: Advance cursor p1 to next row. Jump to p2 if there is another row. -/
  | next (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode
  /-- Prev: Move cursor p1 to previous row. Jump to p2 if there is another row. -/
  | prev (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode
  /-- Halt: Stop execution. p1 is result code, p2 is error action. -/
  | halt (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode
  /-- Transaction: Begin a transaction on database p1. p2=0 for read, p2=1 for write. -/
  | transaction (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode
  /-- Goto: Unconditional jump to address p2. -/
  | goto (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode
  deriving Repr

/-! ## Opcode constructors -/

/-- Implemented opcodes return the constructed opcode -/
def vdbeInit (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := .init p1 p2 p3 p4 p5
def vdbeNull (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := .null p1 p2 p3 p4 p5
def vdbeOpenRead (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := .openRead p1 p2 p3 p4 p5
def vdbeRewind (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := .rewind p1 p2 p3 p4 p5
def vdbeColumn (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := .column p1 p2 p3 p4 p5
def vdbeString8 (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := .string8 p1 p2 p3 p4 p5
def vdbeEq (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := .eq p1 p2 p3 p4 p5
def vdbeNe (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := .ne p1 p2 p3 p4 p5
def vdbeInteger (p1 : Int) (p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := .integer p1 p2 p3 p4 p5
def vdbeAggStep (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := .aggStep p1 p2 p3 p4 p5
def vdbeAggFinal (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := .aggFinal p1 p2 p3 p4 p5
def vdbeCopy (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := .copy p1 p2 p3 p4 p5
def vdbeResultRow (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := .resultRow p1 p2 p3 p4 p5
def vdbeNext (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := .next p1 p2 p3 p4 p5
def vdbePrev (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := .prev p1 p2 p3 p4 p5
def vdbeHalt (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := .halt p1 p2 p3 p4 p5
def vdbeTransaction (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := .transaction p1 p2 p3 p4 p5
def vdbeGoto (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := .goto p1 p2 p3 p4 p5

/-- Unimplemented opcodes (stubbed with sorry) -/
def vdbeAdd (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeAddImm (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeAffinity (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeAnd (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeBitAnd (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeBitNot (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeBitOr (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeBlob (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeCast (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeClose (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeCompare (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeConcat (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeCountSetup (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeCount (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeDecrJumpZero (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeDelete (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeDivide (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeElseEq (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeEndCoroutine (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeFkCheck (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeFkCounter (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeFkIfZero (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeFound (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeFunction (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeGe (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeGoSubroutine (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeGt (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeIdxDelete (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeIdxGe (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeIdxGt (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeIdxInsert (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeIdxLe (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeIdxLt (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeIdxRowid (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeIf (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeIfNot (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeIfNotZero (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeIfNullRow (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeIfPos (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeIfSmaller (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeIncrVacuum (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeInsert (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeInt64 (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeIsNull (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeIsTrue (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeJump (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeLast (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeLe (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeLt (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeMakeRecord (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeMove (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeMultiply (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeMustBeInt (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeNewRowid (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeNoop (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeNot (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeNotExists (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeNotFound (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeNotNull (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeNullRow (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeOffset (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeOnceFlag (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeOpenAutoindex (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeOpenDup (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeOpenEphemeral (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeOpenPseudo (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeOpenWrite (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeOr (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeReal (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeRealAffinity (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeRemainder (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeResetCount (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeReturn (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeRowData (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeRowSetAdd (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeRowSetRead (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeRowSetTest (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeRowid (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeSavepoint (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeSCopy (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeSeekEnd (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeSeekGe (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeSeekGt (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeSeekHit (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeSeekLe (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeSeekLt (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeSeekRowid (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeSeekScan (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeSequence (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeSequenceTest (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeSetCookie (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeShiftLeft (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeShiftRight (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeSoftNull (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeSort (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeSorterCompare (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeSorterData (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeSorterInsert (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeSorterNext (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeSorterOpen (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeSorterSort (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeSqlExec (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeSubtract (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeTablelock (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeTrace (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeTypeofColumn (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeVariable (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeVerifyColumn (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeVerifyCookie (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeYield (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeZeroOrNull (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeBeginSubrtn (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeClrSubtype (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeCollSeq (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeDeferredSeek (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeFilterAdd (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeFilter (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeGosub (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeIdxGT (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeIdxLE (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeIfEmpty (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeInitCoroutine (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeOnce (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbePermutation (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeReopenIdx (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeResetSorter (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeScopy (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeSeekGE (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry
def vdbeSeekGT (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) : Opcode := sorry

/-- A VDBE program is a list of opcodes -/
abbrev Program := Array Opcode

/-! ## VM State -/

/-- Output rows accumulated during execution -/
abbrev Output := List Tuple

/-- Cursor map -/
abbrev Cursors := CursorId → Option Cursor

def Cursors.empty : Cursors := fun _ => none

def Cursors.get (cs : Cursors) (c : CursorId) : Option Cursor := cs c

def Cursors.set (cs : Cursors) (c : CursorId) (cursor : Cursor) : Cursors :=
  fun c' => if c' == c then some cursor else cs c'

/-- Execution status -/
inductive Status where
  | running : Status
  | halted (code : Nat) : Status
  | error (msg : String) : Status
  deriving Repr, BEq

/--
  Virtual machine state.
  - `pc`: program counter (current instruction address)
  - `registers`: value storage
  - `cursors`: open cursors on btrees
  - `database`: the database (btrees)
  - `output`: accumulated result rows
  - `status`: execution status
-/
structure VMState where
  pc : Nat
  registers : Registers
  cursors : Cursors
  database : Database
  output : Output
  status : Status

/-! ## Opcode Semantics -/

/-- Get the tuple at a cursor's current position -/
def getCursorTuple (state : VMState) (cursorId : CursorId) : Option Tuple := do
  let cursor ← state.cursors cursorId
  let btree ← state.database cursor.btreeId
  let pos ← cursor.position
  btree.tuples[pos]?

/-- Get a specific column from the tuple at cursor's position -/
def getCursorColumn (state : VMState) (cursorId : CursorId) (colIdx : Nat) : Option Value := do
  let tuple ← getCursorTuple state cursorId
  tuple[colIdx]?

/-- Parse aggregate function name from string -/
def parseAggFunc (s : String) : Option AggFunc :=
  if s == "count(0)" || s == "count(*)" || s == "count" then some .count
  else none

/-- Execute a single opcode and return the new state -/
def executeOpcode (op : Opcode) (state : VMState) : VMState :=
  match state.status with
  | .halted _ | .error _ => state
  | .running =>
    match op with
    | .init _ p2 _ _ _ =>
      -- Jump to p2 (typically the Transaction instruction)
      { state with pc := p2 }

    | .null _ p2 _ _ _ =>
      -- Set register p2 to NULL
      { state with
        registers := state.registers.set p2 Value.null,
        pc := state.pc + 1 }

    | .openRead p1 p2 _p3 _p4 _p5 =>
      -- Open a read cursor p1 on btree with root page p2
      let cursor : Cursor := {
        btreeId := p2,
        position := none,
        direction := .forward
      }
      { state with
        cursors := state.cursors.set p1 cursor,
        pc := state.pc + 1 }

    | .rewind p1 p2 _ _ _ =>
      -- Position cursor p1 to first row. Jump to p2 if table is empty.
      match state.cursors p1 with
      | none => { state with status := .error s!"Cursor {p1} not open" }
      | some cursor =>
        match state.database cursor.btreeId with
        | none => { state with status := .error s!"BTree {cursor.btreeId} not found" }
        | some btree =>
          if btree.tuples.isEmpty then
            -- Table is empty, jump to p2
            { state with pc := p2 }
          else
            -- Position cursor at first row
            let cursor' := { cursor with position := some 0, direction := .forward }
            { state with
              cursors := state.cursors.set p1 cursor',
              pc := state.pc + 1 }

    | .column p1 p2 p3 _ _ =>
      -- Read column p2 from cursor p1, store in register p3
      match getCursorColumn state p1 p2 with
      | none =>
        -- Column not found, store NULL (SQLite behavior)
        { state with
          registers := state.registers.set p3 Value.null,
          pc := state.pc + 1 }
      | some value =>
        { state with
          registers := state.registers.set p3 value,
          pc := state.pc + 1 }

    | .string8 _ p2 _ p4 _ =>
      -- Set register p2 to string p4
      { state with
        registers := state.registers.set p2 (Value.text p4),
        pc := state.pc + 1 }

    | .eq p1 p2 p3 _ _ =>
      -- Jump to p2 if r[p1] == r[p3]
      let v1 := state.registers.get p1
      let v2 := state.registers.get p3
      if v1 == v2 then
        { state with pc := p2 }
      else
        { state with pc := state.pc + 1 }

    | .ne p1 p2 p3 _ _ =>
      -- Jump to p2 if r[p1] != r[p3]
      let v1 := state.registers.get p1
      let v2 := state.registers.get p3
      if v1 != v2 then
        { state with pc := p2 }
      else
        { state with pc := state.pc + 1 }

    | .integer p1 p2 _ _ _ =>
      -- Set register p2 to integer value p1
      { state with
        registers := state.registers.set p2 (Value.integer p1),
        pc := state.pc + 1 }

    | .aggStep _ p2 p3 p4 _ =>
      -- Step aggregate function p4 with argument r[p2] into accumulator r[p3]
      match parseAggFunc p4 with
      | some .count =>
        -- count() increments accumulator for each row
        -- If accumulator is null, initialize to 0 first
        let currentVal := state.registers.get p3
        let count := match currentVal with
          | .integer n => n + 1
          | .null => 1  -- Initialize from null to 1
          | _ => 1  -- Shouldn't happen, but handle gracefully
        -- p2 (argReg) value is typically 1 (from Integer opcode) but ignored for count(*)
        let _ := state.registers.get p2
        { state with
          registers := state.registers.set p3 (Value.integer count),
          pc := state.pc + 1 }
      | none =>
        { state with status := .error s!"Unknown aggregate function: {p4}" }

    | .aggFinal _ p2 _ p4 _ =>
      -- Finalize aggregate function p4 in register p2
      match parseAggFunc p4 with
      | some .count =>
        -- For count, ensure the accumulator has a proper integer value
        let currentVal := state.registers.get p2
        let finalVal := match currentVal with
          | .integer n => Value.integer n
          | .null => Value.integer 0  -- count() returns 0 for empty set
          | _ => Value.integer 0
        { state with
          registers := state.registers.set p2 finalVal,
          pc := state.pc + 1 }
      | none =>
        { state with status := .error s!"Unknown aggregate function: {p4}" }

    | .copy p1 p2 _ _ _ =>
      -- Copy value from r[p1] to r[p2]
      let value := state.registers.get p1
      { state with
        registers := state.registers.set p2 value,
        pc := state.pc + 1 }

    | .resultRow p1 p2 _ _ _ =>
      -- Collect registers p1 through p1+p2-1 into a result row
      let row := List.range p2 |>.map fun i => state.registers.get (p1 + i)
      { state with
        output := state.output ++ [row],
        pc := state.pc + 1 }

    | .next p1 p2 _ _ _ =>
      -- Advance cursor p1 to next row. Jump to p2 if there is another row.
      match state.cursors p1 with
      | none => { state with status := .error s!"Cursor {p1} not open" }
      | some cursor =>
        match state.database cursor.btreeId with
        | none => { state with status := .error s!"BTree {cursor.btreeId} not found" }
        | some btree =>
          match cursor.position with
          | none => { state with status := .error "Cursor not positioned" }
          | some pos =>
            let nextPos := pos + 1
            if nextPos < btree.tuples.length then
              -- More rows, update position and jump
              let cursor' := { cursor with position := some nextPos }
              { state with
                cursors := state.cursors.set p1 cursor',
                pc := p2 }
            else
              -- No more rows, continue to next instruction
              { state with pc := state.pc + 1 }

    | .prev p1 p2 _ _ _ =>
      -- Move cursor p1 to previous row. Jump to p2 if there is another row.
      match state.cursors p1 with
      | none => { state with status := .error s!"Cursor {p1} not open" }
      | some cursor =>
        match state.database cursor.btreeId with
        | none => { state with status := .error s!"BTree {cursor.btreeId} not found" }
        | some _btree =>
          match cursor.position with
          | none => { state with status := .error "Cursor not positioned" }
          | some pos =>
            if pos > 0 then
              -- More rows, update position and jump
              let cursor' := { cursor with position := some (pos - 1) }
              { state with
                cursors := state.cursors.set p1 cursor',
                pc := p2 }
            else
              -- No more rows, continue to next instruction
              { state with pc := state.pc + 1 }

    | .halt p1 _ _ _ _ =>
      { state with status := .halted p1 }

    | .transaction _ _ _ _ _ =>
      -- For now, transaction is a no-op (we assume database is already available)
      { state with pc := state.pc + 1 }

    | .goto _ p2 _ _ _ =>
      { state with pc := p2 }

/-- Execute one step: fetch opcode at pc and execute it -/
def step (program : Program) (state : VMState) : VMState :=
  match state.status with
  | .halted _ | .error _ => state
  | .running =>
    match program[state.pc]? with
    | none => { state with status := .error s!"Invalid PC: {state.pc}" }
    | some op => executeOpcode op state

/-- Execute program until halted or max steps reached -/
partial def run (program : Program) (state : VMState) : VMState :=
  match state.status with
  | .halted _ | .error _ => state
  | .running => run program (step program state)

/-- Execute program with a step limit (for termination proof) -/
def runBounded (program : Program) (state : VMState) (fuel : Nat) : VMState :=
  match fuel with
  | 0 => state
  | fuel' + 1 => step program (runBounded program state fuel')

/-! ## Initial State Construction -/

/-- Create initial VM state with a database -/
def mkInitialState (db : Database) : VMState := {
  pc := 0,
  registers := Registers.empty,
  cursors := Cursors.empty,
  database := db,
  output := [],
  status := .running
}

end Sqlite3Lean.Vdbe
