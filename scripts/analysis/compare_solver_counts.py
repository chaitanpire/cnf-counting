#!/usr/bin/env python3
"""
Compare solver counts extracted from log outputs.
Parses log/text files (or all files inside a directory) and extracts counts for two solvers
(defaults: approxmc and ganak). Computes per-file and aggregated error percentage:
    error_pct = (approxmc_count - ganak_count) / ganak_count

Usage:
  python scripts/analysis/compare_solver_counts.py path/to/logs/*.txt
  python scripts/analysis/compare_solver_counts.py --dir outputs/ --solvers approxmc ganak

Options:
  --solvers SOLVER1 SOLVER2   Solver names to compare (default: approxmc ganak)
  --aggregate                 Also print aggregated sums and overall error percentage
  -o, --output CSV            Optional CSV output file (file,solver1_count,solver2_count,error_pct)

"""
import argparse
import os
import re
import sys
from typing import Dict, List, Tuple

SOLVER_DEFAULTS = ["approxmc", "ganak"]

# Patterns to try (order matters) for capturing counts related to a solver
# We'll generate solver-specific regexes at runtime.


def find_counts_in_text(text: str, solver: str) -> List[int]:
    """Return a list of integer counts found in the text for the given solver.
    Heuristics try several regex patterns; duplicates may occur across file.
    We'll return all positive integer matches found.
    """
    matches: List[int] = []
    # pattern: Found <num> ... for 'solver' or for solver
    p1 = re.compile(rf"Found\s+(\d+)\s+.*for\s+'?{re.escape(solver)}'?", re.I)
    # pattern: solver: <num> entries
    p2 = re.compile(rf"{re.escape(solver)}:\s*(\d+)\s+entries", re.I)
    # pattern: solver: <num>
    p3 = re.compile(rf"{re.escape(solver)}:\s*(\d+)\b", re.I)
    # pattern: <num> ... for 'solver'
    p4 = re.compile(rf"(\d+)\s+.*for\s+'?{re.escape(solver)}'?", re.I)
    # pattern: <num> features (near solver on same line e.g. "ganak found 27 features")
    p5 = re.compile(rf"{re.escape(solver)}.*?(\d+)\s+(?:features|entries|unique benchmarks)?", re.I)

    for pat in (p1, p2, p3, p5, p4):
        for m in pat.finditer(text):
            try:
                num = int(m.group(1))
            except Exception:
                continue
            matches.append(num)
    return matches


def extract_counts_from_file(path: str, solvers: List[str]) -> Dict[str, int]:
    """Return a mapping solver->count extracted from a single file.
    Strategy: for each solver, try to find matches; prefer the last match in file if multiple.
    If no match found for a solver, it will not appear in the returned dict.
    """
    try:
        with open(path, "r", encoding="utf-8", errors="ignore") as f:
            text = f.read()
    except Exception as e:
        print(f"Warning: could not read {path}: {e}", file=sys.stderr)
        return {}

    result: Dict[str, int] = {}
    for solver in solvers:
        matches = find_counts_in_text(text, solver)
        if matches:
            # prefer last occurrence (likely most recent summary)
            result[solver] = matches[-1]
    return result


def gather_files(paths: List[str]) -> List[str]:
    files: List[str] = []
    for p in paths:
        if os.path.isdir(p):
            # add all files in directory (non-recursive)
            for entry in sorted(os.listdir(p)):
                full = os.path.join(p, entry)
                if os.path.isfile(full):
                    files.append(full)
        elif os.path.isfile(p):
            files.append(p)
        else:
            # support simple glob-like input with * by using shell expansion fallback (user's shell usually expands globs)
            # if path contains wildcard and nothing matched, try to expand with glob
            import glob

            expanded = glob.glob(p)
            if expanded:
                files.extend(sorted(expanded))
            else:
                print(f"Warning: path not found: {p}", file=sys.stderr)
    return files


def format_pct(numer: int, denom: int) -> str:
    if denom == 0:
        if numer == 0:
            return "0.0%"
        return "inf"
    return f"{(numer - denom) / denom * 100:.2f}%"


def main(argv: List[str]):
    ap = argparse.ArgumentParser(description="Extract solver counts and compare error percentage (approxmc - ganak)/ganak")
    ap.add_argument("paths", nargs="+", help="Files or directories to scan (supports globs)")
    ap.add_argument("--solvers", nargs=2, default=SOLVER_DEFAULTS, help="Two solver names: SOLVER1 SOLVER2 (default: approxmc ganak)")
    ap.add_argument("--aggregate", action="store_true", help="Also compute aggregated sums across all files")
    ap.add_argument("-o", "--output", help="Optional CSV output file path")
    args = ap.parse_args(argv)

    solvers = args.solvers
    if len(solvers) != 2:
        print("Please provide exactly two solver names to compare.")
        sys.exit(2)
    s1, s2 = solvers

    files = gather_files(args.paths)
    if not files:
        print("No files found to scan.")
        sys.exit(1)

    per_file_results: List[Tuple[str, int, int, str]] = []  # (filename, s1_count, s2_count, error_pct_str)
    agg_s1 = 0
    agg_s2 = 0
    agg_pairs = 0

    for f in files:
        counts = extract_counts_from_file(f, [s1, s2])
        s1_count = counts.get(s1)
        s2_count = counts.get(s2)
        if s1_count is None and s2_count is None:
            # skip files without either solver counts
            continue
        # for missing, set to None
        if s1_count is None:
            s1_count_val = None
        else:
            s1_count_val = int(s1_count)
        if s2_count is None:
            s2_count_val = None
        else:
            s2_count_val = int(s2_count)

        if s1_count_val is not None and s2_count_val is not None:
            err = format_pct(s1_count_val, s2_count_val)
            agg_s1 += s1_count_val
            agg_s2 += s2_count_val
            agg_pairs += 1
        else:
            err = "n/a"
        per_file_results.append((f, s1_count_val if s1_count_val is not None else -1, s2_count_val if s2_count_val is not None else -1, err))

    # Print per-file table
    print(f"Scanned {len(files)} files, matched {len(per_file_results)} files containing at least one solver count.")
    print(f"Comparing solvers: {s1} vs {s2}")
    print("")
    print(f"{'File':<60} {s1:<10} {s2:<10} error_pct")
    print("-" * 95)
    for fn, a, b, err in per_file_results:
        a_str = str(a) if a != -1 else "-"
        b_str = str(b) if b != -1 else "-"
        print(f"{os.path.basename(fn):<60} {a_str:<10} {b_str:<10} {err}")

    if args.aggregate:
        print("")
        print("Aggregated summary:")
        print(f"Files with both counts: {agg_pairs}")
        print(f"Total {s1}: {agg_s1}")
        print(f"Total {s2}: {agg_s2}")
        if agg_s2 == 0:
            print("Overall error_pct: inf (division by zero)" if agg_s1 > 0 else "Overall error_pct: 0")
        else:
            overall = (agg_s1 - agg_s2) / agg_s2 * 100.0
            print(f"Overall error_pct: {overall:.2f}%")

    # optional CSV output
    if args.output:
        try:
            import csv
            with open(args.output, "w", newline="", encoding="utf-8") as outf:
                w = csv.writer(outf)
                w.writerow(["file", s1, s2, "error_pct"])
                for fn, a, b, err in per_file_results:
                    w.writerow([fn, a if a != -1 else "", b if b != -1 else "", err])
            print(f"Wrote CSV to: {args.output}")
        except Exception as e:
            print(f"Warning: failed to write CSV: {e}", file=sys.stderr)


if __name__ == '__main__':
    main(sys.argv[1:])
