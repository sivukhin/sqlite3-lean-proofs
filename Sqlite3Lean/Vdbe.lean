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

/--
  VDBE opcodes for a basic SELECT query.
  Each opcode has parameters p1, p2, p3, p4, p5 with opcode-specific meanings.
-/
inductive Opcode where
  /-- Init: Jump to p2 on first execution. p1 is ignored for now. -/
  | init (p1 p2 : Nat) : Opcode
  /-- OpenRead: Open cursor p1 on btree with root page p2, database p3. p4 is column count. -/
  | openRead (cursorId : CursorId) (rootPage : BTreeId) (dbId : Nat) (numColumns : Nat) : Opcode
  /-- Rewind: Position cursor p1 to first row. Jump to p2 if table is empty. -/
  | rewind (cursorId : CursorId) (jumpIfEmpty : Nat) : Opcode
  /-- Column: Read column p2 from cursor p1, store in register p3. -/
  | column (cursorId : CursorId) (columnIdx : Nat) (destReg : RegisterId) : Opcode
  /-- ResultRow: Output registers p1 through p1+p2-1 as a result row. -/
  | resultRow (startReg : RegisterId) (numRegs : Nat) : Opcode
  /-- Next: Advance cursor p1 to next row. Jump to p2 if there is another row. -/
  | next (cursorId : CursorId) (jumpIfMore : Nat) : Opcode
  /-- Prev: Move cursor p1 to previous row. Jump to p2 if there is another row. -/
  | prev (cursorId : CursorId) (jumpIfMore : Nat) : Opcode
  /-- Halt: Stop execution. p1 is result code, p2 is error action. -/
  | halt (resultCode : Nat) (errorAction : Nat) : Opcode
  /-- Transaction: Begin a transaction on database p1. p2=0 for read, p2=1 for write. -/
  | transaction (dbId : Nat) (writeFlag : Nat) (schemaVersion : Nat) : Opcode
  /-- Goto: Unconditional jump to address p2. -/
  | goto (p2 : Nat) : Opcode
  deriving Repr

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

/-- Execute a single opcode and return the new state -/
def executeOpcode (op : Opcode) (state : VMState) : VMState :=
  match state.status with
  | .halted _ | .error _ => state
  | .running =>
    match op with
    | .init _ p2 =>
      -- Jump to p2 (typically the Transaction instruction)
      { state with pc := p2 }

    | .openRead cursorId rootPage _dbId _numColumns =>
      -- Open a read cursor on the btree
      let cursor : Cursor := {
        btreeId := rootPage,
        position := none,
        direction := .forward
      }
      { state with
        cursors := state.cursors.set cursorId cursor,
        pc := state.pc + 1 }

    | .rewind cursorId jumpIfEmpty =>
      match state.cursors cursorId with
      | none => { state with status := .error s!"Cursor {cursorId} not open" }
      | some cursor =>
        match state.database cursor.btreeId with
        | none => { state with status := .error s!"BTree {cursor.btreeId} not found" }
        | some btree =>
          if btree.tuples.isEmpty then
            -- Table is empty, jump to jumpIfEmpty
            { state with pc := jumpIfEmpty }
          else
            -- Position cursor at first row
            let cursor' := { cursor with position := some 0, direction := .forward }
            { state with
              cursors := state.cursors.set cursorId cursor',
              pc := state.pc + 1 }

    | .column cursorId colIdx destReg =>
      match getCursorColumn state cursorId colIdx with
      | none =>
        -- Column not found, store NULL (SQLite behavior)
        { state with
          registers := state.registers.set destReg Value.null,
          pc := state.pc + 1 }
      | some value =>
        { state with
          registers := state.registers.set destReg value,
          pc := state.pc + 1 }

    | .resultRow startReg numRegs =>
      -- Collect registers into a result row
      let row := List.range numRegs |>.map fun i => state.registers.get (startReg + i)
      { state with
        output := state.output ++ [row],
        pc := state.pc + 1 }

    | .next cursorId jumpIfMore =>
      match state.cursors cursorId with
      | none => { state with status := .error s!"Cursor {cursorId} not open" }
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
                cursors := state.cursors.set cursorId cursor',
                pc := jumpIfMore }
            else
              -- No more rows, continue to next instruction
              { state with pc := state.pc + 1 }

    | .prev cursorId jumpIfMore =>
      match state.cursors cursorId with
      | none => { state with status := .error s!"Cursor {cursorId} not open" }
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
                cursors := state.cursors.set cursorId cursor',
                pc := jumpIfMore }
            else
              -- No more rows, continue to next instruction
              { state with pc := state.pc + 1 }

    | .halt resultCode _ =>
      { state with status := .halted resultCode }

    | .transaction _dbId _writeFlag _schemaVersion =>
      -- For now, transaction is a no-op (we assume database is already available)
      { state with pc := state.pc + 1 }

    | .goto p2 =>
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
  | 0 => { state with status := .error "Out of fuel" }
  | fuel' + 1 =>
    match state.status with
    | .halted _ | .error _ => state
    | .running => runBounded program (step program state) fuel'

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
