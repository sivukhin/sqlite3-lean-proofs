# sqlite3-lean

Formal verification of SQLite bytecode in Lean 4.

## SQLite Busy Challenge

SQLite is one of the most thoroughly tested software projects in the world — with 100% branch coverage, billions of test cases, and decades of fuzzing. Yet bugs still slip through.[^1]

**The SQLite Busy Challenge**: Can we *prove* that SQLite bytecode programs terminate? And beyond that — prove that schema constraints remain satisfied, that joins produce correct results, that indexes stay consistent?

The name is a nod to the [Busy Beaver Challenge](https://bbchallenge.org/story)[^2] — a collaborative effort that formally proved which 5-state Turing machines halt. We're asking the same question for SQLite's virtual machine.

[^1]: In SQLite 3.38, a bug caused queries to hang indefinitely: https://sqlite.org/forum/info/73bd70918595703ea102e8170f5b56aac644e43ce7af35f80eb854d2cba02d04
[^2]: In July 2024, the community proved BB(5) = 47,176,870 by analyzing all 88 million 5-state Turing machines.

This project is a step toward that goal. We formalize SQLite's VDBE (Virtual Database Engine) in Lean 4 and prove termination for real bytecode programs extracted from SQLite.

Currently, we're working through queries from SQLite's [`select1.test`](https://github.com/sqlite/sqlite/blob/master/test/select1.test) suite — real queries that exercise SELECT, WHERE, ORDER BY, GROUP BY, and aggregate functions. The [progress report](https://sivukhin.github.io/sqlite3-lean-proofs/) tracks which queries have been verified.

The long-term goal is to develop **tactics that can automatically prove termination** for most VDBE programs, reducing manual proof effort to edge cases.

## Why Formalize SQLite Bytecode?

SQLite is everywhere. It runs on your phone, in your browser, inside your applications. Every query you write gets compiled down to **VDBE bytecode** — a low-level instruction set that the SQLite virtual machine executes.

But here's the thing: how do we *know* these programs behave correctly? How do we know they terminate? That they don't loop forever on certain inputs?

**We prove it.**

This project formalizes SQLite's Virtual Database Engine (VDBE) in Lean 4 and proves properties about real bytecode programs. No testing, no fuzzing — mathematical certainty.

## What's Here

- **VDBE Formalization** ([`Sqlite3Lean/Vdbe.lean`](Sqlite3Lean/Vdbe.lean)): Core data types, opcodes, cursor model, and execution semantics
- **Proof Helpers** ([`Sqlite3Lean/VdbeLemmas.lean`](Sqlite3Lean/VdbeLemmas.lean)): Lemmas for reasoning about program execution
- **Query Proofs** ([`Sqlite3Lean/select1/`](Sqlite3Lean/select1/)): Termination proofs for queries from SQLite's test suite
- **Progress Report** ([index.html](https://sivukhin.github.io/sqlite3-lean-proofs/)): Live tracking of verification progress

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

Termination is just the first step. The same framework can prove deeper properties:
- **Schema preservation**: After any query, all constraints (NOT NULL, UNIQUE, FOREIGN KEY) remain satisfied
- **Query correctness**: JOINs produce the right tuples, WHERE filters correctly
- **Index consistency**: B-tree indexes stay synchronized with table data
- **Resource bounds**: Worst-case execution time as a function of data size

If SQLite can compile it, we can prove things about it.

## References

- [SQLite Bytecode Engine](https://www.sqlite.org/opcode.html)
- [The Lean 4 Theorem Prover](https://lean-lang.org/)
