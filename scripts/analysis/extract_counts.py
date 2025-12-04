#!/usr/bin/env python3
"""
Extract solver counts from the last N lines of log files and write CSV with
columns: file, model, feature, ganak, approxmc

Heuristics (search only last 20 lines by default):
- approxmc: matched by patterns like "<num> mc", "mc: <num>", or occurrences of "approxmc"
- ganak: matched by patterns like "<num> exact arb int", "exact arb int: <num>", or occurrences of "ganak"

Additionally tries to extract a model name from the file content ("model_path:" or "model name:")
or from the filename (dropping leading job id prefix if present). For "feature" it will try to
extract a trailing numeric token from the model name or look for lines mentioning "feature".

Usage examples:
  python3 scripts/analysis/extract_last20_counts.py /path/to/logs/*.out -o counts.csv
  python3 scripts/analysis/extract_last20_counts.py outputs/0002_0010_d_2_s.out

"""
import argparse
import csv
import os
import re
import sys
from typing import List, Optional, Tuple

LAST_N = 20

APPROX_PATTERNS = [
    re.compile(r"s\s+mc\s+(\d+)", re.I),  # matches "s mc 1234"
    re.compile(r"^(\d+)\s+mc\s*$", re.I | re.M),  # matches "1234 mc" alone on line
    re.compile(r"mc\s*:\s*(\d+)", re.I),
]

GANAK_PATTERNS = [
    re.compile(r"s\s+exact\s+arb\s+int\s+(\d+)", re.I),  # matches "s exact arb int 1234"
    re.compile(r"^(\d+)\s+exact\s+arb\s+int\s*$", re.I | re.M),  # matches "1234 exact arb int"
    re.compile(r"exact\s+arb\s+int\s*:\s*(\d+)", re.I),
]

MODEL_PATH_RE = re.compile(r"model_path:\s*(\S+)", re.I)
MODEL_NAME_RE = re.compile(r"model name:\s*(\S+)", re.I)
FEATURE_LINE_RE = re.compile(r"feature[s]?\s*[:]?\s*(\d+)", re.I)


def tail_lines(path: str, n: int = 20) -> List[str]:
    """Efficiently read last n lines of a file."""
    try:
        with open(path, "rb") as f:
            # Seek from end in chunks
            avg_line_len = 200
            to_read = n * avg_line_len
            try:
                f.seek(-to_read, os.SEEK_END)
            except OSError:
                f.seek(0, os.SEEK_SET)
            data = f.read().decode("utf-8", errors="ignore")
    except Exception:
        # fallback read whole file
        try:
            with open(path, "r", encoding="utf-8", errors="ignore") as f:
                data = f.read()
        except Exception:
            return []
    lines = data.strip().splitlines()
    return lines[-n:]


def first_match_number(lines: List[str], patterns: List[re.Pattern]) -> Optional[int]:
    """Search lines from top to bottom and return the last matched number found among lines and patterns."""
    found: Optional[int] = None
    for line in lines:
        for pat in patterns:
            m = pat.search(line)
            if m:
                try:
                    found = int(m.group(1))
                except Exception:
                    continue
    return found


def extract_model_and_feature(full_text: str, filename: str) -> Tuple[str, Optional[str]]:
    """Try to extract model and feature from file content or filename.
    
    Filename pattern expected: <jobid>_<model>_<feature>.out
    Example: 0002_0010_d_2_s.out -> model=0010_d_2_s, feature=2
    """
    m = MODEL_PATH_RE.search(full_text)
    model = None
    if m:
        model = os.path.splitext(os.path.basename(m.group(1)))[0]
    else:
        m2 = MODEL_NAME_RE.search(full_text)
        if m2:
            model = os.path.splitext(os.path.basename(m2.group(1)))[0]
    
    # Extract feature from filename pattern: <jobid>_<model>_<feature>.out
    feat = None
    base = os.path.splitext(os.path.basename(filename))[0]
    parts = base.split("_")
    
    # If filename starts with a 4-digit job ID (e.g., 0002_0010_d_2_s)
    # Extract model as everything after first part, feature as last numeric token
    if parts and parts[0].isdigit() and len(parts[0]) == 4:
        # model is parts[1:]
        if not model:
            model = "_".join(parts[1:])
        # feature is the last part if it's a digit, otherwise search for last digit in model
        if parts[-1].isdigit():
            feat = parts[-1]
        elif len(parts) >= 2 and parts[-2].isdigit():
            # handle cases like 0002_0010_d_2_s where '2' is the feature
            feat = parts[-2]
    else:
        if not model:
            model = base
    
    # Fallback: search for _f<number> pattern or last numeric token
    if not feat:
        m_f = re.search(r"_f(\d+)\b", model or base)
        if m_f:
            feat = m_f.group(1)
        else:
            num_tokens = re.findall(r"(\d+)", model or base)
            if num_tokens:
                feat = num_tokens[-1]
    
    return model, feat


def process_file(path: str, n: int = 20) -> Tuple[str, Optional[str], Optional[int], Optional[int], bool]:
    """Return (model, feature, ganak_count, approxmc_count, has_execution_time) for a file."""
    # read last N lines
    tail = tail_lines(path, n)
    tail_text = "\n".join(tail)
    
    # Read only first few lines for model extraction
    try:
        with open(path, "r", encoding="utf-8", errors="ignore") as f:
            first_lines = []
            for i, line in enumerate(f):
                first_lines.append(line)
                if i >= 10:  # Only read first 10 lines for model path
                    break
            first_text = "".join(first_lines)
    except Exception:
        first_text = ""

    approx = first_match_number(tail, APPROX_PATTERNS)
    ganak = first_match_number(tail, GANAK_PATTERNS)

    # Extract model from file content (first few lines)
    model = None
    m = MODEL_PATH_RE.search(first_text)
    if m:
        model = os.path.splitext(os.path.basename(m.group(1)))[0]
    else:
        m2 = MODEL_NAME_RE.search(first_text)
        if m2:
            model = os.path.splitext(os.path.basename(m2.group(1)))[0]
    
    if not model:
        # Fallback to filename
        base = os.path.splitext(os.path.basename(path))[0]
        parts = base.split("_")
        if parts and parts[0].isdigit() and len(parts[0]) == 4:
            model = "_".join(parts[1:])
        else:
            model = base
    
    # Extract feature from execution time line in last N lines
    feat = None
    exec_time_match = re.search(r"(approxmc|ganak)\s+execution\s+time\s+for\s+\S+\s+on\s+feature\s+(\d+)", tail_text, re.I)
    if exec_time_match:
        feat = exec_time_match.group(2)
    
    # Check if LAST N LINES contain execution time line
    has_execution_time = exec_time_match is not None
    
    return model, feat, ganak, approx, has_execution_time


def gather_input_files(paths: List[str]) -> List[str]:
    import glob
    files: List[str] = []
    for p in paths:
        if os.path.isdir(p):
            for entry in sorted(os.listdir(p)):
                full = os.path.join(p, entry)
                if os.path.isfile(full):
                    files.append(full)
        else:
            expanded = glob.glob(p)
            if expanded:
                files.extend(sorted(expanded))
            elif os.path.isfile(p):
                files.append(p)
            else:
                print(f"Warning: no match for {p}", file=sys.stderr)
    return files


def main(argv: List[str]):
    ap = argparse.ArgumentParser(description="Extract counts from last lines and write CSV")
    ap.add_argument("paths", nargs="+", help="Files, globs, or directories to scan")
    ap.add_argument("-o", "--output", help="CSV output path (default: stdout)")
    ap.add_argument("-n", type=int, default=20, help="Number of last lines to inspect (default: 20)")
    args = ap.parse_args(argv)

    nlines = args.n

    files = gather_input_files(args.paths)
    if not files:
        print("No input files found.")
        sys.exit(1)

    # Collect results and merge by model+feature
    results_dict = {}  # key: (model, feature), value: {ganak: ..., approxmc: ..., has_time: ...}
    for f in files:
        model, feat, ganak, approx, has_time = process_file(f, n=nlines)
        print(f"Processed {os.path.basename(f)}: model={model}, feature={feat}, ganak={ganak}, approxmc={approx}, has_time={has_time}", file=sys.stderr)
        key = (model, feat if feat is not None else "")
        if key not in results_dict:
            results_dict[key] = {"model": model, "feature": feat if feat is not None else "", "ganak": "", "approxmc": "", "has_time": False}
        if ganak is not None:
            results_dict[key]["ganak"] = ganak
        if approx is not None:
            results_dict[key]["approxmc"] = approx
        if has_time:
            results_dict[key]["has_time"] = True
    
    # Filter to only include rows with execution time line
    filtered_results = [v for v in results_dict.values() if v["has_time"]]
    
    # Remove has_time from output
    rows = [{"model": r["model"], "feature": r["feature"], "ganak": r["ganak"], "approxmc": r["approxmc"]} for r in filtered_results]
    fieldnames = ["model", "feature", "ganak", "approxmc"]
    if args.output:
        try:
            with open(args.output, "w", newline="", encoding="utf-8") as outf:
                w = csv.DictWriter(outf, fieldnames=fieldnames)
                w.writeheader()
                for r in rows:
                    w.writerow(r)
            print(f"Wrote {len(rows)} rows to {args.output}")
        except Exception as e:
            print(f"Failed to write CSV: {e}", file=sys.stderr)
    else:
        # print CSV to stdout
        w = csv.DictWriter(sys.stdout, fieldnames=fieldnames)
        w.writeheader()
        for r in rows:
            w.writerow(r)


if __name__ == '__main__':
    main(sys.argv[1:])
