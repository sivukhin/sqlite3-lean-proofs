/-
  Termination Proof for SELECT f1 FROM test1

  PR: 1
-/

import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas
import Sqlite3Lean.Tools

namespace Sqlite3Lean.select1.Query000001

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=0 rootpage=2 db=0 mode=read name=

  Query: SELECT f1 FROM test1

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     7     0                    0
  1     OpenRead       0     2     0     1              0
  2     Rewind         0     6     0                    0
  3     Column         0     0     1                    0
  4     ResultRow      1     1     0                    0
  5     Next           0     3     0                    1
  6     Halt           0     0     0                    0
  7     Transaction    0     0     1     0              1
  8     Goto           0     1     0                    0
-/

def program : Program := #[
  vdbeInit 0 7 0 "" 0,  -- 0: Init
  vdbeOpenRead 0 2 0 "1" 0,  -- 1: OpenRead
  vdbeRewind 0 6 0 "" 0,  -- 2: Rewind
  vdbeColumn 0 0 1 "" 0,  -- 3: Column
  vdbeResultRow 1 1 0 "" 0,  -- 4: ResultRow
  vdbeNext 0 3 0 "" 1,  -- 5: Next
  vdbeHalt 0 0 0 "" 0,  -- 6: Halt
  vdbeTransaction 0 0 1 "0" 1,  -- 7: Transaction
  vdbeGoto 0 1 0 "" 0  -- 8: Goto
]

/-! ## Termination Proof -/

/--
  Compute the number of remaining rows to process based on cursor state.
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
  | _ => 1  -- Invalid PC

/--
  The "gas" function for proving termination.
  Gas = remainingRows * loopCost + phaseOffset
-/
def program_gas (state : VMState) : Nat :=
  match state.status with
  | .halted _ | .error _ => 0
  | .running => remainingRows state * 3 + phaseOffset state.pc

/-- Gas is always non-negative -/
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

/-- program has exactly 9 instructions -/
theorem program_size : program.size = 9 := rfl

/-- Get the opcode at each index -/
theorem program_at_0 : program[0]? = some (.init 0 7 0 "" 0) := rfl
theorem program_at_1 : program[1]? = some (.openRead 0 2 0 "1" 0) := rfl
theorem program_at_2 : program[2]? = some (.rewind 0 6 0 "" 0) := rfl
theorem program_at_3 : program[3]? = some (.column 0 0 1 "" 0) := rfl
theorem program_at_4 : program[4]? = some (.resultRow 1 1 0 "" 0) := rfl
theorem program_at_5 : program[5]? = some (.next 0 3 0 "" 1) := rfl
theorem program_at_6 : program[6]? = some (.halt 0 0 0 "" 0) := rfl
theorem program_at_7 : program[7]? = some (.transaction 0 0 1 "0" 1) := rfl
theorem program_at_8 : program[8]? = some (.goto 0 1 0 "" 0) := rfl

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

/-! ### State invariant -/

/--
  Invariant for program execution states.
-/
def programInvariant (state : VMState) : Prop :=
  (∀ cursor, state.cursors 0 = some cursor → cursor.btreeId = 2) ∧
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
  · simp [step, hRunning, h, program_at_0, executeOpcode]
    exact ⟨hCursorBtree, hNoCursorBefore (by simp [h])⟩
  · simp only [step, hRunning, h, program_at_1, executeOpcode, Cursors.set]
    constructor
    · intro cursor hCursor
      simp only [beq_self_eq_true, ↓reduceIte, Option.some.injEq] at hCursor
      rw [← hCursor]
    · simp
  · simp only [step, hRunning, h, program_at_2, executeOpcode]
    split
    · exact ⟨hCursorBtree, by simp⟩
    · rename_i cursor hCursor
      split
      · exact ⟨hCursorBtree, by simp⟩
      · rename_i btree hBtree
        split
        · exact ⟨hCursorBtree, by simp⟩
        · simp only [Cursors.set]
          constructor
          · intro c hc
            simp only [beq_self_eq_true, ↓reduceIte, Option.some.injEq] at hc
            rw [← hc]
            exact hCursorBtree cursor hCursor
          · simp
  · simp only [step, hRunning, h, program_at_3, executeOpcode, getCursorColumn]
    split <;> exact ⟨hCursorBtree, by simp⟩
  · simp only [step, hRunning, h, program_at_4, executeOpcode]
    exact ⟨hCursorBtree, by simp⟩
  · simp only [step, hRunning, h, program_at_5, executeOpcode]
    split
    · exact ⟨hCursorBtree, by simp⟩
    · rename_i cursor hCursor
      split
      · exact ⟨hCursorBtree, by simp⟩
      · rename_i btree hBtree
        split
        · exact ⟨hCursorBtree, by simp⟩
        · rename_i pos hPos
          split
          · simp only [Cursors.set]
            constructor
            · intro c hc
              simp only [beq_self_eq_true, ↓reduceIte, Option.some.injEq] at hc
              rw [← hc]
              exact hCursorBtree cursor hCursor
            · simp
          · exact ⟨hCursorBtree, by simp⟩
  · simp only [step, hRunning, h, program_at_6, executeOpcode]
    exact ⟨hCursorBtree, by simp⟩
  · simp [step, hRunning, h, program_at_7, executeOpcode]
    exact ⟨hCursorBtree, hNoCursorBefore (by simp [h])⟩
  · simp [step, hRunning, h, program_at_8, executeOpcode]
    exact ⟨hCursorBtree, hNoCursorBefore (by simp [h])⟩

/-- Rewind position invariant -/
def rewindPositionInvariant (state : VMState) : Prop :=
  state.pc = 2 → ∀ cursor, state.cursors 0 = some cursor → cursor.position = none

theorem rewindPositionInvariant_initial (db : Database) :
    rewindPositionInvariant (mkInitialState db) := by
  simp [rewindPositionInvariant, mkInitialState]

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
  · simp [step, hRunning, h, program_at_0, executeOpcode]
  · simp only [step, hRunning, h, program_at_1, executeOpcode, Cursors.set]
    intro _ cursor hCursor
    simp only [beq_self_eq_true, ↓reduceIte, Option.some.injEq] at hCursor
    rw [← hCursor]
  · simp only [step, hRunning, h, program_at_2, executeOpcode]
    cases hCursor : state.cursors 0 with
    | none =>
      simp only [hCursor]
      intro _ c hc; simp at hc
    | some cursor =>
      cases hBtree : state.database cursor.btreeId with
      | none =>
        simp only [hBtree]
        intro _ c hc
        have : c = cursor := by simp [hCursor] at hc; exact hc.symm
        rw [this]
        exact hRewind h cursor hCursor
      | some btree =>
        simp only [hBtree]
        by_cases hEmpty : btree.tuples.isEmpty
        · simp only [hEmpty, ↓reduceIte]
          intro hPc2; simp at hPc2
        · simp only [hEmpty]
          intro hPc2; simp at hPc2
  · simp [step, hRunning, h, program_at_3, executeOpcode, getCursorColumn]
    split <;> simp
  · simp [step, hRunning, h, program_at_4, executeOpcode]
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
  · simp [step, hRunning, h, program_at_6, executeOpcode]
  · simp [step, hRunning, h, program_at_7, executeOpcode]
  · simp [step, hRunning, h, program_at_8, executeOpcode]

/-! ### Gas decrease proof -/

theorem program_gas_decreases_step (state : VMState)
    (hInv : programInvariant state)
    (hRewind : rewindPositionInvariant state)
    (hRunning : state.status = .running)
    (hValidPc : state.pc < program.size) :
    program_gas (step program state) < program_gas state := by
  simp only [program_size] at hValidPc
  have hPc : state.pc = 0 ∨ state.pc = 1 ∨ state.pc = 2 ∨ state.pc = 3 ∨
             state.pc = 4 ∨ state.pc = 5 ∨ state.pc = 6 ∨ state.pc = 7 ∨ state.pc = 8 := by omega
  rcases hPc with h | h | h | h | h | h | h | h | h
  · simp [step, hRunning, h, program_at_0, executeOpcode]
    simp [h, program_gas, hRunning, phaseOffset, remainingRows]
  · have hNoCursor : state.cursors 0 = none := hInv.2 (by simp [h])
    simp only [step, hRunning, h, program_at_1, executeOpcode]
    simp only [program_gas, hRunning, remainingRows, Cursors.set, h]
    simp only [beq_self_eq_true, ↓reduceIte, hNoCursor, phaseOffset]
    omega
  · simp only [step, hRunning, h, program_at_2, executeOpcode]
    cases hCursor : state.cursors 0 with
    | none =>
      simp only [program_gas, hRunning, h, remainingRows, hCursor, phaseOffset]
      omega
    | some cursor =>
      cases hBtree : state.database cursor.btreeId with
      | none =>
        simp only [hBtree, program_gas, hRunning, h, remainingRows, hCursor, phaseOffset]
        omega
      | some btree =>
        simp only [hBtree]
        have hBtreeId := hInv.1 cursor hCursor
        have hPosNone := hRewind h cursor hCursor
        have hDb2 : state.database 2 = some btree := by rw [← hBtreeId]; exact hBtree
        by_cases hEmpty : btree.tuples.isEmpty
        · simp only [hEmpty, ↓reduceIte, program_gas, remainingRows, hCursor, hBtreeId, hPosNone,
                     phaseOffset, hRunning, h, hDb2]
          have hLen : btree.tuples.length = 0 :=
            List.length_eq_zero_iff.mpr (List.isEmpty_iff.mp hEmpty)
          omega
        · have hNotEmpty : btree.tuples.isEmpty = false := Bool.eq_false_iff.mpr hEmpty
          simp only [hNotEmpty, Bool.false_eq_true, ↓reduceIte, program_gas, Cursors.set,
                     beq_self_eq_true, remainingRows, hBtreeId, hCursor, hPosNone, phaseOffset,
                     hRunning, h, hDb2]
          have hLen : btree.tuples.length > 0 :=
            List.length_pos_iff.mpr (List.isEmpty_eq_false_iff.mp hNotEmpty)
          omega
  · simp only [step, hRunning, h, program_at_3, executeOpcode, getCursorColumn]
    cases hCol : getCursorTuple state 0 >>= fun t => t[0]? with
    | none =>
      simp only [program_gas, remainingRows, phaseOffset, hRunning, h]
      omega
    | some val =>
      simp only [program_gas, remainingRows, phaseOffset, hRunning, h]
      omega
  · simp [step, hRunning, h, program_at_4, executeOpcode]
    simp [h, program_gas, hRunning, phaseOffset, remainingRows]
  · simp only [step, hRunning, h, program_at_5, executeOpcode]
    cases hCursor : state.cursors 0 with
    | none =>
      simp only [program_gas, hRunning, h, remainingRows, hCursor, phaseOffset]
      omega
    | some cursor =>
      cases hBtree : state.database cursor.btreeId with
      | none =>
        simp only [hBtree, program_gas, hRunning, h, remainingRows, hCursor, phaseOffset]
        omega
      | some btree =>
        simp only [hBtree]
        have hBtreeId := hInv.1 cursor hCursor
        have hDb2 : state.database 2 = some btree := by rw [← hBtreeId]; exact hBtree
        cases hPos : cursor.position with
        | none =>
          simp only [program_gas, hRunning, h, remainingRows, hCursor, hBtreeId, hDb2, phaseOffset]
          omega
        | some pos =>
          by_cases hMore : pos + 1 < btree.tuples.length
          · simp only [hMore, ↓reduceIte, program_gas, Cursors.set, beq_self_eq_true,
                       remainingRows, hBtreeId, hCursor, hDb2, phaseOffset, hRunning, h, hPos]
            omega
          · simp only [hMore, ↓reduceIte, program_gas, remainingRows,
                       hCursor, hBtreeId, hDb2, hPos, phaseOffset, hRunning, h]
            omega
  · simp only [step, hRunning, h, program_at_6, executeOpcode, program_gas, phaseOffset_6]
    have hGasPos := program_gas_pos_of_running state hRunning
    simp only [program_gas, hRunning, h] at hGasPos
    exact hGasPos
  · simp [step, hRunning, h, program_at_7, executeOpcode]
    simp [h, program_gas, hRunning, phaseOffset, remainingRows]
  · simp [step, hRunning, h, program_at_8, executeOpcode]
    simp [h, program_gas, hRunning, phaseOffset, remainingRows]

/-! ## Termination Proof -/

theorem array_getElem?_ge_size {α : Type u} (a : Array α) (i : Nat) (h : i ≥ a.size) :
    a[i]? = none := by
  rw [Array.getElem?_eq_none_iff]
  omega

theorem step_invalid_pc (state : VMState)
    (hRunning : state.status = .running)
    (hInvalidPc : state.pc ≥ program.size) :
    (step program state).status = .error s!"Invalid PC: {state.pc}" := by
  simp only [step, hRunning, program_size] at *
  have hNone : program[state.pc]? = none := array_getElem?_ge_size _ _ hInvalidPc
  simp [hNone]

theorem program_gas_zero_of_not_running (state : VMState)
    (h : state.status ≠ .running) : program_gas state = 0 := by
  simp only [program_gas]
  cases hStatus : state.status with
  | running => exact absurd hStatus h
  | halted _ => rfl
  | error _ => rfl

def programCombinedInvariant (state : VMState) : Prop :=
  programInvariant state ∧ rewindPositionInvariant state

theorem programCombinedInvariant_initial (db : Database) :
    programCombinedInvariant (mkInitialState db) :=
  ⟨programInvariant_initial db, rewindPositionInvariant_initial db⟩

theorem programCombinedInvariant_preserved (state : VMState)
    (hInv : programCombinedInvariant state)
    (hRunning : state.status = .running)
    (hValidPc : state.pc < program.size) :
    programCombinedInvariant (step program state) :=
  ⟨programInvariant_preserved state hInv.1 hRunning hValidPc,
   rewindPositionInvariant_preserved state hInv.2 hRunning hValidPc⟩

theorem program_gas_decreases (state : VMState)
    (hInv : programCombinedInvariant state)
    (hRunning : state.status = .running) :
    program_gas (step program state) < program_gas state := by
  by_cases hValidPc : state.pc < program.size
  · exact program_gas_decreases_step state hInv.1 hInv.2 hRunning hValidPc
  · have hInvalidPc : state.pc ≥ program.size := Nat.not_lt.mp hValidPc
    have hError := step_invalid_pc state hRunning hInvalidPc
    have hNotRunning : (step program state).status ≠ .running := by
      simp [hError]
    rw [program_gas_zero_of_not_running _ hNotRunning]
    exact program_gas_pos_of_running state hRunning

theorem runBounded_terminates (state : VMState)
    (hInv : programCombinedInvariant state)
    (fuel : Nat)
    (hFuel : fuel ≥ program_gas state) :
    (runBounded program state fuel).status ≠ .running := by
  induction fuel generalizing state with
  | zero =>
    simp only [runBounded]
    intro hRunning
    have hGasPos := program_gas_pos_of_running state hRunning
    omega
  | succ n ih =>
    rw [VdbeLemmas.runBounded_step_comm]
    cases hStatus : state.status with
    | halted code =>
      have hNotRunning : state.status ≠ .running := by simp [hStatus]
      have hStepEq : step program state = state := by simp [step, hStatus]
      rw [hStepEq]
      exact VdbeLemmas.runBounded_preserves_not_running program state n hNotRunning
    | error msg =>
      have hNotRunning : state.status ≠ .running := by simp [hStatus]
      have hStepEq : step program state = state := by simp [step, hStatus]
      rw [hStepEq]
      exact VdbeLemmas.runBounded_preserves_not_running program state n hNotRunning
    | running =>
      apply ih
      · by_cases hValidPc : state.pc < program.size
        · exact programCombinedInvariant_preserved state hInv hStatus hValidPc
        · have hInvalidPc : state.pc ≥ program.size := Nat.not_lt.mp hValidPc
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
      · have hDecrease := program_gas_decreases state hInv hStatus
        omega

/-- Main termination theorem -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  refine ⟨program_gas (mkInitialState db), ?_⟩
  exact runBounded_terminates (mkInitialState db) (programCombinedInvariant_initial db)
    (program_gas (mkInitialState db)) (Nat.le_refl _)

/-- Compute the required fuel for termination -/
def programRequiredFuel (db : Database) : Nat :=
  program_gas (mkInitialState db)

/-- runBounded with required fuel terminates -/
theorem program_terminates' (db : Database) :
    (runBounded program (mkInitialState db) (programRequiredFuel db)).status ≠ .running :=
  runBounded_terminates (mkInitialState db) (programCombinedInvariant_initial db)
    (programRequiredFuel db) (Nat.le_refl _)

#analyze_def Sqlite3Lean.select1.Query000001.program_gas
#print_pr Sqlite3Lean.select1.Query000001.program 1

end Sqlite3Lean.select1.Query000001
