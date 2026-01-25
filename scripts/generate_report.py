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
from typing import Callable, Optional
import html

REPO_URL = "https://github.com/sivukhin/sqlite3-lean-proofs"

@dataclass
class QueryStatus:
    file_name: str
    file_path: str  # relative path for linking
    query_name: str
    namespace: str
    sql_query: Optional[str]
    formalized: bool
    terminates: Optional[bool]
    gas_bound: Optional[str]
    pr_number: Optional[str]

def extract_sql_query(content: str) -> Optional[str]:
    """Extract SQL query from the doc comment."""
    match = re.search(r'Query:\s*(.+?)(?:\n|$)', content)
    if match:
        return match.group(1).strip()
    return None

def get_pr_from_git(file_path: str, project_root: Path) -> Optional[str]:
    """Try to extract PR number from git log."""
    try:
        result = subprocess.run(
            ['git', 'log', '--oneline', '-1', '--', file_path],
            capture_output=True, text=True, cwd=project_root
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
class QueryInfo:
    formalized: bool
    terminates: Optional[bool]
    gas_bound: Optional[str]

@dataclass
class BuildResult:
    queries: dict[str, QueryInfo]

def update_build_result(r: BuildResult, key: str, f: Callable[[QueryInfo], None]):
    if key not in r.queries:
        r.queries[key] = QueryInfo(formalized=False, terminates=None, gas_bound=None)
    f(r.queries[key])

def run_lake_build(project_root: Path) -> BuildResult:
    """Run lake build and collect errors/warnings."""
    result = BuildResult(queries={})

    try:
        proc = subprocess.run(
            ['lake', 'build'],
            capture_output=True, text=True,
            cwd=project_root
        )
        output = proc.stdout + proc.stderr

        for line in output.split('\n'):
            # Parse info messages for axiom dependencies
            # e.g., "info: Main.lean:163:0: 'Sqlite3Lean.Example.program' does not depend on any axioms"
            program_definition = re.search(r"info:.*'Sqlite3Lean.([^']+).program' (.*)", line)
            if program_definition:
                name = program_definition.group(1)
                bound = program_definition.group(2)
                update_build_result(result, name, lambda x: setattr(x, 'formalized', 'sorry' not in bound))
                continue

            program_termination = re.search(r"info:.*'Sqlite3Lean.([^']+).program_terminates' (.*)", line)
            if program_termination:
                name = program_termination.group(1)
                bound = program_termination.group(2)
                update_build_result(result, name, lambda x: setattr(x, 'terminates', None if 'sorry' in bound else True))
                continue

            program_gas = re.search(r"info:.*'Sqlite3Lean.([^']+).program_gas' has gas bound: (.*)", line)
            if program_gas:
                name = program_gas.group(1)
                bound = program_gas.group(2)
                update_build_result(result, name, lambda x: setattr(x, 'gas_bound', None if 'sorry' in bound else bound))
                continue
    except Exception as e:
        print(f"Warning: Could not run lake build: {e}")
    return result

def get_namespace_from_path(file_path: Path, project_root: Path) -> str:
    """Convert file path to Lean namespace."""
    try:
        rel_path = file_path.relative_to(project_root)
        # Convert path like Sqlite3Lean/select1/Query000001.lean to Sqlite3Lean.select1.Query000001
        parts = list(rel_path.parts)
        if parts[-1].endswith('.lean'):
            parts[-1] = parts[-1][:-5]  # Remove .lean
        return '.'.join(parts)
    except ValueError:
        return file_path.stem

def analyze_query_file(file_path: Path, build_result: BuildResult, project_root: Path) -> QueryStatus:
    """Analyze a single query file and return its status."""
    # Get relative path for matching with build output
    try:
        rel_path = str(file_path.relative_to(project_root))
        display_path = rel_path
        # Remove Sqlite3Lean/ prefix for cleaner display
        if display_path.startswith('Sqlite3Lean/'):
            display_path = display_path[len('Sqlite3Lean/'):]
    except ValueError:
        rel_path = file_path.name
        display_path = file_path.name

    # Get namespace for looking up axiom info
    namespace = get_namespace_from_path(file_path, project_root)
    content = file_path.read_text()
    sql_query = extract_sql_query(content)
    pr_number = get_pr_from_git(str(file_path), project_root)

    name = display_path.replace('/', '.')[:-len('.lean')]
    result = build_result.queries.get(name, QueryInfo(formalized=False, terminates=None, gas_bound=None))

    return QueryStatus(
        file_name=display_path,
        file_path=rel_path,
        query_name=file_path.stem,
        namespace=namespace,
        sql_query=sql_query,
        formalized=result.formalized,
        terminates=result.terminates,
        gas_bound=result.gas_bound,
        pr_number=pr_number,
    )

def generate_html_report(queries: list[QueryStatus], output_path: str, project_root: Path):
    """Generate HTML report."""
    from datetime import datetime
    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

    # Calculate statistics
    total = len(queries)
    formalized = len([q for q in queries if q.formalized])
    termination_proved = len([q for q in queries if q.terminates])

    html_content = f'''<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SQLite busy challenge</title>
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

        .header {{
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }}

        .header-left {{
            display: flex;
            align-items: baseline;
            gap: 20px;
        }}

        h1 {{
            margin: 0;
            color: #333;
        }}

        .stats {{
            color: #666;
            font-size: 0.95em;
        }}

        .header-right {{
            color: #999;
            font-size: 0.85em;
        }}

        .repo-link {{
            color: #0066cc;
            text-decoration: none;
        }}

        .repo-link:hover {{
            text-decoration: underline;
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

        .query-name a {{
            color: #0066cc;
            text-decoration: none;
        }}

        .query-name a:hover {{
            text-decoration: underline;
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
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="header-left">
                <h1>SQLite busy challenge</h1>
                <span class="stats">{formalized}/{total} formalized, {termination_proved}/{total} termination proved</span>
            </div>
            <div class="header-right">
                <a class="repo-link" href="{REPO_URL}">{REPO_URL}</a> | Generated: {timestamp}
            </div>
        </div>

        <table id="query-table">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Query File</th>
                    <th>SQL Query</th>
                    <th>Formalized</th>
                    <th>Termination</th>
                    <th>Gas Bound</th>
                    <th>PR</th>
                </tr>
            </thead>
            <tbody>
'''

    for i, q in enumerate(queries, 1):
        # Formalized status
        if q.formalized:
            formalized_class = 'status-yes'
            formalized_text = 'yes'
        else:
            formalized_class = 'status-unknown'
            formalized_text = 'sorry'

        # Termination status
        if q.terminates:
            termination_class = 'status-yes'
            termination_text = 'yes'
        elif q.terminates is None:
            termination_class = 'status-unknown'
            termination_text = 'sorry'
        else:
            termination_class = 'status-no'
            termination_text = 'no'

        # Gas bound from build info
        if q.gas_bound:
            gas_bound_html = f'<span class="runtime">{html.escape(q.gas_bound)}</span>'
        else:
            gas_bound_html = '-'

        # PR link
        if q.pr_number:
            pr_html = f'<a class="pr-link" href="{REPO_URL}/pull/{q.pr_number}">#{q.pr_number}</a>'
        else:
            pr_html = '-'

        sql_html = html.escape(q.sql_query) if q.sql_query else '-'

        # Link to file in repo
        file_link = f'{REPO_URL}/blob/master/{q.file_path}'
        file_name_html = f'<a href="{file_link}">{html.escape(q.file_name)}</a>'

        html_content += f'''                <tr>
                    <td>{i}</td>
                    <td class="query-name">{file_name_html}</td>
                    <td class="sql-query" title="{sql_html}">{sql_html}</td>
                    <td class="{formalized_class}">{formalized_text}</td>
                    <td class="{termination_class}">{termination_text}</td>
                    <td>{gas_bound_html}</td>
                    <td>{pr_html}</td>
                </tr>
'''

    html_content += '''            </tbody>
        </table>
    </div>
</body>
</html>
'''

    with open(output_path, 'w') as f:
        f.write(html_content)

    print(f"Report: {output_path} | {formalized}/{total} formalized, {termination_proved}/{total} termination proved")

def main():
    parser = argparse.ArgumentParser(description='Generate HTML report for query verification progress')
    parser.add_argument('--output', '-o', default='index.html', help='Output HTML file path')
    parser.add_argument('--include-example', default=True, action='store_true', help='Include Sqlite3Lean/Example.lean')
    args = parser.parse_args()

    # Find project root
    script_dir = Path(__file__).parent
    project_root = script_dir.parent

    # Collect all query files
    query_files = []

    # Add Example if requested
    if args.include_example:
        example_path = project_root / 'Sqlite3Lean' / 'Example.lean'
        if example_path.exists():
            query_files.append(example_path)

    # Add files from directories
    for dir_path in ['Sqlite3Lean/select1']:
        query_dir = project_root / dir_path
        if query_dir.exists():
            query_files.extend(sorted(query_dir.glob('Query*.lean')))
        else:
            print(f"Warning: Directory not found: {query_dir}")

    if not query_files:
        print("No query files found")
        return 1

    print(f"Found {len(query_files)} query files, running lake build...")

    # Run lake build to get actual error information
    build_result = run_lake_build(project_root)

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
