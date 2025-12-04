#!/usr/bin/env python3
"""
Extract execution times from experiment output files and generate CSV
"""

import os
import re
import csv
import sys
from pathlib import Path


def extract_time_from_opt_file(filepath):
    """Extract execution time from xcount (opt) output file"""
    try:
        with open(filepath, 'r') as f:
            content = f.read()
            
        # Look for "Total time taken: X" pattern
        match = re.search(r'Total time taken:\s+(\d+(?:\.\d+)?)', content)
        if match:
            return float(match.group(1))
        
        return None
    except Exception as e:
        print(f"Error reading {filepath}: {e}")
        return None


def extract_time_from_baseline_file(filepath):
    """Extract execution time from xcount_base (baseline) output file"""
    try:
        with open(filepath, 'r') as f:
            content = f.read()
            
        # Look for "Time taken: X seconds" pattern
        match = re.search(r'Time taken:\s+(\d+(?:\.\d+)?)\s+seconds?', content)
        if match:
            return float(match.group(1))
        
        return None
    except Exception as e:
        print(f"Error reading {filepath}: {e}")
        return None


def extract_metadata_from_filename(filename):
    """Extract job id and model name from filename like 0000_0010_d_2.out"""
    match = re.match(r'(\d+)_(.+)\.out$', filename)
    if match:
        job_id = match.group(1)
        model_name = match.group(2)
        return job_id, model_name
    return None, filename


def extract_feature_from_file(filepath):
    """Extract sensitive feature from output file"""
    try:
        with open(filepath, 'r') as f:
            content = f.read()
            
        # Look for "Sensitive features: X" pattern
        match = re.search(r'Sensitive features?:\s+(\d+)', content)
        if match:
            return match.group(1)
        
        return None
    except Exception as e:
        return None


def process_outputs_directory(outputs_dir, output_csv):
    """Process all output files in directory and generate CSV"""
    
    if not os.path.exists(outputs_dir):
        print(f"Error: Directory {outputs_dir} does not exist")
        return
    
    # Collect data
    data = {}
    
    # Process all .out files
    for filename in sorted(os.listdir(outputs_dir)):
        if not filename.endswith('.out'):
            continue
        
        filepath = os.path.join(outputs_dir, filename)
        job_id, model_name = extract_metadata_from_filename(filename)
        
        if job_id is None:
            continue
        
        # Initialize entry if not exists
        if job_id not in data:
            data[job_id] = {
                'job_id': job_id,
                'model_name': model_name,
                'feature': None,
                'xcount': None,
                'xcount_base': None
            }
        
        # Check if it's a baseline file (starts with baseline_)
        if filename.startswith('baseline_'):
            time_taken = extract_time_from_baseline_file(filepath)
            data[job_id]['xcount_base'] = time_taken
            if data[job_id]['feature'] is None:
                data[job_id]['feature'] = extract_feature_from_file(filepath)
        else:
            time_taken = extract_time_from_opt_file(filepath)
            data[job_id]['xcount'] = time_taken
            if data[job_id]['feature'] is None:
                data[job_id]['feature'] = extract_feature_from_file(filepath)
    
    # Write to CSV
    with open(output_csv, 'w', newline='') as csvfile:
        fieldnames = ['job_id', 'model_name', 'feature', 'xcount', 'xcount_base']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        
        writer.writeheader()
        for job_id in sorted(data.keys()):
            writer.writerow(data[job_id])
    
    print(f"✓ Extracted execution times for {len(data)} jobs")
    print(f"✓ CSV written to: {output_csv}")


def main():
    if len(sys.argv) < 2:
        print("Usage: python extract_execution_times.py <outputs_directory> [output_csv]")
        print("\nExample:")
        print("  python extract_execution_times.py outputs execution_times.csv")
        print("  python extract_execution_times.py ./outputs")
        sys.exit(1)
    
    outputs_dir = sys.argv[1]
    output_csv = sys.argv[2] if len(sys.argv) > 2 else 'execution_times.csv'
    
    process_outputs_directory(outputs_dir, output_csv)


if __name__ == '__main__':
    main()
