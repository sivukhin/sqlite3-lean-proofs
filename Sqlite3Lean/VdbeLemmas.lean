import Sqlite3Lean.Vdbe

namespace Sqlite3Lean.VdbeLemmas

open Sqlite3Lean.Vdbe

/-! ### Custom tactic for splitting nested matches -/

/-- Recursively split match expressions and apply simp on leaf cases.
    Tries progressively shallower depths (5 down to 1).
    -/
macro "split_simp" : tactic => `(tactic|
  first
  | split <;> (try simp) <;> split <;> (try simp) <;> split <;> (try simp) <;> split <;> (try simp) <;> split <;> simp
  | split <;> (try simp) <;> split <;> (try simp) <;> split <;> (try simp) <;> split <;> simp
  | split <;> (try simp) <;> split <;> (try simp) <;> split <;> simp
  | split <;> (try simp) <;> split <;> simp
  | split <;> simp
  | simp)

/-! ### runBounded induction lemmas -/

/-- runBounded with fuel n+1 equals step applied to runBounded with fuel n -/
@[simp]
theorem runBounded_succ (program : Program) (state : VMState) (n : Nat) :
    runBounded program state (n + 1) = step program (runBounded program state n) := by simp [runBounded]

/-- runBounded with zero fuel returns the initial state -/
@[simp]
theorem runBounded_zero (program : Program) (state : VMState) :
    runBounded program state 0 = state := rfl

/-- runBounded state (n+1) = runBounded (step state) n -/
theorem runBounded_step_comm (program : Program) (state : VMState) (n : Nat) :
    runBounded program state (n + 1) = runBounded program (step program state) n := by
  induction n generalizing state with
  | zero => simp [runBounded]
  | succ m ih =>
    simp only [runBounded_succ]
    have h := ih state
    simp only [runBounded_succ] at h
    rw [h]

/-- step preserves "not running" status -/
theorem step_preserves_not_running (program : Program) (state : VMState)
    (hNotRunning : state.status ≠ .running) :
    (step program state).status ≠ .running := by
  simp only [step]
  cases hPc : program[state.pc]? with
  | none => simp
  | some op =>
    simp only [executeOpcode]
    cases hStatus : state.status with
    | running => exact absurd hStatus hNotRunning
    | halted code => simp [hStatus]
    | error msg => simp [hStatus]

/-- runBounded preserves "not running" status -/
theorem runBounded_preserves_not_running (program : Program) (state : VMState) (fuel : Nat)
    (hNotRunning : state.status ≠ .running) :
    (runBounded program state fuel).status ≠ .running := by
  induction fuel with
  | zero => simp [runBounded]; exact hNotRunning
  | succ n ih =>
    simp only [runBounded_succ]
    exact step_preserves_not_running program _ ih

/-- Helper: Array indexing returns none when out of bounds -/
theorem array_getElem?_ge_size {α : Type u} (a : Array α) (i : Nat) (h : i ≥ a.size) :
    a[i]? = none := by
  rw [Array.getElem?_eq_none_iff]
  omega

/-! ### Step helper lemmas -/

/-- step with invalid PC results in error status -/
theorem step_invalid_pc (program : Program) (state : VMState)
    (hPc : state.pc ≥ program.size) :
    (step program state).status = .error s!"Invalid PC: {state.pc}" := by
  simp only [step]
  have hNone := array_getElem?_ge_size program state.pc hPc
  simp [hNone]

/-! ### Opcode PC behavior lemmas -/

/-- init always jumps to p2 -/
@[simp]
theorem executeOpcode_anyState_init_pc (p1 p2 p3 : Nat) (state : VMState) :
    let pc := (executeOpcode (.init p1 p2 p3) state).pc
    pc = p2 ∨ pc = state.pc := by
  simp [executeOpcode]
  split_simp

/-- openRead always increments PC by 1 -/
@[simp]
theorem executeOpcode_anyState_openRead_pc (p1 p2 p3 p4 : Nat) (state : VMState) :
    let pc := (executeOpcode (.openRead p1 p2 p3 p4) state).pc
    pc = state.pc + 1 ∨ pc = state.pc := by
  simp [executeOpcode]
  split_simp

/-- rewind: PC jumps to p2 or increments -/
@[simp]
theorem executeOpcode_anyState_rewind_pc (p1 p2 p3 : Nat) (state : VMState) :
    let pc := (executeOpcode (.rewind p1 p2 p3) state).pc
    pc = state.pc + 1 ∨ pc = p2 ∨ pc = state.pc := by
  simp only [executeOpcode]
  split_simp

/-- column always increments PC by 1 -/
@[simp]
theorem executeOpcode_anyState_column_pc (p1 p2 p3 : Nat) (state : VMState) :
    let pc := (executeOpcode (.column p1 p2 p3) state).pc
    pc = state.pc + 1 ∨ pc = state.pc := by
  simp [executeOpcode, getCursorColumn]
  split_simp

/-- resultRow always increments PC by 1 -/
@[simp]
theorem executeOpcode_anyState_resultRow_pc (p1 p2 p3 : Nat) (state : VMState) :
    let pc := (executeOpcode (.resultRow p1 p2 p3) state).pc
    pc = state.pc + 1 ∨ pc = state.pc := by
  simp [executeOpcode]
  split_simp

/-- next: PC jumps to p2 or increments -/
@[simp]
theorem executeOpcode_anyState_next_pc (p1 p2 p3 : Nat) (state : VMState) :
    let pc := (executeOpcode (.next p1 p2 p3) state).pc
    pc = state.pc + 1 ∨ pc = p2 ∨ pc = state.pc := by
  simp only [executeOpcode]
  split_simp

/-- halt preserves PC -/
@[simp]
theorem executeOpcode_anyState_halt_pc (p1 p2 p3 : Nat) (state : VMState) :
    (executeOpcode (.halt p1 p2 p3) state).pc = state.pc := by
  simp only [executeOpcode]
  split_simp

/-- transaction always increments PC by 1 -/
@[simp]
theorem executeOpcode_anyState_transaction_pc (p1 p2 p3 p4 : Nat) (state : VMState) :
    let pc := (executeOpcode (.transaction p1 p2 p3 p4) state).pc
    pc = state.pc + 1 ∨ pc = state.pc := by
  simp [executeOpcode]
  split_simp

/-- goto_ always jumps to p2 -/
@[simp]
theorem executeOpcode_anyState_goto_pc (p1 p2 p3 : Nat) (state : VMState) :
    let pc := (executeOpcode (.goto_ p1 p2 p3) state).pc
    pc = p2 ∨ pc = state.pc := by
  simp [executeOpcode]
  split_simp

/-! ### getCursorRemainingRows lemmas -/

/-- getCursorRemainingRows returns none when cursor doesn't exist -/
@[simp]
theorem getCursorRemainingRows_none_cursor (state : VMState) (cursorId : CursorId)
    (h : state.cursors cursorId = none) :
    getCursorRemainingRows state cursorId = none := by
  simp [getCursorRemainingRows, h]

/-- getCursorRemainingRows returns none when btree doesn't exist -/
@[simp]
theorem getCursorRemainingRows_none_btree (state : VMState) (cursorId : CursorId)
    (cursor : Cursor)
    (hCursor : state.cursors cursorId = some cursor)
    (hBtree : state.database cursor.btreeId = none) :
    getCursorRemainingRows state cursorId = none := by
  simp [getCursorRemainingRows, hCursor, hBtree]

/-- getCursorRemainingRows is unaffected by changing pc -/
@[simp]
theorem getCursorRemainingRows_set_pc (state : VMState) (cursorId : CursorId) (newPc : Nat) :
    getCursorRemainingRows { state with pc := newPc } cursorId =
    getCursorRemainingRows state cursorId := rfl

/-- getCursorRemainingRows is unaffected by changing registers -/
@[simp]
theorem getCursorRemainingRows_set_registers (state : VMState) (cursorId : CursorId) (newRegs : Registers) :
    getCursorRemainingRows { state with registers := newRegs } cursorId =
    getCursorRemainingRows state cursorId := rfl

/-- getCursorRemainingRows is unaffected by changing output -/
@[simp]
theorem getCursorRemainingRows_set_output (state : VMState) (cursorId : CursorId) (newOutput : Output) :
    getCursorRemainingRows { state with output := newOutput } cursorId =
    getCursorRemainingRows state cursorId := rfl

/-- getCursorRemainingRows is unaffected by changing status -/
@[simp]
theorem getCursorRemainingRows_set_status (state : VMState) (cursorId : CursorId) (newStatus : Status) :
    getCursorRemainingRows { state with status := newStatus } cursorId =
    getCursorRemainingRows state cursorId := rfl

end Sqlite3Lean.VdbeLemmas
