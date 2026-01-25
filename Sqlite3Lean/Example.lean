/-
  Termination Proof for SELECT * FROM t

  This module proves that the VDBE program for "SELECT * FROM t" terminates
  for any database. It demonstrates formal verification of a concrete
  SQLite bytecode program.
-/

import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas
import Sqlite3Lean.Tools

namespace Sqlite3Lean.Example
open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/-! ## Example: SELECT * FROM t -/

/--
  Query: SELECT * FROM t

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
def program : Program := #[
  vdbeInit 0 7 0 "" 0,        -- 0: Jump to 7 (Transaction)
  vdbeOpenRead 0 2 0 "t" 0,   -- 1: Open cursor 0 on btree 2 (table t)
  vdbeRewind 0 6 0 "" 0,      -- 2: Rewind cursor 0, jump to 6 if empty
  vdbeColumn 0 0 1 "" 0,      -- 3: Read column 0 from cursor 0 into register 1
  vdbeResultRow 1 1 0 "" 0,   -- 4: Output register 1 as result row
  vdbeNext 0 3 0 "" 1,        -- 5: Next row, jump to 3 if more rows
  vdbeHalt 0 0 0 "" 0,        -- 6: Halt with success
  vdbeTransaction 0 0 1 "0" 1, -- 7: Begin read transaction
  vdbeGoto 0 1 0 "" 0         -- 8: Goto 1 (OpenRead)
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
  runBounded program initialState 100

#eval runSelectExample.output
-- Expected: [[integer 1], [integer 2], [integer 3]]

#eval runSelectExample.status
-- Expected: halted 0

/-! ## Termination Proof for program -/

/--
  Compute the number of remaining rows to process based on cursor state.
  This looks at cursor 0 (the cursor used by program) and determines
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
  The "gas" (or measure) function for proving termination of program.

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
def program_gas (state : VMState) : Nat :=
  match state.status with
  | .halted _ | .error _ => 0
  | .running => remainingRows state * 10 + phaseOffset state.pc

/-- Gas is always non-negative (trivial since it's a Nat) -/
theorem program_gas_nonneg (state : VMState) : program_gas state ≥ 0 := Nat.zero_le _

/-- phaseOffset is always at least 1 -/
theorem phaseOffset_pos (pc : Nat) : phaseOffset pc ≥ 1 := by
  unfold phaseOffset
  split <;> omega

/-- Gas is positive for any running state -/
theorem program_gas_pos_of_running (state : VMState) (h : state.status = .running) :
    program_gas state > 0 := by
  unfold program_gas
  simp only [h]
  have hOffset : phaseOffset state.pc ≥ 1 := phaseOffset_pos state.pc
  omega

/-- program has exactly 9 instructions (indices 0-8) -/
theorem program_size : program.size = 9 := rfl

/-- Get the opcode at each index in program -/
theorem program_at_0 : program[0]? = some (.init 0 7 0 "" 0) := rfl
theorem program_at_1 : program[1]? = some (.openRead 0 2 0 "t" 0) := rfl
theorem program_at_2 : program[2]? = some (.rewind 0 6 0 "" 0) := rfl
theorem program_at_3 : program[3]? = some (.column 0 0 1 "" 0) := rfl
theorem program_at_4 : program[4]? = some (.resultRow 1 1 0 "" 0) := rfl
theorem program_at_5 : program[5]? = some (.next 0 3 0 "" 1) := rfl
theorem program_at_6 : program[6]? = some (.halt 0 0 0 "" 0) := rfl
theorem program_at_7 : program[7]? = some (.transaction 0 0 1 "0" 1) := rfl
theorem program_at_8 : program[8]? = some (.goto 0 1 0 "" 0) := rfl

/-! ### Opcode PC behavior lemmas -/

/-- openRead always increments PC by 1 -/
theorem executeOpcode_openRead_pc (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) (state : VMState)
    (hRunning : state.status = .running) :
    (executeOpcode (.openRead p1 p2 p3 p4 p5) state).pc = state.pc + 1 := by
  simp [executeOpcode, hRunning]

/-- column always increments PC by 1 -/
theorem executeOpcode_column_pc (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) (state : VMState)
    (hRunning : state.status = .running) :
    (executeOpcode (.column p1 p2 p3 p4 p5) state).pc = state.pc + 1 := by
  simp [executeOpcode, hRunning, getCursorColumn]
  split <;> rfl

/-- resultRow always increments PC by 1 -/
theorem executeOpcode_resultRow_pc (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) (state : VMState)
    (hRunning : state.status = .running) :
    (executeOpcode (.resultRow p1 p2 p3 p4 p5) state).pc = state.pc + 1 := by
  simp [executeOpcode, hRunning]

/-- transaction always increments PC by 1 -/
theorem executeOpcode_transaction_pc (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) (state : VMState)
    (hRunning : state.status = .running) :
    (executeOpcode (.transaction p1 p2 p3 p4 p5) state).pc = state.pc + 1 := by
  simp [executeOpcode, hRunning]

/-- init always jumps to p2 -/
theorem executeOpcode_init_pc (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) (state : VMState)
    (hRunning : state.status = .running) :
    (executeOpcode (.init p1 p2 p3 p4 p5) state).pc = p2 := by
  simp [executeOpcode, hRunning]

/-- goto always jumps to p2 -/
theorem executeOpcode_goto_pc (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) (state : VMState)
    (hRunning : state.status = .running) :
    (executeOpcode (.goto p1 p2 p3 p4 p5) state).pc = p2 := by
  simp [executeOpcode, hRunning]

/-- halt sets status to halted -/
theorem executeOpcode_halt_status (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) (state : VMState)
    (hRunning : state.status = .running) :
    (executeOpcode (.halt p1 p2 p3 p4 p5) state).status = .halted p1 := by
  simp [executeOpcode, hRunning]

/-- openRead preserves status as running -/
theorem executeOpcode_openRead_status (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) (state : VMState)
    (hRunning : state.status = .running) :
    (executeOpcode (.openRead p1 p2 p3 p4 p5) state).status = .running := by
  simp [executeOpcode, hRunning]

/-- column preserves status as running -/
theorem executeOpcode_column_status (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) (state : VMState)
    (hRunning : state.status = .running) :
    (executeOpcode (.column p1 p2 p3 p4 p5) state).status = .running := by
  simp [executeOpcode, hRunning, getCursorColumn]
  split <;> rfl

/-- resultRow preserves status as running -/
theorem executeOpcode_resultRow_status (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) (state : VMState)
    (hRunning : state.status = .running) :
    (executeOpcode (.resultRow p1 p2 p3 p4 p5) state).status = .running := by
  simp [executeOpcode, hRunning]

/-- transaction preserves status as running -/
theorem executeOpcode_transaction_status (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) (state : VMState)
    (hRunning : state.status = .running) :
    (executeOpcode (.transaction p1 p2 p3 p4 p5) state).status = .running := by
  simp [executeOpcode, hRunning]

/-- init preserves status as running -/
theorem executeOpcode_init_status (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) (state : VMState)
    (hRunning : state.status = .running) :
    (executeOpcode (.init p1 p2 p3 p4 p5) state).status = .running := by
  simp [executeOpcode, hRunning]

/-- goto preserves status as running -/
theorem executeOpcode_goto_status (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) (state : VMState)
    (hRunning : state.status = .running) :
    (executeOpcode (.goto p1 p2 p3 p4 p5) state).status = .running := by
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

/-! ### State invariant for program -/

/--
  Invariant for program execution states.
  Captures the relationship between PC and cursor state:
  - Before OpenRead (pc ∈ {0, 7, 8, 1}): cursor 0 doesn't exist
  - After OpenRead (pc ∈ {2, 3, 4, 5, 6}): cursor 0 exists with btreeId = 2
-/
def programInvariant (state : VMState) : Prop :=
  -- If cursor 0 exists, it points to btree 2
  (∀ cursor, state.cursors 0 = some cursor → cursor.btreeId = 2) ∧
  -- Before OpenRead executes, cursor 0 doesn't exist
  (state.pc ∈ [0, 7, 8, 1] → state.cursors 0 = none)

/-- Initial state satisfies the invariant -/
theorem programInvariant_initial (db : Database) :
    programInvariant (mkInitialState db) := by
  simp [programInvariant, mkInitialState, Cursors.empty]

/-- The invariant is preserved by step -/
theorem programInvariant_preserved (state : VMState)
    (hInv : programInvariant state)
    (hRunning : state.status = .running)
    (hValidPc : state.pc < program.size) :
    programInvariant (step program state) := by
  simp only [program_size] at hValidPc
  have hPc : state.pc = 0 ∨ state.pc = 1 ∨ state.pc = 2 ∨ state.pc = 3 ∨
             state.pc = 4 ∨ state.pc = 5 ∨ state.pc = 6 ∨ state.pc = 7 ∨ state.pc = 8 := by omega
  simp only [programInvariant] at hInv ⊢
  obtain ⟨hCursorBtree, hNoCursorBefore⟩ := hInv
  rcases hPc with h | h | h | h | h | h | h | h | h
  -- pc = 0: Init → pc = 7, cursors unchanged
  · simp [step, hRunning, h, program_at_0, executeOpcode]
    exact ⟨hCursorBtree, hNoCursorBefore (by simp [h])⟩
  -- pc = 1: OpenRead → pc = 2, cursor 0 := ⟨2, none, forward⟩
  · simp only [step, hRunning, h, program_at_1, executeOpcode, Cursors.set]
    constructor
    · intro cursor hCursor
      simp only [beq_self_eq_true, ↓reduceIte, Option.some.injEq] at hCursor
      rw [← hCursor]
    · simp
  -- pc = 2: Rewind → pc = 3 or 6, need to case split
  · simp only [step, hRunning, h, program_at_2, executeOpcode]
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
  · simp only [step, hRunning, h, program_at_3, executeOpcode, getCursorColumn]
    split <;> exact ⟨hCursorBtree, by simp⟩
  -- pc = 4: ResultRow → pc = 5, cursors unchanged
  · simp only [step, hRunning, h, program_at_4, executeOpcode]
    exact ⟨hCursorBtree, by simp⟩
  -- pc = 5: Next → pc = 3 or 6, need to case split
  · simp only [step, hRunning, h, program_at_5, executeOpcode]
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
  · simp only [step, hRunning, h, program_at_6, executeOpcode]
    exact ⟨hCursorBtree, by simp⟩
  -- pc = 7: Transaction → pc = 8, cursors unchanged
  · simp [step, hRunning, h, program_at_7, executeOpcode]
    exact ⟨hCursorBtree, hNoCursorBefore (by simp [h])⟩
  -- pc = 8: Goto → pc = 1, cursors unchanged
  · simp [step, hRunning, h, program_at_8, executeOpcode]
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
    (hValidPc : state.pc < program.size) :
    rewindPositionInvariant (step program state) := by
  simp only [program_size] at hValidPc
  simp only [rewindPositionInvariant] at hRewind ⊢
  have hPc : state.pc = 0 ∨ state.pc = 1 ∨ state.pc = 2 ∨ state.pc = 3 ∨
             state.pc = 4 ∨ state.pc = 5 ∨ state.pc = 6 ∨ state.pc = 7 ∨ state.pc = 8 := by omega
  rcases hPc with h | h | h | h | h | h | h | h | h
  -- pc = 0: new pc = 7 ≠ 2
  · simp [step, hRunning, h, program_at_0, executeOpcode]
  -- pc = 1: OpenRead → pc = 2, cursor 0 := ⟨2, none, forward⟩
  · simp only [step, hRunning, h, program_at_1, executeOpcode, Cursors.set]
    intro _ cursor hCursor
    simp only [beq_self_eq_true, ↓reduceIte, Option.some.injEq] at hCursor
    rw [← hCursor]
  -- pc = 2: Rewind → new pc = 3 or 6, both ≠ 2
  · simp only [step, hRunning, h, program_at_2, executeOpcode]
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
  · simp [step, hRunning, h, program_at_3, executeOpcode, getCursorColumn]
    split <;> simp
  -- pc = 4: new pc = 5 ≠ 2
  · simp [step, hRunning, h, program_at_4, executeOpcode]
  -- pc = 5: new pc = 3 or 6 ≠ 2
  · simp only [step, hRunning, h, program_at_5, executeOpcode]
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
  · simp [step, hRunning, h, program_at_6, executeOpcode]
  -- pc = 7: new pc = 8 ≠ 2
  · simp [step, hRunning, h, program_at_7, executeOpcode]
  -- pc = 8: new pc = 1 ≠ 2
  · simp [step, hRunning, h, program_at_8, executeOpcode]

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
theorem remainingRows_after_column (state : VMState) (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat)
    (hRunning : state.status = .running) :
    remainingRows (executeOpcode (.column p1 p2 p3 p4 p5) state) =
    remainingRows state := by
  simp only [executeOpcode, hRunning, getCursorColumn]
  split <;> rfl

/-- ResultRow doesn't change cursors or database -/
theorem remainingRows_after_resultRow (state : VMState) (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat)
    (hRunning : state.status = .running) :
    remainingRows (executeOpcode (.resultRow p1 p2 p3 p4 p5) state) =
    remainingRows state := by
  simp only [executeOpcode, hRunning]
  rfl

/--
  Helper: executing an opcode on program results in gas decrease.
  This is the core lemma for the termination proof.

  The proof proceeds by case analysis on state.pc ∈ {0,1,2,3,4,5,6,7,8}.
  For each case, we show that the gas strictly decreases.
-/
theorem program_gas_decreases_step (state : VMState)
    (hInv : programInvariant state)
    (hRewind : rewindPositionInvariant state)
    (hRunning : state.status = .running)
    (hValidPc : state.pc < program.size) :
    program_gas (step program state) < program_gas state := by
  -- Establish pc ∈ {0..8}
  simp only [program_size] at hValidPc
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
  · simp [step, hRunning, h, program_at_0, executeOpcode]
    simp [h, program_gas, hRunning, phaseOffset, remainingRows]
  -- Case pc = 1: OpenRead → pc = 2
  -- Use invariant: at pc=1, cursor 0 doesn't exist
  · have hNoCursor : state.cursors 0 = none := hInv.2 (by simp [h])
    simp only [step, hRunning, h, program_at_1, executeOpcode]
    simp only [program_gas, hRunning, remainingRows, Cursors.set, h]
    simp only [beq_self_eq_true, ↓reduceIte, hNoCursor, phaseOffset]
    omega
  -- Case pc = 2: Rewind → pc = 3 or pc = 6
  · simp only [step, hRunning, h, program_at_2, executeOpcode]
    cases hCursor : state.cursors 0 with
    | none =>
      -- Error case: gas becomes 0, which is less than positive gas
      simp only [program_gas, hRunning, h, remainingRows, hCursor, phaseOffset]
      omega
    | some cursor =>
      cases hBtree : state.database cursor.btreeId with
      | none =>
        -- Error case: gas becomes 0
        simp only [hBtree, program_gas, hRunning, h, remainingRows, hCursor, phaseOffset]
        omega
      | some btree =>
        simp only [hBtree]
        have hBtreeId := hInv.1 cursor hCursor
        have hPosNone := hRewind h cursor hCursor
        have hDb2 : state.database 2 = some btree := by rw [← hBtreeId]; exact hBtree
        by_cases hEmpty : btree.tuples.isEmpty
        · -- Empty btree: jump to pc = 6
          simp only [hEmpty, ↓reduceIte, program_gas, remainingRows, hCursor, hBtreeId, hPosNone,
                     phaseOffset, hRunning, h, hDb2]
          have hLen : btree.tuples.length = 0 :=
            List.length_eq_zero_iff.mpr (List.isEmpty_iff.mp hEmpty)
          omega
        · -- Non-empty btree: pc = 3, cursor position := 0
          have hNotEmpty : btree.tuples.isEmpty = false := Bool.eq_false_iff.mpr hEmpty
          simp only [hNotEmpty, Bool.false_eq_true, ↓reduceIte, program_gas, Cursors.set,
                     beq_self_eq_true, remainingRows, hBtreeId, hCursor, hPosNone, phaseOffset,
                     hRunning, h, hDb2]
          have hLen : btree.tuples.length > 0 :=
            List.length_pos_iff.mpr (List.isEmpty_eq_false_iff.mp hNotEmpty)
          omega
  -- Case pc = 3: Column → pc = 4
  · simp only [step, hRunning, h, program_at_3, executeOpcode, getCursorColumn]
    -- Column doesn't change cursors or database, so remainingRows is preserved
    -- But phaseOffset decreases from 4 to 3
    cases hCol : getCursorTuple state 0 >>= fun t => t[0]? with
    | none =>
      simp only [program_gas, remainingRows, phaseOffset, hRunning, h]
      omega
    | some val =>
      simp only [program_gas, remainingRows, phaseOffset, hRunning, h]
      omega
  -- Case pc = 4: ResultRow → pc = 5
  · simp [step, hRunning, h, program_at_4, executeOpcode]
    simp [h, program_gas, hRunning, phaseOffset, remainingRows]
  -- Case pc = 5: Next → pc = 3 (more rows) or pc = 6 (done)
  · simp only [step, hRunning, h, program_at_5, executeOpcode]
    cases hCursor : state.cursors 0 with
    | none =>
      -- Error case: gas becomes 0
      simp only [program_gas, hRunning, h, remainingRows, hCursor, phaseOffset]
      omega
    | some cursor =>
      cases hBtree : state.database cursor.btreeId with
      | none =>
        -- Error case: gas becomes 0
        simp only [hBtree, program_gas, hRunning, h, remainingRows, hCursor, phaseOffset]
        omega
      | some btree =>
        simp only [hBtree]
        have hBtreeId := hInv.1 cursor hCursor
        have hDb2 : state.database 2 = some btree := by rw [← hBtreeId]; exact hBtree
        cases hPos : cursor.position with
        | none =>
          -- Error case: cursor not positioned
          simp only [program_gas, hRunning, h, remainingRows, hCursor, hBtreeId, hDb2, phaseOffset]
          omega
        | some pos =>
          by_cases hMore : pos + 1 < btree.tuples.length
          · -- More rows: pc = 3, position := pos + 1
            -- remainingRows decreases: (length - pos) → (length - (pos + 1))
            -- phaseOffset increases: 2 → 4
            -- But loopCost (10) > max phaseOffset (9), so gas still decreases
            simp only [hMore, ↓reduceIte, program_gas, Cursors.set, beq_self_eq_true,
                       remainingRows, hBtreeId, hCursor, hDb2, phaseOffset, hRunning, h, hPos]
            -- Gas before: (btree.tuples.length - pos) * 10 + 2
            -- Gas after:  (btree.tuples.length - (pos + 1)) * 10 + 4
            omega
          · -- No more rows: pc = 6, position unchanged
            -- phaseOffset decreases: 2 → 1
            simp only [hMore, ↓reduceIte, program_gas, remainingRows,
                       hCursor, hBtreeId, hDb2, hPos, phaseOffset, hRunning, h]
            omega
  -- Case pc = 6: Halt → status = halted, gas = 0
  · simp only [step, hRunning, h, program_at_6, executeOpcode, program_gas, phaseOffset_6]
    have hGasPos := program_gas_pos_of_running state hRunning
    simp only [program_gas, hRunning, h] at hGasPos
    exact hGasPos
  -- Case pc = 7: Transaction → pc = 8
  · simp [step, hRunning, h, program_at_7, executeOpcode]
    simp [h, program_gas, hRunning, phaseOffset, remainingRows]
  -- Case pc = 8: Goto 1 → pc = 1
  · simp [step, hRunning, h, program_at_8, executeOpcode]
    simp [h, program_gas, hRunning, phaseOffset, remainingRows]

/-! ## Termination Proof for program -/

/-- Helper: Array indexing returns none when out of bounds -/
theorem array_getElem?_ge_size {α : Type u} (a : Array α) (i : Nat) (h : i ≥ a.size) :
    a[i]? = none := by
  rw [Array.getElem?_eq_none_iff]
  omega

/-- If PC is out of bounds, step produces an error state -/
theorem step_invalid_pc (state : VMState)
    (hRunning : state.status = .running)
    (hInvalidPc : state.pc ≥ program.size) :
    (step program state).status = .error s!"Invalid PC: {state.pc}" := by
  simp only [step, hRunning, program_size] at *
  have hNone : program[state.pc]? = none := array_getElem?_ge_size _ _ hInvalidPc
  simp [hNone]

/-- Gas becomes 0 for non-running states -/
theorem program_gas_zero_of_not_running (state : VMState)
    (h : state.status ≠ .running) : program_gas state = 0 := by
  simp only [program_gas]
  cases hStatus : state.status with
  | running => exact absurd hStatus h
  | halted _ => rfl
  | error _ => rfl

/-- Combined invariant for program -/
def programCombinedInvariant (state : VMState) : Prop :=
  programInvariant state ∧ rewindPositionInvariant state

/-- Initial state satisfies combined invariant -/
theorem programCombinedInvariant_initial (db : Database) :
    programCombinedInvariant (mkInitialState db) :=
  ⟨programInvariant_initial db, rewindPositionInvariant_initial db⟩

/-- Combined invariant is preserved by step when PC is valid -/
theorem programCombinedInvariant_preserved (state : VMState)
    (hInv : programCombinedInvariant state)
    (hRunning : state.status = .running)
    (hValidPc : state.pc < program.size) :
    programCombinedInvariant (step program state) :=
  ⟨programInvariant_preserved state hInv.1 hRunning hValidPc,
   rewindPositionInvariant_preserved state hInv.2 hRunning hValidPc⟩

/-- Gas decreases on every step (extended to handle invalid PC) -/
theorem program_gas_decreases (state : VMState)
    (hInv : programCombinedInvariant state)
    (hRunning : state.status = .running) :
    program_gas (step program state) < program_gas state := by
  by_cases hValidPc : state.pc < program.size
  · exact program_gas_decreases_step state hInv.1 hInv.2 hRunning hValidPc
  · -- Invalid PC: step produces error, gas becomes 0
    have hInvalidPc : state.pc ≥ program.size := Nat.not_lt.mp hValidPc
    have hError := step_invalid_pc state hRunning hInvalidPc
    have hNotRunning : (step program state).status ≠ .running := by
      simp [hError]
    rw [program_gas_zero_of_not_running _ hNotRunning]
    exact program_gas_pos_of_running state hRunning

/-- runBounded terminates with halted/error status when given enough fuel -/
theorem runBounded_terminates (state : VMState)
    (hInv : programCombinedInvariant state)
    (fuel : Nat)
    (hFuel : fuel ≥ program_gas state) :
    (runBounded program state fuel).status ≠ .running := by
  -- Induction on fuel
  induction fuel generalizing state with
  | zero =>
    -- fuel = 0 means program_gas state = 0, so state is not running
    simp only [runBounded]
    intro hRunning
    have hGasPos := program_gas_pos_of_running state hRunning
    omega
  | succ n ih =>
    -- Use runBounded_step_comm: runBounded state (n+1) = runBounded (step state) n
    rw [VdbeLemmas.runBounded_step_comm]
    cases hStatus : state.status with
    | halted code =>
      -- If state is halted, step state = state, and state is not running
      have hNotRunning : state.status ≠ .running := by simp [hStatus]
      have hStepEq : step program state = state := by simp [step, hStatus]
      rw [hStepEq]
      exact VdbeLemmas.runBounded_preserves_not_running program state n hNotRunning
    | error msg =>
      -- If state is error, step state = state, and state is not running
      have hNotRunning : state.status ≠ .running := by simp [hStatus]
      have hStepEq : step program state = state := by simp [step, hStatus]
      rw [hStepEq]
      exact VdbeLemmas.runBounded_preserves_not_running program state n hNotRunning
    | running =>
      -- State is running, apply IH to step state
      apply ih
      · -- Invariant preserved by step
        by_cases hValidPc : state.pc < program.size
        · exact programCombinedInvariant_preserved state hInv hStatus hValidPc
        · -- Invalid PC: step produces error state
          have hInvalidPc : state.pc ≥ program.size := Nat.not_lt.mp hValidPc
          simp only [programCombinedInvariant, programInvariant, rewindPositionInvariant]
          simp only [step, hStatus, program_size] at *
          have hNone : program[state.pc]? = none := array_getElem?_ge_size _ _ hInvalidPc
          simp only [hNone]
          constructor
          · constructor
            · exact hInv.1.1
            · intro hPc
              simp only [List.mem_cons, List.not_mem_nil, or_false] at hPc
              rcases hPc with h | h | h | h <;> omega
          · intro hPc
            omega
      · -- Fuel sufficient for stepped state
        have hDecrease := program_gas_decreases state hInv hStatus
        omega

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  refine ⟨program_gas (mkInitialState db), ?_⟩
  exact runBounded_terminates (mkInitialState db) (programCombinedInvariant_initial db)
    (program_gas (mkInitialState db)) (Nat.le_refl _)

/-- The final state is either halted or an error -/
theorem program_final_status (db : Database) :
    ∃ n : Nat, match (runBounded program (mkInitialState db) n).status with
      | .halted _ => True
      | .error _ => True
      | .running => False := by
  have ⟨n, hn⟩ := program_terminates db
  refine ⟨n, ?_⟩
  cases h : (runBounded program (mkInitialState db) n).status with
  | halted _ => trivial
  | error _ => trivial
  | running => exact hn h

/-- Compute the required fuel for termination based on database size -/
def programRequiredFuel (db : Database) : Nat :=
  program_gas (mkInitialState db)

/-- runBounded with required fuel terminates -/
theorem program_terminates' (db : Database) :
    (runBounded program (mkInitialState db) (programRequiredFuel db)).status ≠ .running :=
  runBounded_terminates (mkInitialState db) (programCombinedInvariant_initial db)
    (programRequiredFuel db) (Nat.le_refl _)

#check program_terminates
-- program_terminates : ∀ (db : Database),
--   ∃ n, (runBounded program (mkInitialState db) n).status ≠ Status.running

-- Test the gas analysis macro
#analyze_def Sqlite3Lean.Example.program_gas

end Sqlite3Lean.Example
