#!/usr/bin/env python3
"""
Upload script - prepares the remote environment for experiments
"""

import yaml
import os
import json
import sys
from pathlib import Path

# Add utils to path
sys.path.insert(0, str(Path(__file__).parent.parent / "utils"))
from ssh_utils import SSHConnection


def load_config(path=None):
    if path is None:
        # Get the project root directory (two levels up from this script)
        script_dir = Path(__file__).parent
        project_root = script_dir.parent.parent
        path = project_root / "config" / "experiment_config.yaml"
    
    with open(path, 'r') as f:
        return yaml.safe_load(f)


def extract_features_from_json(json_path):
    """Extract all unique feature indices from a JSON model file.

    This function is written to handle serialized (XGBoost-like) model JSONs
    where trees are stored under:
      data['learner']['gradient_booster']['model']['trees']

    It collects all integers from each tree's `split_indices` array. If the
    expected serialized structure is not present, it will attempt a light
    fallback compatible with the older (non-serialized) format.
    """
    with open(json_path, 'r') as f:
        data = json.load(f)

    features = set()

    # Try serialized XGBoost-like format first
    gb_model = None
    try:
        gb_model = data.get('learner', {}) \
                       .get('gradient_booster', {}) \
                       .get('model', {})
    except Exception:
        gb_model = None

    if gb_model and isinstance(gb_model, dict):
        trees = gb_model.get('trees') or []
        for tree in trees:
            split_indices = tree.get('split_indices') or []
            for idx in split_indices:
                # accept ints or numeric-like values; ignore negatives
                try:
                    if idx is None:
                        continue
                    i = int(idx)
                    if i >= 0:
                        features.add(i)
                except Exception:
                    continue

        return sorted(features)

    # Fallback: older non-serialized tree-list format (kept minimal)
    try:
        trees = data
        # If file contained a dict with a top-level list under some key, try to
        # find a reasonable candidate (not required for serialized models).
        if isinstance(data, dict) and 'trees' in data and isinstance(data['trees'], list):
            trees = data['trees']

        def extract_features_from_node(node):
            if not isinstance(node, dict):
                return
            if 'split' in node and 'leaf' not in node:
                try:
                    features.add(int(node['split']))
                except Exception:
                    pass
            if 'children' in node and isinstance(node['children'], list):
                for child in node['children']:
                    extract_features_from_node(child)

        if isinstance(trees, list):
            for tree in trees:
                extract_features_from_node(tree)

    except Exception:
        # If anything fails, return empty list
        return []

    return sorted(features)


def generate_job_list(benchmark_dir):
    """Generate list of all jobs to run"""
    import glob
    import random
    
    config = load_config()
    num_features_to_sample = config.get('num_features_to_sample', -1)
    random_seed = config.get('random_seed', 42)
    
    # Set random seed for reproducibility
    random.seed(random_seed)
    
    # Find all model files
    model_jsons = sorted(glob.glob(os.path.join(benchmark_dir, '*.json')))
    
    if not model_jsons:
        print(f"No JSON files found in {benchmark_dir}")
        return []

    # Extract features from each model file
    print("Extracting features from model files...")
    jobs = []
    
    for model_path in model_jsons:
        model_name = os.path.basename(model_path)
        print(f"Processing {model_name}...")
        try:
            features = extract_features_from_json(model_path)
            print(f"  Found {len(features)} features: {features}")
            
            # Sample features if configured
            if num_features_to_sample > 0 and len(features) > num_features_to_sample:
                features = random.sample(features, num_features_to_sample)
                print(f"  Sampled {num_features_to_sample} features: {features}")
            
            for feature in features:
                for code in config['code']:
                    jobs.append({
                        'model_path': model_path,
                        'model_name': model_name,
                        'feature': feature,
                        'code': code
                    })
        except Exception as e:
            print(f"  Error processing {model_name}: {e}")
            continue
    
    return jobs


def create_remote_runner_script(config, jobs):
    """Create the remote runner script"""
    script_content = f'''#!/bin/bash

# Remote experiment runner script
# Generated automatically - do not edit manually

set -e  # Exit on any error

EXPERIMENT_DIR="{config['experiment_folder']}"
cd "$EXPERIMENT_DIR"

# Configuration
GAP={config['gap']}
PRECISION={config.get('precision', -1)}
BIT_DISTANCE={config.get('bit_distance', 1)}
NUM_CORES={config.get('num_cores', 1)}
MAX_PARALLEL_JOBS={config.get('max_parallel_jobs', 1)}
TIMEOUT={config.get('timeout', 3600)}
MEMOUT={config.get('memout', 16)}  # in GB
MEMOUT_KB=$((MEMOUT * 1024 * 1024))  # Convert GB to KB

echo "Starting experiment run at $(date)"
echo "Running {len(jobs)} total jobs with up to $MAX_PARALLEL_JOBS jobs in parallel"
echo "Each xcount process will run single-threaded"

# Create output directories
mkdir -p outputs logs

# Job counter and parallel control
JOB_COUNT=0
TOTAL_JOBS={len(jobs)}
RUNNING_JOBS=0

# Function to wait for job slots
wait_for_slot() {{
    while [ $RUNNING_JOBS -ge $MAX_PARALLEL_JOBS ]; do
        wait -n  # Wait for any background job to finish
        RUNNING_JOBS=$((RUNNING_JOBS - 1))
        JOB_COUNT=$((JOB_COUNT + 1))
        echo "Progress: $JOB_COUNT/$TOTAL_JOBS jobs completed"
    done
}}

# Function to run a single job
run_job() {{
    local job_id=$1
    local model_path=$2
    local model_name=$3
    local feature=$4
    local output_file=$5
    local code=$6
    
    echo "Starting job $((job_id + 1))/$TOTAL_JOBS: $model_name feature $feature"
    ulimit -v $MEMOUT_KB  # Set memory limit
    if [ "$code" == "ganak" ]; then
        if timeout $TIMEOUT ./ganak.sh "$model_path" $feature $GAP $PRECISION $BIT_DISTANCE > "$output_file" 2>&1; then
            echo "  ✓ Completed job $((job_id + 1)): $model_name feature $feature"
        else
            EXIT_CODE=$?
            if [ $EXIT_CODE -eq 124 ]; then
                echo "  ⏰ Job $((job_id + 1)) timed out after $TIMEOUT seconds: $model_name feature $feature"
            else
                echo "  ✗ Job $((job_id + 1)) failed with exit code $EXIT_CODE: $model_name feature $feature"
            fi
        fi
    elif [ "$code" == "approxmc" ]; then
        if timeout $TIMEOUT ./approxmc.sh "$model_path" $feature $GAP $PRECISION $BIT_DISTANCE > "$output_file" 2>&1; then
            echo "  ✓ Completed job $((job_id + 1)): $model_name feature $feature"
        else
            EXIT_CODE=$?
            if [ $EXIT_CODE -eq 124 ]; then
                echo "  ⏰ Job $((job_id + 1)) timed out after $TIMEOUT seconds: $model_name feature $feature"
            else
                echo "  ✗ Job $((job_id + 1)) failed with exit code $EXIT_CODE: $model_name feature $feature"
            fi
        fi
    fi
}}

'''

    # Add each job to the script
    for i, job in enumerate(jobs):
        model_name = job['model_name']
        feature = job['feature']
        script_content += f'''
# Job {i}: {model_name} feature {feature}
wait_for_slot

OUTPUT_FILE="outputs/{i:04d}_{model_name.replace('.json', '')}.out"
run_job {i} "{job['model_path']}" "{model_name}" {feature} $OUTPUT_FILE "{job['code']}" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))
'''

    script_content += '''
# Wait for all remaining jobs to complete
while [ $RUNNING_JOBS -gt 0 ]; do
    wait -n
    RUNNING_JOBS=$((RUNNING_JOBS - 1))
    JOB_COUNT=$((JOB_COUNT + 1))
    echo "Progress: $JOB_COUNT/$TOTAL_JOBS jobs completed"
done

echo "All experiments completed at $(date)"

# Generate plots if script exists
if [ -f "plot_cactus.py" ]; then
    echo "Generating plots..."
    python3 plot_cactus.py
fi

echo "Experiment run finished successfully!"
'''

    return script_content


def main():
    config = load_config()
    user = config['user']
    server = config['server']
    host = config['host']
    exp_folder = config['experiment_folder']
    benchmark_dir = config['benchmark_dir']
    upload = config.get('upload_code', True)
    compile = config.get('compile', True)
    
    print("=== Upload and Prepare Remote Environment ===")
    print(f"Target: {exp_folder} on {host}")
    print(f"Upload code: {upload}")
    print(f"Compile: {compile}")
    
    # Generate job list
    jobs = generate_job_list(benchmark_dir)
    if not jobs:
        print("No jobs to run. Exiting.")
        return
    
    print(f"Generated {len(jobs)} jobs")
    
    # Create remote runner script
    runner_script = create_remote_runner_script(config, jobs)
    
    # Save runner script locally first
    with open('remote_runner.sh', 'w') as f:
        f.write(runner_script)
    print("Created remote_runner.sh")
    
    # Connect and upload
    with SSHConnection(user, server, host) as ssh_conn:
        print("Connected to remote server")
        
        if upload:
            # Clean and create experiment directory
            print("Setting up remote directory...")
            print(f"Warning: This will delete the existing directory at {exp_folder} on the remote server.")
            # take confirmation from user
            confirmation = input("Type 'YES' to confirm: ")
            if confirmation != 'YES':
                print("Upload cancelled by user.")
                return
            ssh_conn.execute_command(f"rm -rf {exp_folder}")
            ssh_conn.execute_command(f"mkdir -p {exp_folder}")
            
            # Upload all code
            print("Uploading code...")
            local_code_dir = os.getcwd()
            ssh_conn.upload_files(local_code_dir, exp_folder)
            
            # Make runner script executable
            ssh_conn.execute_command("chmod +x remote_runner.sh", cwd=exp_folder)
            ssh_conn.execute_command("chmod +x ganak.sh", cwd=exp_folder)
            ssh_conn.execute_command("chmod +x approxmc.sh", cwd=exp_folder)
            # Create model_cnf directory after upload
            ssh_conn.execute_command("mkdir -p model_cnf", cwd=exp_folder)
            
            # Clean and rebuild PBEncoder
            print("Building PBEncoder...")
            ssh_conn.execute_command("rm -rf PBEncoder/build", cwd=exp_folder)
            ssh_conn.execute_command("./INSTALL.sh", cwd=os.path.join(exp_folder, "PBEncoder"))
            ssh_conn.execute_command(f"mkdir -p {exp_folder}/ganak_outputs", cwd=exp_folder)
            ssh_conn.execute_command(f"mkdir -p {exp_folder}/approxmc_outputs", cwd=exp_folder)
            ssh_conn.execute_command(f"chmod +x {exp_folder}/ganak.sh", cwd=exp_folder)
            ssh_conn.execute_command(f"chmod +x {exp_folder}/approxmc.sh", cwd=exp_folder)
        else:
            print("Skipping upload (upload_code=false in config)")
            # Still need to ensure runner script exists on remote
            print("Uploading only the runner script...")

            with open('remote_runner.sh', 'r') as f:
                script_content = f.read()
            ssh_conn.execute_command(f"cat > {exp_folder}/remote_runner.sh << 'EOF'\n{script_content}\nEOF")
            ssh_conn.execute_command("chmod +x remote_runner.sh", cwd=exp_folder)
        
        print("✓ Upload and preparation complete!")
        print(f"✓ Remote runner script ready at {exp_folder}/remote_runner.sh")
        print(f"✓ To start experiments, run: python3 trigger_experiments.py")


if __name__ == '__main__':
    main()