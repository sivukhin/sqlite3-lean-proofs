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

/-! ## Example: SELECT * FROM t -/

/--
  The program for: SELECT * FROM t

  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     7     0                    0   Start at 7
  1     OpenRead       0     2     0     1              0   root=2 iDb=0; t
  2     Rewind         0     6     0                    0
  3       Column         0     0     1                    0   r[1]= cursor 0 column 0
  4       ResultRow      1     1     0                    0   output=r[1]
  5     Next           0     3     0                    1
  6     Halt           0     0     0                    0
  7     Transaction    0     0     1     0              1   usesStmtJournal=0
  8     Goto           0     1     0                    0
-/
def selectAllProgram : Program := #[
  .init 0 7,              -- 0: Jump to 7 (Transaction)
  .openRead 0 2 0 1,      -- 1: Open cursor 0 on btree 2
  .rewind 0 6,            -- 2: Rewind cursor 0, jump to 6 if empty
  .column 0 0 1,          -- 3: Read column 0 from cursor 0 into register 1
  .resultRow 1 1,         -- 4: Output register 1 as result row
  .next 0 3,              -- 5: Next row, jump to 3 if more rows
  .halt 0 0,              -- 6: Halt with success
  .transaction 0 0 1,     -- 7: Begin read transaction
  .goto 1                 -- 8: Goto 1 (OpenRead)
]

/-- Example database with table t (btree id 2) containing some rows -/
def exampleDatabase : Database := fun btreeId =>
  if btreeId == 2 then
    some {
      id := 2,
      keyLength := 1,  -- Rowid is the key
      tuples := [
        [.integer 1],
        [.integer 2],
        [.integer 3]
      ]
    }
  else
    none

/-- Run the SELECT * FROM t example -/
def runSelectExample : VMState :=
  let initialState := mkInitialState exampleDatabase
  runBounded selectAllProgram initialState 100

#eval runSelectExample.output
-- Expected: [[integer 1], [integer 2], [integer 3]]

#eval runSelectExample.status
-- Expected: halted 0

/-! ## Termination Proof for selectAllProgram -/

/--
  Compute the number of remaining rows to process based on cursor state.
  This looks at cursor 0 (the cursor used by selectAllProgram) and determines
  how many rows are left to iterate over.
-/
def remainingRows (state : VMState) : Nat :=
  match state.cursors 0 with
  | none => match state.database 2 with
    | none => 0
    | some btree => btree.tuples.length
  | some cursor => match state.database cursor.btreeId with
    | none => 0
    | some btree => match cursor.position with
      | none => btree.tuples.length
      | some pos => btree.tuples.length - pos

/--
  Phase offset assigns a value to each PC based on its position in the execution flow.
  Higher values = earlier in execution within a "phase".

  Execution order: 0 → 7 → 8 → 1 → 2 → (3 → 4 → 5)* → 6

  The key property: within a single "pass" (pre-loop, one loop iteration, or post-loop),
  phaseOffset strictly decreases as PC advances.
-/
def phaseOffset (pc : Nat) : Nat :=
  match pc with
  | 0 => 9  -- Init
  | 7 => 8  -- Transaction
  | 8 => 7  -- Goto
  | 1 => 6  -- OpenRead
  | 2 => 5  -- Rewind
  | 3 => 4  -- Column (loop body start)
  | 4 => 3  -- ResultRow
  | 5 => 2  -- Next (loop body end)
  | 6 => 1  -- Halt
  | _ => 1  -- Invalid PC (will error, but gas > 0 ensures decrease to error state)

/--
  The "gas" (or measure) function for proving termination of selectAllProgram.

  Gas = remainingRows * loopCost + phaseOffset

  Key properties:
  1. Gas is always ≥ 0 (it's a Nat)
  2. Gas is > 0 for any running state
  3. Gas strictly decreases on every step
  4. Gas = 0 only for halted/error states

  loopCost (10) is chosen to be larger than the maximum phaseOffset (9),
  ensuring that when remainingRows decreases by 1 (on Next with more rows),
  the overall gas decreases even though phaseOffset might increase.
-/
def selectAllGas (state : VMState) : Nat :=
  match state.status with
  | .halted _ | .error _ => 0
  | .running =>
    let rows := remainingRows state
    let loopCost := 10
    let offset := phaseOffset state.pc
    rows * loopCost + offset

/-- Gas is always non-negative (trivial since it's a Nat) -/
theorem selectAllGas_nonneg (state : VMState) : selectAllGas state ≥ 0 := Nat.zero_le _

/-- phaseOffset is always at least 1 -/
theorem phaseOffset_pos (pc : Nat) : phaseOffset pc ≥ 1 := by
  unfold phaseOffset
  split <;> omega

/-- Gas is positive for any running state -/
theorem selectAllGas_pos_of_running (state : VMState) (h : state.status = .running) :
    selectAllGas state > 0 := by
  unfold selectAllGas
  simp only [h]
  have hOffset : phaseOffset state.pc ≥ 1 := phaseOffset_pos state.pc
  omega

/-- selectAllProgram has exactly 9 instructions (indices 0-8) -/
theorem selectAllProgram_size : selectAllProgram.size = 9 := rfl

/-- Get the opcode at each index in selectAllProgram -/
theorem selectAllProgram_at_0 : selectAllProgram[0]? = some (.init 0 7) := rfl
theorem selectAllProgram_at_1 : selectAllProgram[1]? = some (.openRead 0 2 0 1) := rfl
theorem selectAllProgram_at_2 : selectAllProgram[2]? = some (.rewind 0 6) := rfl
theorem selectAllProgram_at_3 : selectAllProgram[3]? = some (.column 0 0 1) := rfl
theorem selectAllProgram_at_4 : selectAllProgram[4]? = some (.resultRow 1 1) := rfl
theorem selectAllProgram_at_5 : selectAllProgram[5]? = some (.next 0 3) := rfl
theorem selectAllProgram_at_6 : selectAllProgram[6]? = some (.halt 0 0) := rfl
theorem selectAllProgram_at_7 : selectAllProgram[7]? = some (.transaction 0 0 1) := rfl
theorem selectAllProgram_at_8 : selectAllProgram[8]? = some (.goto 1) := rfl

/-! ### Opcode PC behavior lemmas -/

/-- openRead always increments PC by 1 -/
theorem executeOpcode_openRead_pc (cursorId rootPage dbId numColumns : Nat) (state : VMState)
    (hRunning : state.status = .running) :
    (executeOpcode (.openRead cursorId rootPage dbId numColumns) state).pc = state.pc + 1 := by
  simp [executeOpcode, hRunning]

/-- column always increments PC by 1 -/
theorem executeOpcode_column_pc (cursorId colIdx destReg : Nat) (state : VMState)
    (hRunning : state.status = .running) :
    (executeOpcode (.column cursorId colIdx destReg) state).pc = state.pc + 1 := by
  simp [executeOpcode, hRunning, getCursorColumn]
  split <;> rfl

/-- resultRow always increments PC by 1 -/
theorem executeOpcode_resultRow_pc (startReg numRegs : Nat) (state : VMState)
    (hRunning : state.status = .running) :
    (executeOpcode (.resultRow startReg numRegs) state).pc = state.pc + 1 := by
  simp [executeOpcode, hRunning]

/-- transaction always increments PC by 1 -/
theorem executeOpcode_transaction_pc (dbId writeFlag schemaVersion : Nat) (state : VMState)
    (hRunning : state.status = .running) :
    (executeOpcode (.transaction dbId writeFlag schemaVersion) state).pc = state.pc + 1 := by
  simp [executeOpcode, hRunning]

/-- init always jumps to p2 -/
theorem executeOpcode_init_pc (p1 p2 : Nat) (state : VMState)
    (hRunning : state.status = .running) :
    (executeOpcode (.init p1 p2) state).pc = p2 := by
  simp [executeOpcode, hRunning]

/-- goto always jumps to p2 -/
theorem executeOpcode_goto_pc (p2 : Nat) (state : VMState)
    (hRunning : state.status = .running) :
    (executeOpcode (.goto p2) state).pc = p2 := by
  simp [executeOpcode, hRunning]

/-- halt sets status to halted -/
theorem executeOpcode_halt_status (resultCode errorAction : Nat) (state : VMState)
    (hRunning : state.status = .running) :
    (executeOpcode (.halt resultCode errorAction) state).status = .halted resultCode := by
  simp [executeOpcode, hRunning]

/-- openRead preserves status as running -/
theorem executeOpcode_openRead_status (cursorId rootPage dbId numColumns : Nat) (state : VMState)
    (hRunning : state.status = .running) :
    (executeOpcode (.openRead cursorId rootPage dbId numColumns) state).status = .running := by
  simp [executeOpcode, hRunning]

/-- column preserves status as running -/
theorem executeOpcode_column_status (cursorId colIdx destReg : Nat) (state : VMState)
    (hRunning : state.status = .running) :
    (executeOpcode (.column cursorId colIdx destReg) state).status = .running := by
  simp [executeOpcode, hRunning, getCursorColumn]
  split <;> rfl

/-- resultRow preserves status as running -/
theorem executeOpcode_resultRow_status (startReg numRegs : Nat) (state : VMState)
    (hRunning : state.status = .running) :
    (executeOpcode (.resultRow startReg numRegs) state).status = .running := by
  simp [executeOpcode, hRunning]

/-- transaction preserves status as running -/
theorem executeOpcode_transaction_status (dbId writeFlag schemaVersion : Nat) (state : VMState)
    (hRunning : state.status = .running) :
    (executeOpcode (.transaction dbId writeFlag schemaVersion) state).status = .running := by
  simp [executeOpcode, hRunning]

/-- init preserves status as running -/
theorem executeOpcode_init_status (p1 p2 : Nat) (state : VMState)
    (hRunning : state.status = .running) :
    (executeOpcode (.init p1 p2) state).status = .running := by
  simp [executeOpcode, hRunning]

/-- goto preserves status as running -/
theorem executeOpcode_goto_status (p2 : Nat) (state : VMState)
    (hRunning : state.status = .running) :
    (executeOpcode (.goto p2) state).status = .running := by
  simp [executeOpcode, hRunning]

/-! ### phaseOffset value lemmas -/

@[simp] theorem phaseOffset_0 : phaseOffset 0 = 9 := rfl
@[simp] theorem phaseOffset_1 : phaseOffset 1 = 6 := rfl
@[simp] theorem phaseOffset_2 : phaseOffset 2 = 5 := rfl
@[simp] theorem phaseOffset_3 : phaseOffset 3 = 4 := rfl
@[simp] theorem phaseOffset_4 : phaseOffset 4 = 3 := rfl
@[simp] theorem phaseOffset_5 : phaseOffset 5 = 2 := rfl
@[simp] theorem phaseOffset_6 : phaseOffset 6 = 1 := rfl
@[simp] theorem phaseOffset_7 : phaseOffset 7 = 8 := rfl
@[simp] theorem phaseOffset_8 : phaseOffset 8 = 7 := rfl

/-! ### State invariant for selectAllProgram -/

/--
  Invariant for selectAllProgram execution states.
  Captures the relationship between PC and cursor state:
  - Before OpenRead (pc ∈ {0, 7, 8, 1}): cursor 0 doesn't exist
  - After OpenRead (pc ∈ {2, 3, 4, 5, 6}): cursor 0 exists with btreeId = 2
-/
def selectAllInvariant (state : VMState) : Prop :=
  -- If cursor 0 exists, it points to btree 2
  (∀ cursor, state.cursors 0 = some cursor → cursor.btreeId = 2) ∧
  -- Before OpenRead executes, cursor 0 doesn't exist
  (state.pc ∈ [0, 7, 8, 1] → state.cursors 0 = none)

/-- Initial state satisfies the invariant -/
theorem selectAllInvariant_initial (db : Database) :
    selectAllInvariant (mkInitialState db) := by
  simp [selectAllInvariant, mkInitialState, Cursors.empty]

/-- The invariant is preserved by step -/
theorem selectAllInvariant_preserved (state : VMState)
    (hInv : selectAllInvariant state)
    (hRunning : state.status = .running)
    (hValidPc : state.pc < selectAllProgram.size) :
    selectAllInvariant (step selectAllProgram state) := by
  simp only [selectAllProgram_size] at hValidPc
  have hPc : state.pc = 0 ∨ state.pc = 1 ∨ state.pc = 2 ∨ state.pc = 3 ∨
             state.pc = 4 ∨ state.pc = 5 ∨ state.pc = 6 ∨ state.pc = 7 ∨ state.pc = 8 := by omega
  simp only [selectAllInvariant] at hInv ⊢
  obtain ⟨hCursorBtree, hNoCursorBefore⟩ := hInv
  rcases hPc with h | h | h | h | h | h | h | h | h
  -- pc = 0: Init → pc = 7, cursors unchanged
  · simp [step, hRunning, h, selectAllProgram_at_0, executeOpcode]
    exact ⟨hCursorBtree, hNoCursorBefore (by simp [h])⟩
  -- pc = 1: OpenRead → pc = 2, cursor 0 := ⟨2, none, forward⟩
  · simp only [step, hRunning, h, selectAllProgram_at_1, executeOpcode, Cursors.set]
    constructor
    · intro cursor hCursor
      simp only [beq_self_eq_true, ↓reduceIte, Option.some.injEq] at hCursor
      rw [← hCursor]
    · simp
  -- pc = 2: Rewind → pc = 3 or 6, need to case split
  · simp only [step, hRunning, h, selectAllProgram_at_2, executeOpcode]
    split
    · -- cursor not open → error, but cursors unchanged
      exact ⟨hCursorBtree, by simp⟩
    · rename_i cursor hCursor
      split
      · -- btree not found → error, but cursors unchanged
        exact ⟨hCursorBtree, by simp⟩
      · rename_i btree hBtree
        split
        · -- btree empty → pc = 6
          exact ⟨hCursorBtree, by simp⟩
        · -- btree non-empty → pc = 3, cursor position := 0
          simp only [Cursors.set]
          constructor
          · intro c hc
            simp only [beq_self_eq_true, ↓reduceIte, Option.some.injEq] at hc
            rw [← hc]
            exact hCursorBtree cursor hCursor
          · simp
  -- pc = 3: Column → pc = 4, cursors unchanged
  · simp only [step, hRunning, h, selectAllProgram_at_3, executeOpcode, getCursorColumn]
    split <;> exact ⟨hCursorBtree, by simp⟩
  -- pc = 4: ResultRow → pc = 5, cursors unchanged
  · simp only [step, hRunning, h, selectAllProgram_at_4, executeOpcode]
    exact ⟨hCursorBtree, by simp⟩
  -- pc = 5: Next → pc = 3 or 6, need to case split
  · simp only [step, hRunning, h, selectAllProgram_at_5, executeOpcode]
    split
    · exact ⟨hCursorBtree, by simp⟩  -- cursor not open → error
    · rename_i cursor hCursor
      split
      · exact ⟨hCursorBtree, by simp⟩  -- btree not found → error
      · rename_i btree hBtree
        split
        · exact ⟨hCursorBtree, by simp⟩  -- cursor not positioned → error
        · rename_i pos hPos
          split
          · -- more rows → pc = 3, cursor position := pos + 1
            simp only [Cursors.set]
            constructor
            · intro c hc
              simp only [beq_self_eq_true, ↓reduceIte, Option.some.injEq] at hc
              rw [← hc]
              exact hCursorBtree cursor hCursor
            · simp
          · -- no more rows → pc = 6
            exact ⟨hCursorBtree, by simp⟩
  -- pc = 6: Halt → status = halted
  · simp only [step, hRunning, h, selectAllProgram_at_6, executeOpcode]
    exact ⟨hCursorBtree, by simp⟩
  -- pc = 7: Transaction → pc = 8, cursors unchanged
  · simp [step, hRunning, h, selectAllProgram_at_7, executeOpcode]
    exact ⟨hCursorBtree, hNoCursorBefore (by simp [h])⟩
  -- pc = 8: Goto → pc = 1, cursors unchanged
  · simp [step, hRunning, h, selectAllProgram_at_8, executeOpcode]
    exact ⟨hCursorBtree, hNoCursorBefore (by simp [h])⟩

/--
  At pc=2 (Rewind), cursor 0 has position = none.
  This is because we just executed OpenRead which creates the cursor with position = none.
-/
def rewindPositionInvariant (state : VMState) : Prop :=
  state.pc = 2 → ∀ cursor, state.cursors 0 = some cursor → cursor.position = none

/-- Initial state satisfies rewindPositionInvariant (vacuously, since pc = 0) -/
theorem rewindPositionInvariant_initial (db : Database) :
    rewindPositionInvariant (mkInitialState db) := by
  simp [rewindPositionInvariant, mkInitialState]

/-- rewindPositionInvariant is preserved by step -/
theorem rewindPositionInvariant_preserved (state : VMState)
    (hRewind : rewindPositionInvariant state)
    (hRunning : state.status = .running)
    (hValidPc : state.pc < selectAllProgram.size) :
    rewindPositionInvariant (step selectAllProgram state) := by
  simp only [selectAllProgram_size] at hValidPc
  simp only [rewindPositionInvariant] at hRewind ⊢
  have hPc : state.pc = 0 ∨ state.pc = 1 ∨ state.pc = 2 ∨ state.pc = 3 ∨
             state.pc = 4 ∨ state.pc = 5 ∨ state.pc = 6 ∨ state.pc = 7 ∨ state.pc = 8 := by omega
  rcases hPc with h | h | h | h | h | h | h | h | h
  -- pc = 0: new pc = 7 ≠ 2
  · simp [step, hRunning, h, selectAllProgram_at_0, executeOpcode]
  -- pc = 1: OpenRead → pc = 2, cursor 0 := ⟨2, none, forward⟩
  · simp only [step, hRunning, h, selectAllProgram_at_1, executeOpcode, Cursors.set]
    intro _ cursor hCursor
    simp only [beq_self_eq_true, ↓reduceIte, Option.some.injEq] at hCursor
    rw [← hCursor]
  -- pc = 2: Rewind → new pc = 3 or 6, both ≠ 2
  · simp only [step, hRunning, h, selectAllProgram_at_2, executeOpcode]
    cases hCursor : state.cursors 0 with
    | none =>
      -- Error state: cursors unchanged, still none, so vacuously true
      simp only [hCursor]
      intro _ c hc; simp at hc
    | some cursor =>
      cases hBtree : state.database cursor.btreeId with
      | none =>
        -- Error state: cursors unchanged
        simp only [hBtree]
        intro _ c hc
        have : c = cursor := by simp [hCursor] at hc; exact hc.symm
        rw [this]
        exact hRewind h cursor hCursor
      | some btree =>
        simp only [hBtree]
        by_cases hEmpty : btree.tuples.isEmpty
        · -- Empty: pc = 6 ≠ 2
          simp only [hEmpty, ↓reduceIte]
          intro hPc2; simp at hPc2
        · -- Non-empty: pc = 3 ≠ 2
          simp only [hEmpty]
          intro hPc2; simp at hPc2
  -- pc = 3: new pc = 4 ≠ 2
  · simp [step, hRunning, h, selectAllProgram_at_3, executeOpcode, getCursorColumn]
    split <;> simp
  -- pc = 4: new pc = 5 ≠ 2
  · simp [step, hRunning, h, selectAllProgram_at_4, executeOpcode]
  -- pc = 5: new pc = 3 or 6 ≠ 2
  · simp only [step, hRunning, h, selectAllProgram_at_5, executeOpcode]
    cases hCursor5 : state.cursors 0 with
    | none => simp
    | some cursor =>
      cases hBtree5 : state.database cursor.btreeId with
      | none => simp [hBtree5]
      | some btree =>
        simp only [hBtree5]
        cases hPos5 : cursor.position with
        | none => simp
        | some pos =>
          simp only
          by_cases hMore : pos + 1 < btree.tuples.length <;> simp [hMore]
  -- pc = 6: Halt → status = halted (not running)
  · simp [step, hRunning, h, selectAllProgram_at_6, executeOpcode]
  -- pc = 7: new pc = 8 ≠ 2
  · simp [step, hRunning, h, selectAllProgram_at_7, executeOpcode]
  -- pc = 8: new pc = 1 ≠ 2
  · simp [step, hRunning, h, selectAllProgram_at_8, executeOpcode]

/-! ### remainingRows lemmas -/

/-- remainingRows only depends on cursors and database, not on pc/registers/output/status -/
theorem remainingRows_eq_of_cursors_database (s1 s2 : VMState)
    (hCursors : s1.cursors = s2.cursors)
    (hDb : s1.database = s2.database) :
    remainingRows s1 = remainingRows s2 := by
  simp only [remainingRows, hCursors, hDb]

/-- After OpenRead on cursor 0 with btree 2, when cursor 0 didn't exist before,
    remainingRows is preserved (because position is none, so we look at database 2's length) -/
theorem remainingRows_after_openRead_cursor0 (state : VMState)
    (hNoCursor : state.cursors 0 = none) :
    remainingRows { state with cursors := state.cursors.set 0 ⟨2, none, .forward⟩ } =
    remainingRows state := by
  simp [remainingRows, Cursors.set, hNoCursor]

/-- Column doesn't change cursors or database -/
theorem remainingRows_after_column (state : VMState) (cursorId colIdx destReg : Nat)
    (hRunning : state.status = .running) :
    remainingRows (executeOpcode (.column cursorId colIdx destReg) state) =
    remainingRows state := by
  simp only [executeOpcode, hRunning, getCursorColumn]
  split <;> rfl

/-- ResultRow doesn't change cursors or database -/
theorem remainingRows_after_resultRow (state : VMState) (startReg numRegs : Nat)
    (hRunning : state.status = .running) :
    remainingRows (executeOpcode (.resultRow startReg numRegs) state) =
    remainingRows state := by
  simp only [executeOpcode, hRunning]
  rfl

/--
  Helper: executing an opcode on selectAllProgram results in gas decrease.
  This is the core lemma for the termination proof.

  The proof proceeds by case analysis on state.pc ∈ {0,1,2,3,4,5,6,7,8}.
  For each case, we show that the gas strictly decreases.
-/
theorem selectAllGas_decreases_step (state : VMState)
    (hInv : selectAllInvariant state)
    (hRewind : rewindPositionInvariant state)
    (hRunning : state.status = .running)
    (hValidPc : state.pc < selectAllProgram.size) :
    selectAllGas (step selectAllProgram state) < selectAllGas state := by
  -- Establish pc ∈ {0..8}
  simp only [selectAllProgram_size] at hValidPc
  have hPc : state.pc = 0 ∨
             state.pc = 1 ∨
             state.pc = 2 ∨
             state.pc = 3 ∨
             state.pc = 4 ∨
             state.pc = 5 ∨
             state.pc = 6 ∨
             state.pc = 7 ∨
             state.pc = 8 := by omega
  rcases hPc with h | h | h | h | h | h | h | h | h
  -- Case pc = 0: Init 0 7 → jump to pc = 7
  · simp [step, hRunning, h, selectAllProgram_at_0, executeOpcode]
    simp [h, selectAllGas, hRunning, phaseOffset, remainingRows]
  -- Case pc = 1: OpenRead → pc = 2
  -- Use invariant: at pc=1, cursor 0 doesn't exist
  · have hNoCursor : state.cursors 0 = none := hInv.2 (by simp [h])
    simp only [step, hRunning, h, selectAllProgram_at_1, executeOpcode]
    simp only [selectAllGas, hRunning, remainingRows, Cursors.set, h]
    simp only [beq_self_eq_true, ↓reduceIte, hNoCursor, phaseOffset]
    omega
  -- Case pc = 2: Rewind → pc = 3 or pc = 6
  · simp only [step, hRunning, h, selectAllProgram_at_2, executeOpcode]
    cases hCursor : state.cursors 0 with
    | none =>
      -- Error case: gas becomes 0, which is less than positive gas
      simp only [selectAllGas, hRunning, h, remainingRows, hCursor, phaseOffset]
      omega
    | some cursor =>
      cases hBtree : state.database cursor.btreeId with
      | none =>
        -- Error case: gas becomes 0
        simp only [hBtree, selectAllGas, hRunning, h, remainingRows, hCursor, phaseOffset]
        omega
      | some btree =>
        simp only [hBtree]
        have hBtreeId := hInv.1 cursor hCursor
        have hPosNone := hRewind h cursor hCursor
        have hDb2 : state.database 2 = some btree := by rw [← hBtreeId]; exact hBtree
        by_cases hEmpty : btree.tuples.isEmpty
        · -- Empty btree: jump to pc = 6
          simp only [hEmpty, ↓reduceIte, selectAllGas, remainingRows, hCursor, hBtreeId, hPosNone,
                     phaseOffset, hRunning, h, hDb2]
          have hLen : btree.tuples.length = 0 :=
            List.length_eq_zero_iff.mpr (List.isEmpty_iff.mp hEmpty)
          omega
        · -- Non-empty btree: pc = 3, cursor position := 0
          have hNotEmpty : btree.tuples.isEmpty = false := Bool.eq_false_iff.mpr hEmpty
          simp only [hNotEmpty, Bool.false_eq_true, ↓reduceIte, selectAllGas, Cursors.set,
                     beq_self_eq_true, remainingRows, hBtreeId, hCursor, hPosNone, phaseOffset,
                     hRunning, h, hDb2]
          have hLen : btree.tuples.length > 0 :=
            List.length_pos_iff.mpr (List.isEmpty_eq_false_iff.mp hNotEmpty)
          omega
  -- Case pc = 3: Column → pc = 4
  · simp only [step, hRunning, h, selectAllProgram_at_3, executeOpcode, getCursorColumn]
    -- Column doesn't change cursors or database, so remainingRows is preserved
    -- But phaseOffset decreases from 4 to 3
    cases hCol : getCursorTuple state 0 >>= fun t => t[0]? with
    | none =>
      simp only [selectAllGas, remainingRows, phaseOffset, hRunning, h]
      omega
    | some val =>
      simp only [selectAllGas, remainingRows, phaseOffset, hRunning, h]
      omega
  -- Case pc = 4: ResultRow → pc = 5
  · simp [step, hRunning, h, selectAllProgram_at_4, executeOpcode]
    simp [h, selectAllGas, hRunning, phaseOffset, remainingRows]
  -- Case pc = 5: Next → pc = 3 (more rows) or pc = 6 (done)
  · simp only [step, hRunning, h, selectAllProgram_at_5, executeOpcode]
    cases hCursor : state.cursors 0 with
    | none =>
      -- Error case: gas becomes 0
      simp only [selectAllGas, hRunning, h, remainingRows, hCursor, phaseOffset]
      omega
    | some cursor =>
      cases hBtree : state.database cursor.btreeId with
      | none =>
        -- Error case: gas becomes 0
        simp only [hBtree, selectAllGas, hRunning, h, remainingRows, hCursor, phaseOffset]
        omega
      | some btree =>
        simp only [hBtree]
        have hBtreeId := hInv.1 cursor hCursor
        have hDb2 : state.database 2 = some btree := by rw [← hBtreeId]; exact hBtree
        cases hPos : cursor.position with
        | none =>
          -- Error case: cursor not positioned
          simp only [selectAllGas, hRunning, h, remainingRows, hCursor, hBtreeId, hDb2, phaseOffset]
          omega
        | some pos =>
          by_cases hMore : pos + 1 < btree.tuples.length
          · -- More rows: pc = 3, position := pos + 1
            -- remainingRows decreases: (length - pos) → (length - (pos + 1))
            -- phaseOffset increases: 2 → 4
            -- But loopCost (10) > max phaseOffset (9), so gas still decreases
            simp only [hMore, ↓reduceIte, selectAllGas, Cursors.set, beq_self_eq_true,
                       remainingRows, hBtreeId, hCursor, hDb2, phaseOffset, hRunning, h, hPos]
            -- Gas before: (btree.tuples.length - pos) * 10 + 2
            -- Gas after:  (btree.tuples.length - (pos + 1)) * 10 + 4
            omega
          · -- No more rows: pc = 6, position unchanged
            -- phaseOffset decreases: 2 → 1
            simp only [hMore, ↓reduceIte, selectAllGas, remainingRows,
                       hCursor, hBtreeId, hDb2, hPos, phaseOffset, hRunning, h]
            omega
  -- Case pc = 6: Halt → status = halted, gas = 0
  · simp only [step, hRunning, h, selectAllProgram_at_6, executeOpcode, selectAllGas, phaseOffset_6]
    have hGasPos := selectAllGas_pos_of_running state hRunning
    simp only [selectAllGas, hRunning, h] at hGasPos
    exact hGasPos
  -- Case pc = 7: Transaction → pc = 8
  · simp [step, hRunning, h, selectAllProgram_at_7, executeOpcode]
    simp [h, selectAllGas, hRunning, phaseOffset, remainingRows]
  -- Case pc = 8: Goto 1 → pc = 1
  · simp [step, hRunning, h, selectAllProgram_at_8, executeOpcode]
    simp [h, selectAllGas, hRunning, phaseOffset, remainingRows]

/-! ## Termination Proof for selectAllProgram -/

/-- Helper: Array indexing returns none when out of bounds -/
theorem array_getElem?_ge_size {α : Type u} (a : Array α) (i : Nat) (h : i ≥ a.size) :
    a[i]? = none := by
  rw [Array.getElem?_eq_none_iff]
  omega

/-- If PC is out of bounds, step produces an error state -/
theorem step_invalid_pc (state : VMState)
    (hRunning : state.status = .running)
    (hInvalidPc : state.pc ≥ selectAllProgram.size) :
    (step selectAllProgram state).status = .error s!"Invalid PC: {state.pc}" := by
  simp only [step, hRunning, selectAllProgram_size] at *
  have hNone : selectAllProgram[state.pc]? = none := array_getElem?_ge_size _ _ hInvalidPc
  simp [hNone]

/-- Gas becomes 0 for non-running states -/
theorem selectAllGas_zero_of_not_running (state : VMState)
    (h : state.status ≠ .running) : selectAllGas state = 0 := by
  simp only [selectAllGas]
  cases hStatus : state.status with
  | running => exact absurd hStatus h
  | halted _ => rfl
  | error _ => rfl

/-- Combined invariant for selectAllProgram -/
def selectAllCombinedInvariant (state : VMState) : Prop :=
  selectAllInvariant state ∧ rewindPositionInvariant state

/-- Initial state satisfies combined invariant -/
theorem selectAllCombinedInvariant_initial (db : Database) :
    selectAllCombinedInvariant (mkInitialState db) :=
  ⟨selectAllInvariant_initial db, rewindPositionInvariant_initial db⟩

/-- Combined invariant is preserved by step when PC is valid -/
theorem selectAllCombinedInvariant_preserved (state : VMState)
    (hInv : selectAllCombinedInvariant state)
    (hRunning : state.status = .running)
    (hValidPc : state.pc < selectAllProgram.size) :
    selectAllCombinedInvariant (step selectAllProgram state) :=
  ⟨selectAllInvariant_preserved state hInv.1 hRunning hValidPc,
   rewindPositionInvariant_preserved state hInv.2 hRunning hValidPc⟩

/-- Gas decreases on every step (extended to handle invalid PC) -/
theorem selectAllGas_decreases (state : VMState)
    (hInv : selectAllCombinedInvariant state)
    (hRunning : state.status = .running) :
    selectAllGas (step selectAllProgram state) < selectAllGas state := by
  by_cases hValidPc : state.pc < selectAllProgram.size
  · exact selectAllGas_decreases_step state hInv.1 hInv.2 hRunning hValidPc
  · -- Invalid PC: step produces error, gas becomes 0
    have hInvalidPc : state.pc ≥ selectAllProgram.size := Nat.not_lt.mp hValidPc
    have hError := step_invalid_pc state hRunning hInvalidPc
    have hNotRunning : (step selectAllProgram state).status ≠ .running := by
      simp [hError]
    rw [selectAllGas_zero_of_not_running _ hNotRunning]
    exact selectAllGas_pos_of_running state hRunning

/-- runBounded terminates with halted/error status when given enough fuel -/
theorem runBounded_terminates (state : VMState)
    (hInv : selectAllCombinedInvariant state)
    (fuel : Nat)
    (hFuel : fuel ≥ selectAllGas state) :
    (runBounded selectAllProgram state fuel).status ≠ .running := by
  -- Induction on fuel
  induction fuel generalizing state with
  | zero =>
    -- fuel = 0: out of fuel error
    simp [runBounded]
  | succ n ih =>
    simp only [runBounded]
    cases hStatus : state.status with
    | halted code =>
      simp only [hStatus]
      intro h; cases h
    | error msg =>
      simp only [hStatus]
      intro h; cases h
    | running =>
      -- State is running, we take a step
      -- Apply induction hypothesis to the stepped state
      apply ih
      · -- Invariant preserved
        by_cases hValidPc : state.pc < selectAllProgram.size
        · exact selectAllCombinedInvariant_preserved state hInv hStatus hValidPc
        · -- Invalid PC: step produces error state
          have hInvalidPc : state.pc ≥ selectAllProgram.size := Nat.not_lt.mp hValidPc
          -- For error states, the invariant is preserved (state doesn't actually change, just status)
          simp only [selectAllCombinedInvariant, selectAllInvariant, rewindPositionInvariant]
          simp only [step, hStatus, selectAllProgram_size] at *
          have hNone : selectAllProgram[state.pc]? = none := array_getElem?_ge_size _ _ hInvalidPc
          simp only [hNone]
          -- The invariant is inherited from the original state
          constructor
          · constructor
            · exact hInv.1.1
            · intro hPc
              -- state.pc ∈ [0, 7, 8, 1] but state.pc ≥ 9, contradiction
              simp only [List.mem_cons, List.not_mem_nil, or_false] at hPc
              rcases hPc with h | h | h | h <;> omega
          · intro hPc
            -- state.pc = 2 but state.pc ≥ 9, contradiction
            omega
      · -- Fuel sufficient for stepped state
        have hDecrease := selectAllGas_decreases state hInv hStatus
        omega

/-- Main termination theorem: selectAllProgram terminates for any database -/
theorem selectAllProgram_terminates (db : Database) :
    ∃ n : Nat, (runBounded selectAllProgram (mkInitialState db) n).status ≠ .running := by
  refine ⟨selectAllGas (mkInitialState db), ?_⟩
  exact runBounded_terminates (mkInitialState db) (selectAllCombinedInvariant_initial db)
    (selectAllGas (mkInitialState db)) (Nat.le_refl _)

/-- The final state is either halted or an error -/
theorem selectAllProgram_final_status (db : Database) :
    ∃ n : Nat, match (runBounded selectAllProgram (mkInitialState db) n).status with
      | .halted _ => True
      | .error _ => True
      | .running => False := by
  have ⟨n, hn⟩ := selectAllProgram_terminates db
  refine ⟨n, ?_⟩
  cases h : (runBounded selectAllProgram (mkInitialState db) n).status with
  | halted _ => trivial
  | error _ => trivial
  | running => exact hn h

/-- Compute the required fuel for termination based on database size -/
def selectAllRequiredFuel (db : Database) : Nat :=
  selectAllGas (mkInitialState db)

/-- runBounded with required fuel terminates -/
theorem selectAllProgram_terminates' (db : Database) :
    (runBounded selectAllProgram (mkInitialState db) (selectAllRequiredFuel db)).status ≠ .running :=
  runBounded_terminates (mkInitialState db) (selectAllCombinedInvariant_initial db)
    (selectAllRequiredFuel db) (Nat.le_refl _)

#check selectAllProgram_terminates
-- selectAllProgram_terminates : ∀ (db : Database),
--   ∃ n, (runBounded selectAllProgram (mkInitialState db) n).status ≠ Status.running
