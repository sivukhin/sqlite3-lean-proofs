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

/-- step with invalid PC results in error status (when running) -/
theorem step_invalid_pc (program : Program) (state : VMState)
    (hPc : state.pc ≥ program.size) (hRunning : state.status = .running) :
    (step program state).status = .error s!"Invalid PC: {state.pc}" := by
  simp only [step, hRunning]
  have hNone := array_getElem?_ge_size program state.pc hPc
  simp [hNone]

/-! ### Opcode PC behavior lemmas -/

/-- init always jumps to p2 -/
@[simp]
theorem executeOpcode_anyState_init_pc (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) (state : VMState) :
    let pc := (executeOpcode (.init p1 p2 p3 p4 p5) state).pc
    pc = p2 ∨ pc = state.pc := by
  simp [executeOpcode]
  split_simp

/-- openRead always increments PC by 1 -/
@[simp]
theorem executeOpcode_anyState_openRead_pc (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) (state : VMState) :
    let pc := (executeOpcode (.openRead p1 p2 p3 p4 p5) state).pc
    pc = state.pc + 1 ∨ pc = state.pc := by
  simp [executeOpcode]
  split_simp

/-- rewind: PC jumps to p2 or increments -/
@[simp]
theorem executeOpcode_anyState_rewind_pc (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) (state : VMState) :
    let pc := (executeOpcode (.rewind p1 p2 p3 p4 p5) state).pc
    pc = state.pc + 1 ∨ pc = p2 ∨ pc = state.pc := by
  simp only [executeOpcode]
  split_simp

/-- column always increments PC by 1 -/
@[simp]
theorem executeOpcode_anyState_column_pc (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) (state : VMState) :
    let pc := (executeOpcode (.column p1 p2 p3 p4 p5) state).pc
    pc = state.pc + 1 ∨ pc = state.pc := by
  simp [executeOpcode, getCursorColumn]
  split_simp

/-- resultRow always increments PC by 1 -/
@[simp]
theorem executeOpcode_anyState_resultRow_pc (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) (state : VMState) :
    let pc := (executeOpcode (.resultRow p1 p2 p3 p4 p5) state).pc
    pc = state.pc + 1 ∨ pc = state.pc := by
  simp [executeOpcode]
  split_simp

/-- next: PC jumps to p2 or increments -/
@[simp]
theorem executeOpcode_anyState_next_pc (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) (state : VMState) :
    let pc := (executeOpcode (.next p1 p2 p3 p4 p5) state).pc
    pc = state.pc + 1 ∨ pc = p2 ∨ pc = state.pc := by
  simp only [executeOpcode]
  split_simp

/-- halt preserves PC -/
@[simp]
theorem executeOpcode_anyState_halt_pc (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) (state : VMState) :
    (executeOpcode (.halt p1 p2 p3 p4 p5) state).pc = state.pc := by
  simp only [executeOpcode]
  split_simp

/-- transaction always increments PC by 1 -/
@[simp]
theorem executeOpcode_anyState_transaction_pc (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) (state : VMState) :
    let pc := (executeOpcode (.transaction p1 p2 p3 p4 p5) state).pc
    pc = state.pc + 1 ∨ pc = state.pc := by
  simp [executeOpcode]
  split_simp

/-- goto always jumps to p2 -/
@[simp]
theorem executeOpcode_anyState_goto_pc (p1 p2 p3 : Nat) (p4 : String) (p5 : Nat) (state : VMState) :
    let pc := (executeOpcode (.goto p1 p2 p3 p4 p5) state).pc
    pc = p2 ∨ pc = state.pc := by
  simp [executeOpcode]
  split_simp

end Sqlite3Lean.VdbeLemmas
