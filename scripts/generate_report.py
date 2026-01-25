#!/usr/bin/env python3
"""
Generate an HTML report about the proving progress for SQLite query verification.

Usage:
    python scripts/generate_report.py [--output report.html]

The script analyzes Lean files in Sqlite3Lean/select1/ and generates a report with:
- Query file name
- Whether termination is proved (no sorry)
- Whether all opcodes are formalized
- PR number (if available from git)
- Worst case runtime bound
"""

import os
import re
import subprocess
import argparse
from pathlib import Path
from dataclasses import dataclass
from typing import Optional
import html

@dataclass
class QueryStatus:
    file_name: str
    query_name: str
    sql_query: Optional[str]
    has_sorry: bool
    termination_proved: bool
    all_opcodes_formalized: bool
    opcodes_used: list[str]
    unknown_opcodes: list[str]
    gas_function: Optional[str]
    runtime_bound: Optional[str]
    pr_number: Optional[str]
    error_message: Optional[str]

def extract_sql_query(content: str) -> Optional[str]:
    """Extract SQL query from the doc comment."""
    match = re.search(r'The program for:\s*(.+?)(?:\n|$)', content)
    if match:
        return match.group(1).strip()
    return None

def extract_opcodes(content: str) -> list[str]:
    """Extract opcodes used in the program definition."""
    # Find the program definition block
    program_match = re.search(r'def\s+program\s*:\s*Program\s*:=\s*#\[(.*?)\]', content, re.DOTALL)
    if not program_match:
        return []

    program_block = program_match.group(1)

    # Match all opcode patterns like .init, .openRead, .halt, etc.
    pattern = r'\.([a-zA-Z][a-zA-Z0-9]*)\b'
    matches = re.findall(pattern, program_block)
    return list(set(matches))

def check_for_sorry(content: str) -> bool:
    """Check if the file contains sorry."""
    # Match 'sorry' as a word, not part of another word
    return bool(re.search(r'\bsorry\b', content))

def extract_gas_function(content: str) -> Optional[str]:
    """Extract gas/fuel function definition if present."""
    # Look for gas or fuel function definitions
    match = re.search(r'def\s+(\w*[Gg]as|\w*[Ff]uel)\s*[^:]*:\s*(\w+)', content)
    if match:
        return f"{match.group(1)} : {match.group(2)}"
    return None

def extract_runtime_bound(content: str) -> Optional[str]:
    """Extract runtime bound expression if present."""
    # Look for gas computation like "rows * loopCost + offset"
    match = re.search(r'(remainingRows|rows)\s*\*\s*(\w+)\s*\+\s*(\w+)', content)
    if match:
        return f"O({match.group(1)} * {match.group(2)} + {match.group(3)})"

    # Look for simpler bounds
    match = re.search(r'def\s+\w*[Gg]as[^=]*=\s*([^\n]+)', content)
    if match:
        expr = match.group(1).strip()
        if len(expr) < 100:  # Sanity check
            return expr
    return None

def get_pr_from_git(file_path: str) -> Optional[str]:
    """Try to extract PR number from git log."""
    try:
        result = subprocess.run(
            ['git', 'log', '--oneline', '-1', '--', file_path],
            capture_output=True, text=True, cwd=os.path.dirname(file_path) or '.'
        )
        if result.returncode == 0:
            log = result.stdout.strip()
            # Look for PR number patterns like #123, PR-123, etc.
            match = re.search(r'#(\d+)|PR[- ]?(\d+)', log, re.IGNORECASE)
            if match:
                return match.group(1) or match.group(2)
    except Exception:
        pass
    return None

@dataclass
class BuildResult:
    sorry_files: dict[str, list[str]]  # file -> list of sorry warnings
    unknown_opcodes: dict[str, list[str]]  # file -> list of unknown opcodes
    other_errors: dict[str, list[str]]  # file -> list of other errors

def run_lake_build(project_root: Path) -> BuildResult:
    """Run lake build and collect errors/warnings."""
    result = BuildResult(sorry_files={}, unknown_opcodes={}, other_errors={})

    try:
        proc = subprocess.run(
            ['lake', 'build'],
            capture_output=True, text=True,
            cwd=project_root
        )
        output = proc.stdout + proc.stderr

        for line in output.split('\n'):
            # Parse file path from error/warning
            file_match = re.search(r'(\S+\.lean):\d+:\d+:', line)
            if not file_match:
                continue

            file_path = file_match.group(1)

            # Check for sorry warnings
            if 'sorry' in line.lower():
                if file_path not in result.sorry_files:
                    result.sorry_files[file_path] = []
                result.sorry_files[file_path].append(line)

            # Check for unknown opcode errors
            # e.g., "Unknown constant `Sqlite3Lean.Vdbe.Opcode.lt`"
            opcode_match = re.search(r'Unknown constant.*Opcode\.(\w+)', line)
            if opcode_match:
                opcode = opcode_match.group(1)
                if file_path not in result.unknown_opcodes:
                    result.unknown_opcodes[file_path] = []
                if opcode not in result.unknown_opcodes[file_path]:
                    result.unknown_opcodes[file_path].append(opcode)

            # Check for other errors
            elif 'error:' in line.lower() and file_path:
                if file_path not in result.other_errors:
                    result.other_errors[file_path] = []
                result.other_errors[file_path].append(line)

    except Exception as e:
        print(f"Warning: Could not run lake build: {e}")

    return result

def analyze_query_file(file_path: Path, build_result: BuildResult, project_root: Path) -> QueryStatus:
    """Analyze a single query file and return its status."""
    # Get relative path for matching with build output
    try:
        rel_path = str(file_path.relative_to(project_root))
        # Remove Sqlite3Lean/ prefix for cleaner display
        if rel_path.startswith('Sqlite3Lean/'):
            rel_path = rel_path[len('Sqlite3Lean/'):]
    except ValueError:
        rel_path = file_path.name

    try:
        content = file_path.read_text()
    except Exception as e:
        return QueryStatus(
            file_name=rel_path,
            query_name=file_path.stem,
            sql_query=None,
            has_sorry=True,
            termination_proved=False,
            all_opcodes_formalized=False,
            opcodes_used=[],
            unknown_opcodes=[],
            gas_function=None,
            runtime_bound=None,
            pr_number=None,
            error_message=str(e)
        )

    sql_query = extract_sql_query(content)
    has_sorry = check_for_sorry(content)
    opcodes = extract_opcodes(content)
    gas_function = extract_gas_function(content)
    runtime_bound = extract_runtime_bound(content)
    pr_number = get_pr_from_git(str(file_path))

    # Check for termination theorem
    has_termination_theorem = bool(re.search(r'theorem\s+\w*terminates', content))
    termination_proved = has_termination_theorem and not has_sorry

    # Get unknown opcodes from build result
    # Match against both the short path and full path with Sqlite3Lean/ prefix
    unknown_opcodes = []
    full_rel_path = str(file_path.relative_to(project_root)) if file_path.is_relative_to(project_root) else file_path.name
    for build_path, opcodes_list in build_result.unknown_opcodes.items():
        if rel_path in build_path or build_path in rel_path or full_rel_path in build_path or build_path in full_rel_path:
            unknown_opcodes.extend(opcodes_list)
    unknown_opcodes = list(set(unknown_opcodes))

    all_opcodes_formalized = len(unknown_opcodes) == 0

    return QueryStatus(
        file_name=rel_path,
        query_name=file_path.stem,
        sql_query=sql_query,
        has_sorry=has_sorry,
        termination_proved=termination_proved,
        all_opcodes_formalized=all_opcodes_formalized,
        opcodes_used=opcodes,
        unknown_opcodes=unknown_opcodes,
        gas_function=gas_function,
        runtime_bound=runtime_bound,
        pr_number=pr_number,
        error_message=None
    )

def generate_html_report(queries: list[QueryStatus], output_path: str, project_root: Path):
    """Generate HTML report."""

    # Calculate statistics
    total = len(queries)
    proved = sum(1 for q in queries if q.termination_proved)
    with_sorry = sum(1 for q in queries if q.has_sorry)
    all_opcodes = sum(1 for q in queries if q.all_opcodes_formalized)

    html_content = f'''<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SQLite Query Verification Report</title>
    <style>
        body {{
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, sans-serif;
            background-color: #fff;
            color: #222;
            margin: 0;
            padding: 20px;
        }}

        .container {{
            max-width: 1400px;
            margin: 0 auto;
        }}

        h1 {{
            text-align: center;
            margin-bottom: 10px;
            color: #333;
        }}

        .summary {{
            display: flex;
            justify-content: center;
            gap: 30px;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }}

        .stat-card {{
            background: #f5f5f5;
            padding: 20px 30px;
            border-radius: 8px;
            text-align: center;
            min-width: 150px;
            border: 1px solid #ddd;
        }}

        .stat-card .number {{
            font-size: 2.5em;
            font-weight: bold;
            color: #333;
        }}

        .stat-card .label {{
            color: #666;
            margin-top: 5px;
        }}

        table {{
            width: 100%;
            border-collapse: collapse;
            background: #fff;
            border: 1px solid #ccc;
        }}

        th, td {{
            padding: 10px 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }}

        th {{
            background: #f0f0f0;
            font-weight: 600;
            position: sticky;
            top: 0;
            border-bottom: 2px solid #999;
        }}

        tr:hover {{
            background: #f9f9f9;
        }}

        .status-yes {{
            color: #006400;
            font-weight: bold;
        }}

        .status-no {{
            color: #8b0000;
            font-weight: bold;
        }}

        .status-unknown {{
            color: #b37700;
            font-weight: bold;
        }}

        .query-name {{
            font-family: monospace;
            font-size: 0.9em;
            white-space: nowrap;
        }}

        .sql-query {{
            font-family: monospace;
            font-size: 0.85em;
            color: #555;
            max-width: 300px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }}

        .missing-opcodes {{
            font-family: monospace;
            color: #8b0000;
        }}

        .runtime {{
            font-family: monospace;
            font-size: 0.85em;
        }}

        .pr-link {{
            color: #0066cc;
            text-decoration: none;
        }}

        .pr-link:hover {{
            text-decoration: underline;
        }}

        .filter-bar {{
            margin-bottom: 20px;
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }}

        .filter-btn {{
            padding: 8px 16px;
            border: 1px solid #ccc;
            border-radius: 4px;
            cursor: pointer;
            background: #fff;
            color: #333;
            transition: all 0.2s;
        }}

        .filter-btn:hover {{
            background: #e0e0e0;
        }}

        .filter-btn.active {{
            background: #333;
            color: #fff;
            border-color: #333;
        }}

        .timestamp {{
            text-align: center;
            color: #888;
            margin-top: 20px;
            font-size: 0.9em;
        }}
    </style>
</head>
<body>
    <div class="container">
        <h1>SQLite Query Verification Report</h1>

        <div class="summary">
            <div class="stat-card">
                <div class="number">{total}</div>
                <div class="label">Total Queries</div>
            </div>
            <div class="stat-card">
                <div class="number">{proved}</div>
                <div class="label">Fully Proved</div>
            </div>
            <div class="stat-card">
                <div class="number">{with_sorry}</div>
                <div class="label">With Sorry</div>
            </div>
            <div class="stat-card">
                <div class="number">{all_opcodes}</div>
                <div class="label">All Opcodes OK</div>
            </div>
        </div>

        <div class="filter-bar">
            <button class="filter-btn active" onclick="filterTable('all')">All</button>
            <button class="filter-btn" onclick="filterTable('proved')">Proved</button>
            <button class="filter-btn" onclick="filterTable('sorry')">With Sorry</button>
            <button class="filter-btn" onclick="filterTable('opcodes-ok')">Opcodes OK</button>
            <button class="filter-btn" onclick="filterTable('opcodes-missing')">Missing Opcodes</button>
        </div>

        <table id="query-table">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Query File</th>
                    <th>SQL Query</th>
                    <th>Termination</th>
                    <th>Opcodes</th>
                    <th>Runtime Bound</th>
                    <th>PR #</th>
                </tr>
            </thead>
            <tbody>
'''

    for i, q in enumerate(queries, 1):
        if q.termination_proved:
            termination_class = 'status-yes'
            termination_text = 'yes'
        elif q.has_sorry:
            termination_class = 'status-unknown'
            termination_text = '?'
        else:
            termination_class = 'status-no'
            termination_text = 'no'

        opcodes_class = 'status-yes' if q.all_opcodes_formalized else 'status-no'
        if q.all_opcodes_formalized:
            opcodes_text = 'ok'
        else:
            missing = ', '.join(q.unknown_opcodes[:5])
            if len(q.unknown_opcodes) > 5:
                missing += f' (+{len(q.unknown_opcodes) - 5})'
            opcodes_text = f'<span class="missing-opcodes">{html.escape(missing)}</span>'

        pr_html = f'<a class="pr-link" href="https://github.com/user/repo/pull/{q.pr_number}">#{q.pr_number}</a>' if q.pr_number else '-'

        runtime_html = html.escape(q.runtime_bound) if q.runtime_bound else '-'
        sql_html = html.escape(q.sql_query) if q.sql_query else '-'

        data_status = 'proved' if q.termination_proved else 'sorry'
        data_opcodes = 'opcodes-ok' if q.all_opcodes_formalized else 'opcodes-missing'

        html_content += f'''                <tr data-status="{data_status}" data-opcodes="{data_opcodes}">
                    <td>{i}</td>
                    <td class="query-name">{html.escape(q.file_name)}</td>
                    <td class="sql-query" title="{sql_html}">{sql_html}</td>
                    <td class="{termination_class}">{termination_text}</td>
                    <td class="{opcodes_class}">{opcodes_text}</td>
                    <td class="runtime">{runtime_html}</td>
                    <td>{pr_html}</td>
                </tr>
'''

    from datetime import datetime
    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

    html_content += f'''            </tbody>
        </table>

        <p class="timestamp">Generated: {timestamp}</p>
    </div>

    <script>
        function filterTable(filter) {{
            const rows = document.querySelectorAll('#query-table tbody tr');
            const buttons = document.querySelectorAll('.filter-btn');

            buttons.forEach(btn => btn.classList.remove('active'));
            event.target.classList.add('active');

            rows.forEach(row => {{
                const status = row.dataset.status;
                const opcodes = row.dataset.opcodes;
                let show = false;

                if (filter === 'all') {{
                    show = true;
                }} else if (filter === 'proved' && status === 'proved') {{
                    show = true;
                }} else if (filter === 'sorry' && status === 'sorry') {{
                    show = true;
                }} else if (filter === 'opcodes-ok' && opcodes === 'opcodes-ok') {{
                    show = true;
                }} else if (filter === 'opcodes-missing' && opcodes === 'opcodes-missing') {{
                    show = true;
                }}

                row.style.display = show ? '' : 'none';
            }});
        }}
    </script>
</body>
</html>
'''

    with open(output_path, 'w') as f:
        f.write(html_content)

    print(f"Report generated: {output_path}")
    print(f"  Total queries: {total}")
    print(f"  Fully proved: {proved} ({proved/total*100 if total > 0 else 0:.1f}%)")
    print(f"  With sorry: {with_sorry}")

def main():
    parser = argparse.ArgumentParser(description='Generate HTML report for query verification progress')
    parser.add_argument('--output', '-o', default='report.html', help='Output HTML file path')
    parser.add_argument('--dir', '-d', action='append', default=[], help='Directory containing query files (can be repeated)')
    parser.add_argument('--file', '-f', action='append', default=[], help='Additional individual files to include')
    parser.add_argument('--include-query0', action='store_true', help='Include Sqlite3Lean/Query0.lean')
    args = parser.parse_args()

    # Find project root
    script_dir = Path(__file__).parent
    project_root = script_dir.parent

    # Default directories if none specified
    if not args.dir:
        args.dir = ['Sqlite3Lean/select1']

    # Collect all query files
    query_files = []

    # Add Query0 if requested
    if args.include_query0:
        query0_path = project_root / 'Sqlite3Lean' / 'Query0.lean'
        if query0_path.exists():
            query_files.append(query0_path)

    # Add files from directories
    for dir_path in args.dir:
        query_dir = project_root / dir_path
        if query_dir.exists():
            query_files.extend(sorted(query_dir.glob('Query*.lean')))
        else:
            print(f"Warning: Directory not found: {query_dir}")

    # Add individual files
    for file_path in args.file:
        fp = project_root / file_path
        if fp.exists():
            query_files.append(fp)
        else:
            print(f"Warning: File not found: {fp}")

    if not query_files:
        print("No query files found")
        return 1

    print(f"Found {len(query_files)} query files")
    print("Running lake build to detect errors...")

    # Run lake build to get actual error information
    build_result = run_lake_build(project_root)
    print(f"  Found {len(build_result.unknown_opcodes)} files with unknown opcodes")
    print(f"  Found {len(build_result.sorry_files)} files with sorry")

    print("Analyzing query files...")

    # Analyze each file
    queries = []
    for qf in query_files:
        status = analyze_query_file(qf, build_result, project_root)
        queries.append(status)

    # Generate report
    output_path = project_root / args.output
    generate_html_report(queries, str(output_path), project_root)

    return 0

if __name__ == '__main__':
    exit(main())
