# sqlite3-lean

Formal verification of SQLite bytecode in Lean 4.

## Why Formalize SQLite Bytecode?

SQLite is everywhere. It runs on your phone, in your browser, inside your applications. Every query you write gets compiled down to **VDBE bytecode** — a low-level instruction set that the SQLite virtual machine executes.

But here's the thing: how do we *know* these programs behave correctly? How do we know they terminate? That they don't loop forever on certain inputs?

**We prove it.**

This project formalizes SQLite's Virtual Database Engine (VDBE) in Lean 4 and proves properties about real bytecode programs. No testing, no fuzzing — mathematical certainty.

## What's Here

- **VDBE Formalization** ([`Sqlite3Lean/Vdbe.lean`](Sqlite3Lean/Vdbe.lean)): Core data types, opcodes, cursor model, and execution semantics
- **Termination Proofs** ([`Sqlite3Lean/SelectStarProof.lean`](Sqlite3Lean/SelectStarProof.lean)): Formal proofs that specific programs halt

## First Theorem: SELECT * FROM t Terminates

We prove that the simplest query — `SELECT * FROM t` — always terminates, regardless of database contents.

### The SQL
```sql
CREATE TABLE t(x);
SELECT * FROM t;
```

### The VDBE Bytecode
```
addr  opcode         p1    p2    p3    p4             p5  comment
----  -------------  ----  ----  ----  -------------  --  -------------
0     Init           0     7     0                    0   Start at 7
1     OpenRead       0     2     0     1              0   root=2 iDb=0; t
2     Rewind         0     6     0                    0
3       Column       0     0     1                    0   r[1]= cursor 0 column 0
4       ResultRow    1     1     0                    0   output=r[1]
5     Next           0     3     0                    1
6     Halt           0     0     0                    0
7     Transaction    0     0     1     0              1   usesStmtJournal=0
8     Goto           0     1     0                    0
```

### The Theorem
```lean
theorem selectAllProgram_terminates (db : Database) :
    ∃ n : Nat, (runBounded selectAllProgram (mkInitialState db) n).status ≠ .running
```

*For any database `db`, there exists a number of steps `n` after which the program has stopped running.*

The proof constructs a **gas function** that strictly decreases on every step:
- Gas = (remaining rows) × 10 + (phase offset)
- Gas > 0 for any running state
- Gas strictly decreases on every instruction
- Therefore, execution must eventually halt

## Building

```bash
lake build
```

## What's Next?

The `SELECT *` proof is just the beginning. The same techniques can prove:
- Termination of `WHERE` clauses with indexes
- Correctness of `JOIN` implementations
- Bounds on query execution time

If SQLite can compile it, we can prove things about it.

## References

- [SQLite Bytecode Engine](https://www.sqlite.org/opcode.html)
- [The Lean 4 Theorem Prover](https://lean-lang.org/)
