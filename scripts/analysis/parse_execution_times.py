#!/usr/bin/env python3
"""
Parse execution times from ganak and approxmc output files and generate a CSV report.

Usage:
    python parse_execution_times.py <output_dir> [output_csv]
    
Example:
    python parse_execution_times.py ../../outputs results.csv
    python parse_execution_times.py . execution_times.csv
"""

import os
import re
import sys
import csv
from pathlib import Path
from collections import defaultdict


def parse_execution_time(file_path):
    """
    Parse execution time from an output file.
    
    Returns:
        tuple: (solver_type, model_name, feature, time_seconds) or None if not found
    """
    try:
        with open(file_path, 'r') as f:
            content = f.read()
        
        # Pattern: "ganak execution time for MODEL on feature FEATURE : TIME seconds"
        # Pattern: "approxmc execution time for MODEL on feature FEATURE : TIME seconds"
        pattern = r'(ganak|approxmc) execution time for (\S+) on feature (\d+) : (\d+) seconds'
        match = re.search(pattern, content)
        
        if match:
            solver_type = match.group(1)
            model_name = match.group(2)
            feature = int(match.group(3))
            time_seconds = int(match.group(4))
            return solver_type, model_name, feature, time_seconds
        
        return None
    except Exception as e:
        print(f"Error parsing {file_path}: {e}", file=sys.stderr)
        return None


def collect_execution_times(output_dir):
    """
    Collect execution times from all .out files in the directory.
    
    Returns:
        dict: Nested dict structure {model_name: {feature: {solver: time}}}
    """
    output_dir = Path(output_dir)
    results = defaultdict(lambda: defaultdict(dict))
    
    # Find all .out files
    out_files = sorted(output_dir.glob('*.out'))
    
    if not out_files:
        print(f"Warning: No .out files found in {output_dir}", file=sys.stderr)
        return results
    
    print(f"Processing {len(out_files)} output files...")
    
    for out_file in out_files:
        parsed = parse_execution_time(out_file)
        if parsed:
            solver_type, model_name, feature, time_seconds = parsed
            results[model_name][feature][solver_type] = time_seconds
            print(f"  {out_file.name}: {solver_type} - {model_name} feature {feature} = {time_seconds}s")
        else:
            print(f"  {out_file.name}: No execution time found", file=sys.stderr)
    
    return results


def write_csv(results, output_csv):
    """
    Write results to a CSV file with columns: model, feature, ganak, approxmc
    
    Args:
        results: Nested dict {model_name: {feature: {solver: time}}}
        output_csv: Path to output CSV file
    """
    with open(output_csv, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        
        # Write header
        writer.writerow(['model', 'feature', 'ganak', 'approxmc'])
        
        # Sort by model name, then by feature
        for model_name in sorted(results.keys()):
            for feature in sorted(results[model_name].keys()):
                ganak_time = results[model_name][feature].get('ganak', '')
                approxmc_time = results[model_name][feature].get('approxmc', '')
                writer.writerow([model_name, feature, ganak_time, approxmc_time])
    
    print(f"\nWrote results to {output_csv}")


def main():
    if len(sys.argv) < 2:
        print("Usage: python parse_execution_times.py <output_dir> [output_csv]")
        print("Example: python parse_execution_times.py ./outputs results.csv")
        sys.exit(1)
    
    output_dir = sys.argv[1]
    output_csv = sys.argv[2] if len(sys.argv) > 2 else 'execution_times.csv'
    
    if not os.path.isdir(output_dir):
        print(f"Error: Directory '{output_dir}' does not exist", file=sys.stderr)
        sys.exit(1)
    
    # Collect execution times
    results = collect_execution_times(output_dir)
    
    if not results:
        print("No execution times found. Exiting.", file=sys.stderr)
        sys.exit(1)
    
    # Write to CSV
    write_csv(results, output_csv)
    
    # Print summary statistics
    total_entries = sum(len(features) for features in results.values())
    print(f"\nSummary:")
    print(f"  Models: {len(results)}")
    print(f"  Total entries: {total_entries}")
    print(f"  Output: {output_csv}")


if __name__ == '__main__':
    main()
