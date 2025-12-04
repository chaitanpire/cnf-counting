#!/bin/bash

# Remote experiment runner script
# Generated automatically - do not edit manually

set -e  # Exit on any error

EXPERIMENT_DIR="/home/ajinkya/experiments/ganak_adult"
cd "$EXPERIMENT_DIR"

# Configuration
GAP=1
PRECISION=100
BIT_DISTANCE=1
NUM_CORES=1
MAX_PARALLEL_JOBS=100
TIMEOUT=1800
MEMOUT=16  # in GB
MEMOUT_KB=$((MEMOUT * 1024 * 1024))  # Convert GB to KB

echo "Starting experiment run at $(date)"
echo "Running 609 total jobs with up to $MAX_PARALLEL_JOBS jobs in parallel"
echo "Each xcount process will run single-threaded"

# Create output directories
mkdir -p outputs logs

# Job counter and parallel control
JOB_COUNT=0
TOTAL_JOBS=609
RUNNING_JOBS=0

# Function to wait for job slots
wait_for_slot() {
    while [ $RUNNING_JOBS -ge $MAX_PARALLEL_JOBS ]; do
        wait -n  # Wait for any background job to finish
        RUNNING_JOBS=$((RUNNING_JOBS - 1))
        JOB_COUNT=$((JOB_COUNT + 1))
        echo "Progress: $JOB_COUNT/$TOTAL_JOBS jobs completed"
    done
}

# Function to run a single job
run_job() {
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
}


# Job 0: 0010_d_2_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0000_0010_d_2_s.out"
run_job 0 "./models/adult/0010_d_2_s.json" "0010_d_2_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 1: 0010_d_2_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0001_0010_d_2_s.out"
run_job 1 "./models/adult/0010_d_2_s.json" "0010_d_2_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 2: 0010_d_2_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0002_0010_d_2_s.out"
run_job 2 "./models/adult/0010_d_2_s.json" "0010_d_2_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 3: 0010_d_2_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0003_0010_d_2_s.out"
run_job 3 "./models/adult/0010_d_2_s.json" "0010_d_2_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 4: 0010_d_2_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0004_0010_d_2_s.out"
run_job 4 "./models/adult/0010_d_2_s.json" "0010_d_2_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 5: 0010_d_3_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0005_0010_d_3_s.out"
run_job 5 "./models/adult/0010_d_3_s.json" "0010_d_3_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 6: 0010_d_3_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0006_0010_d_3_s.out"
run_job 6 "./models/adult/0010_d_3_s.json" "0010_d_3_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 7: 0010_d_3_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0007_0010_d_3_s.out"
run_job 7 "./models/adult/0010_d_3_s.json" "0010_d_3_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 8: 0010_d_3_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0008_0010_d_3_s.out"
run_job 8 "./models/adult/0010_d_3_s.json" "0010_d_3_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 9: 0010_d_3_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0009_0010_d_3_s.out"
run_job 9 "./models/adult/0010_d_3_s.json" "0010_d_3_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 10: 0010_d_3_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0010_0010_d_3_s.out"
run_job 10 "./models/adult/0010_d_3_s.json" "0010_d_3_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 11: 0010_d_3_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0011_0010_d_3_s.out"
run_job 11 "./models/adult/0010_d_3_s.json" "0010_d_3_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 12: 0010_d_4_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0012_0010_d_4_s.out"
run_job 12 "./models/adult/0010_d_4_s.json" "0010_d_4_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 13: 0010_d_4_s.json feature 2
wait_for_slot

OUTPUT_FILE="outputs/0013_0010_d_4_s.out"
run_job 13 "./models/adult/0010_d_4_s.json" "0010_d_4_s.json" 2 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 14: 0010_d_4_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0014_0010_d_4_s.out"
run_job 14 "./models/adult/0010_d_4_s.json" "0010_d_4_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 15: 0010_d_4_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0015_0010_d_4_s.out"
run_job 15 "./models/adult/0010_d_4_s.json" "0010_d_4_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 16: 0010_d_4_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0016_0010_d_4_s.out"
run_job 16 "./models/adult/0010_d_4_s.json" "0010_d_4_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 17: 0010_d_4_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0017_0010_d_4_s.out"
run_job 17 "./models/adult/0010_d_4_s.json" "0010_d_4_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 18: 0010_d_4_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0018_0010_d_4_s.out"
run_job 18 "./models/adult/0010_d_4_s.json" "0010_d_4_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 19: 0010_d_5_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0019_0010_d_5_s.out"
run_job 19 "./models/adult/0010_d_5_s.json" "0010_d_5_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 20: 0010_d_5_s.json feature 2
wait_for_slot

OUTPUT_FILE="outputs/0020_0010_d_5_s.out"
run_job 20 "./models/adult/0010_d_5_s.json" "0010_d_5_s.json" 2 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 21: 0010_d_5_s.json feature 3
wait_for_slot

OUTPUT_FILE="outputs/0021_0010_d_5_s.out"
run_job 21 "./models/adult/0010_d_5_s.json" "0010_d_5_s.json" 3 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 22: 0010_d_5_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0022_0010_d_5_s.out"
run_job 22 "./models/adult/0010_d_5_s.json" "0010_d_5_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 23: 0010_d_5_s.json feature 6
wait_for_slot

OUTPUT_FILE="outputs/0023_0010_d_5_s.out"
run_job 23 "./models/adult/0010_d_5_s.json" "0010_d_5_s.json" 6 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 24: 0010_d_5_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0024_0010_d_5_s.out"
run_job 24 "./models/adult/0010_d_5_s.json" "0010_d_5_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 25: 0010_d_5_s.json feature 8
wait_for_slot

OUTPUT_FILE="outputs/0025_0010_d_5_s.out"
run_job 25 "./models/adult/0010_d_5_s.json" "0010_d_5_s.json" 8 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 26: 0010_d_5_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0026_0010_d_5_s.out"
run_job 26 "./models/adult/0010_d_5_s.json" "0010_d_5_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 27: 0010_d_5_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0027_0010_d_5_s.out"
run_job 27 "./models/adult/0010_d_5_s.json" "0010_d_5_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 28: 0010_d_5_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0028_0010_d_5_s.out"
run_job 28 "./models/adult/0010_d_5_s.json" "0010_d_5_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 29: 0010_d_5_s.json feature 13
wait_for_slot

OUTPUT_FILE="outputs/0029_0010_d_5_s.out"
run_job 29 "./models/adult/0010_d_5_s.json" "0010_d_5_s.json" 13 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 30: 0010_d_6_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0030_0010_d_6_s.out"
run_job 30 "./models/adult/0010_d_6_s.json" "0010_d_6_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 31: 0010_d_6_s.json feature 1
wait_for_slot

OUTPUT_FILE="outputs/0031_0010_d_6_s.out"
run_job 31 "./models/adult/0010_d_6_s.json" "0010_d_6_s.json" 1 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 32: 0010_d_6_s.json feature 2
wait_for_slot

OUTPUT_FILE="outputs/0032_0010_d_6_s.out"
run_job 32 "./models/adult/0010_d_6_s.json" "0010_d_6_s.json" 2 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 33: 0010_d_6_s.json feature 3
wait_for_slot

OUTPUT_FILE="outputs/0033_0010_d_6_s.out"
run_job 33 "./models/adult/0010_d_6_s.json" "0010_d_6_s.json" 3 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 34: 0010_d_6_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0034_0010_d_6_s.out"
run_job 34 "./models/adult/0010_d_6_s.json" "0010_d_6_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 35: 0010_d_6_s.json feature 6
wait_for_slot

OUTPUT_FILE="outputs/0035_0010_d_6_s.out"
run_job 35 "./models/adult/0010_d_6_s.json" "0010_d_6_s.json" 6 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 36: 0010_d_6_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0036_0010_d_6_s.out"
run_job 36 "./models/adult/0010_d_6_s.json" "0010_d_6_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 37: 0010_d_6_s.json feature 8
wait_for_slot

OUTPUT_FILE="outputs/0037_0010_d_6_s.out"
run_job 37 "./models/adult/0010_d_6_s.json" "0010_d_6_s.json" 8 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 38: 0010_d_6_s.json feature 9
wait_for_slot

OUTPUT_FILE="outputs/0038_0010_d_6_s.out"
run_job 38 "./models/adult/0010_d_6_s.json" "0010_d_6_s.json" 9 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 39: 0010_d_6_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0039_0010_d_6_s.out"
run_job 39 "./models/adult/0010_d_6_s.json" "0010_d_6_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 40: 0010_d_6_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0040_0010_d_6_s.out"
run_job 40 "./models/adult/0010_d_6_s.json" "0010_d_6_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 41: 0010_d_6_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0041_0010_d_6_s.out"
run_job 41 "./models/adult/0010_d_6_s.json" "0010_d_6_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 42: 0010_d_6_s.json feature 13
wait_for_slot

OUTPUT_FILE="outputs/0042_0010_d_6_s.out"
run_job 42 "./models/adult/0010_d_6_s.json" "0010_d_6_s.json" 13 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 43: 0020_d_2_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0043_0020_d_2_s.out"
run_job 43 "./models/adult/0020_d_2_s.json" "0020_d_2_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 44: 0020_d_2_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0044_0020_d_2_s.out"
run_job 44 "./models/adult/0020_d_2_s.json" "0020_d_2_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 45: 0020_d_2_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0045_0020_d_2_s.out"
run_job 45 "./models/adult/0020_d_2_s.json" "0020_d_2_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 46: 0020_d_2_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0046_0020_d_2_s.out"
run_job 46 "./models/adult/0020_d_2_s.json" "0020_d_2_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 47: 0020_d_2_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0047_0020_d_2_s.out"
run_job 47 "./models/adult/0020_d_2_s.json" "0020_d_2_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 48: 0020_d_2_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0048_0020_d_2_s.out"
run_job 48 "./models/adult/0020_d_2_s.json" "0020_d_2_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 49: 0020_d_2_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0049_0020_d_2_s.out"
run_job 49 "./models/adult/0020_d_2_s.json" "0020_d_2_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 50: 0020_d_3_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0050_0020_d_3_s.out"
run_job 50 "./models/adult/0020_d_3_s.json" "0020_d_3_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 51: 0020_d_3_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0051_0020_d_3_s.out"
run_job 51 "./models/adult/0020_d_3_s.json" "0020_d_3_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 52: 0020_d_3_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0052_0020_d_3_s.out"
run_job 52 "./models/adult/0020_d_3_s.json" "0020_d_3_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 53: 0020_d_3_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0053_0020_d_3_s.out"
run_job 53 "./models/adult/0020_d_3_s.json" "0020_d_3_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 54: 0020_d_3_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0054_0020_d_3_s.out"
run_job 54 "./models/adult/0020_d_3_s.json" "0020_d_3_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 55: 0020_d_3_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0055_0020_d_3_s.out"
run_job 55 "./models/adult/0020_d_3_s.json" "0020_d_3_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 56: 0020_d_3_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0056_0020_d_3_s.out"
run_job 56 "./models/adult/0020_d_3_s.json" "0020_d_3_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 57: 0020_d_4_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0057_0020_d_4_s.out"
run_job 57 "./models/adult/0020_d_4_s.json" "0020_d_4_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 58: 0020_d_4_s.json feature 1
wait_for_slot

OUTPUT_FILE="outputs/0058_0020_d_4_s.out"
run_job 58 "./models/adult/0020_d_4_s.json" "0020_d_4_s.json" 1 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 59: 0020_d_4_s.json feature 2
wait_for_slot

OUTPUT_FILE="outputs/0059_0020_d_4_s.out"
run_job 59 "./models/adult/0020_d_4_s.json" "0020_d_4_s.json" 2 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 60: 0020_d_4_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0060_0020_d_4_s.out"
run_job 60 "./models/adult/0020_d_4_s.json" "0020_d_4_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 61: 0020_d_4_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0061_0020_d_4_s.out"
run_job 61 "./models/adult/0020_d_4_s.json" "0020_d_4_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 62: 0020_d_4_s.json feature 6
wait_for_slot

OUTPUT_FILE="outputs/0062_0020_d_4_s.out"
run_job 62 "./models/adult/0020_d_4_s.json" "0020_d_4_s.json" 6 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 63: 0020_d_4_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0063_0020_d_4_s.out"
run_job 63 "./models/adult/0020_d_4_s.json" "0020_d_4_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 64: 0020_d_4_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0064_0020_d_4_s.out"
run_job 64 "./models/adult/0020_d_4_s.json" "0020_d_4_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 65: 0020_d_4_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0065_0020_d_4_s.out"
run_job 65 "./models/adult/0020_d_4_s.json" "0020_d_4_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 66: 0020_d_4_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0066_0020_d_4_s.out"
run_job 66 "./models/adult/0020_d_4_s.json" "0020_d_4_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 67: 0020_d_5_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0067_0020_d_5_s.out"
run_job 67 "./models/adult/0020_d_5_s.json" "0020_d_5_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 68: 0020_d_5_s.json feature 1
wait_for_slot

OUTPUT_FILE="outputs/0068_0020_d_5_s.out"
run_job 68 "./models/adult/0020_d_5_s.json" "0020_d_5_s.json" 1 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 69: 0020_d_5_s.json feature 2
wait_for_slot

OUTPUT_FILE="outputs/0069_0020_d_5_s.out"
run_job 69 "./models/adult/0020_d_5_s.json" "0020_d_5_s.json" 2 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 70: 0020_d_5_s.json feature 3
wait_for_slot

OUTPUT_FILE="outputs/0070_0020_d_5_s.out"
run_job 70 "./models/adult/0020_d_5_s.json" "0020_d_5_s.json" 3 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 71: 0020_d_5_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0071_0020_d_5_s.out"
run_job 71 "./models/adult/0020_d_5_s.json" "0020_d_5_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 72: 0020_d_5_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0072_0020_d_5_s.out"
run_job 72 "./models/adult/0020_d_5_s.json" "0020_d_5_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 73: 0020_d_5_s.json feature 6
wait_for_slot

OUTPUT_FILE="outputs/0073_0020_d_5_s.out"
run_job 73 "./models/adult/0020_d_5_s.json" "0020_d_5_s.json" 6 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 74: 0020_d_5_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0074_0020_d_5_s.out"
run_job 74 "./models/adult/0020_d_5_s.json" "0020_d_5_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 75: 0020_d_5_s.json feature 8
wait_for_slot

OUTPUT_FILE="outputs/0075_0020_d_5_s.out"
run_job 75 "./models/adult/0020_d_5_s.json" "0020_d_5_s.json" 8 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 76: 0020_d_5_s.json feature 9
wait_for_slot

OUTPUT_FILE="outputs/0076_0020_d_5_s.out"
run_job 76 "./models/adult/0020_d_5_s.json" "0020_d_5_s.json" 9 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 77: 0020_d_5_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0077_0020_d_5_s.out"
run_job 77 "./models/adult/0020_d_5_s.json" "0020_d_5_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 78: 0020_d_5_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0078_0020_d_5_s.out"
run_job 78 "./models/adult/0020_d_5_s.json" "0020_d_5_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 79: 0020_d_5_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0079_0020_d_5_s.out"
run_job 79 "./models/adult/0020_d_5_s.json" "0020_d_5_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 80: 0020_d_5_s.json feature 13
wait_for_slot

OUTPUT_FILE="outputs/0080_0020_d_5_s.out"
run_job 80 "./models/adult/0020_d_5_s.json" "0020_d_5_s.json" 13 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 81: 0020_d_6_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0081_0020_d_6_s.out"
run_job 81 "./models/adult/0020_d_6_s.json" "0020_d_6_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 82: 0020_d_6_s.json feature 1
wait_for_slot

OUTPUT_FILE="outputs/0082_0020_d_6_s.out"
run_job 82 "./models/adult/0020_d_6_s.json" "0020_d_6_s.json" 1 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 83: 0020_d_6_s.json feature 2
wait_for_slot

OUTPUT_FILE="outputs/0083_0020_d_6_s.out"
run_job 83 "./models/adult/0020_d_6_s.json" "0020_d_6_s.json" 2 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 84: 0020_d_6_s.json feature 3
wait_for_slot

OUTPUT_FILE="outputs/0084_0020_d_6_s.out"
run_job 84 "./models/adult/0020_d_6_s.json" "0020_d_6_s.json" 3 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 85: 0020_d_6_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0085_0020_d_6_s.out"
run_job 85 "./models/adult/0020_d_6_s.json" "0020_d_6_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 86: 0020_d_6_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0086_0020_d_6_s.out"
run_job 86 "./models/adult/0020_d_6_s.json" "0020_d_6_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 87: 0020_d_6_s.json feature 6
wait_for_slot

OUTPUT_FILE="outputs/0087_0020_d_6_s.out"
run_job 87 "./models/adult/0020_d_6_s.json" "0020_d_6_s.json" 6 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 88: 0020_d_6_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0088_0020_d_6_s.out"
run_job 88 "./models/adult/0020_d_6_s.json" "0020_d_6_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 89: 0020_d_6_s.json feature 8
wait_for_slot

OUTPUT_FILE="outputs/0089_0020_d_6_s.out"
run_job 89 "./models/adult/0020_d_6_s.json" "0020_d_6_s.json" 8 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 90: 0020_d_6_s.json feature 9
wait_for_slot

OUTPUT_FILE="outputs/0090_0020_d_6_s.out"
run_job 90 "./models/adult/0020_d_6_s.json" "0020_d_6_s.json" 9 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 91: 0020_d_6_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0091_0020_d_6_s.out"
run_job 91 "./models/adult/0020_d_6_s.json" "0020_d_6_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 92: 0020_d_6_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0092_0020_d_6_s.out"
run_job 92 "./models/adult/0020_d_6_s.json" "0020_d_6_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 93: 0020_d_6_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0093_0020_d_6_s.out"
run_job 93 "./models/adult/0020_d_6_s.json" "0020_d_6_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 94: 0020_d_6_s.json feature 13
wait_for_slot

OUTPUT_FILE="outputs/0094_0020_d_6_s.out"
run_job 94 "./models/adult/0020_d_6_s.json" "0020_d_6_s.json" 13 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 95: 0030_d_2_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0095_0030_d_2_s.out"
run_job 95 "./models/adult/0030_d_2_s.json" "0030_d_2_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 96: 0030_d_2_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0096_0030_d_2_s.out"
run_job 96 "./models/adult/0030_d_2_s.json" "0030_d_2_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 97: 0030_d_2_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0097_0030_d_2_s.out"
run_job 97 "./models/adult/0030_d_2_s.json" "0030_d_2_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 98: 0030_d_2_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0098_0030_d_2_s.out"
run_job 98 "./models/adult/0030_d_2_s.json" "0030_d_2_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 99: 0030_d_2_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0099_0030_d_2_s.out"
run_job 99 "./models/adult/0030_d_2_s.json" "0030_d_2_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 100: 0030_d_2_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0100_0030_d_2_s.out"
run_job 100 "./models/adult/0030_d_2_s.json" "0030_d_2_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 101: 0030_d_2_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0101_0030_d_2_s.out"
run_job 101 "./models/adult/0030_d_2_s.json" "0030_d_2_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 102: 0030_d_3_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0102_0030_d_3_s.out"
run_job 102 "./models/adult/0030_d_3_s.json" "0030_d_3_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 103: 0030_d_3_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0103_0030_d_3_s.out"
run_job 103 "./models/adult/0030_d_3_s.json" "0030_d_3_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 104: 0030_d_3_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0104_0030_d_3_s.out"
run_job 104 "./models/adult/0030_d_3_s.json" "0030_d_3_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 105: 0030_d_3_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0105_0030_d_3_s.out"
run_job 105 "./models/adult/0030_d_3_s.json" "0030_d_3_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 106: 0030_d_3_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0106_0030_d_3_s.out"
run_job 106 "./models/adult/0030_d_3_s.json" "0030_d_3_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 107: 0030_d_3_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0107_0030_d_3_s.out"
run_job 107 "./models/adult/0030_d_3_s.json" "0030_d_3_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 108: 0030_d_3_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0108_0030_d_3_s.out"
run_job 108 "./models/adult/0030_d_3_s.json" "0030_d_3_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 109: 0030_d_4_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0109_0030_d_4_s.out"
run_job 109 "./models/adult/0030_d_4_s.json" "0030_d_4_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 110: 0030_d_4_s.json feature 1
wait_for_slot

OUTPUT_FILE="outputs/0110_0030_d_4_s.out"
run_job 110 "./models/adult/0030_d_4_s.json" "0030_d_4_s.json" 1 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 111: 0030_d_4_s.json feature 2
wait_for_slot

OUTPUT_FILE="outputs/0111_0030_d_4_s.out"
run_job 111 "./models/adult/0030_d_4_s.json" "0030_d_4_s.json" 2 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 112: 0030_d_4_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0112_0030_d_4_s.out"
run_job 112 "./models/adult/0030_d_4_s.json" "0030_d_4_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 113: 0030_d_4_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0113_0030_d_4_s.out"
run_job 113 "./models/adult/0030_d_4_s.json" "0030_d_4_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 114: 0030_d_4_s.json feature 6
wait_for_slot

OUTPUT_FILE="outputs/0114_0030_d_4_s.out"
run_job 114 "./models/adult/0030_d_4_s.json" "0030_d_4_s.json" 6 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 115: 0030_d_4_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0115_0030_d_4_s.out"
run_job 115 "./models/adult/0030_d_4_s.json" "0030_d_4_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 116: 0030_d_4_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0116_0030_d_4_s.out"
run_job 116 "./models/adult/0030_d_4_s.json" "0030_d_4_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 117: 0030_d_4_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0117_0030_d_4_s.out"
run_job 117 "./models/adult/0030_d_4_s.json" "0030_d_4_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 118: 0030_d_4_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0118_0030_d_4_s.out"
run_job 118 "./models/adult/0030_d_4_s.json" "0030_d_4_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 119: 0030_d_4_s.json feature 13
wait_for_slot

OUTPUT_FILE="outputs/0119_0030_d_4_s.out"
run_job 119 "./models/adult/0030_d_4_s.json" "0030_d_4_s.json" 13 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 120: 0030_d_5_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0120_0030_d_5_s.out"
run_job 120 "./models/adult/0030_d_5_s.json" "0030_d_5_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 121: 0030_d_5_s.json feature 1
wait_for_slot

OUTPUT_FILE="outputs/0121_0030_d_5_s.out"
run_job 121 "./models/adult/0030_d_5_s.json" "0030_d_5_s.json" 1 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 122: 0030_d_5_s.json feature 2
wait_for_slot

OUTPUT_FILE="outputs/0122_0030_d_5_s.out"
run_job 122 "./models/adult/0030_d_5_s.json" "0030_d_5_s.json" 2 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 123: 0030_d_5_s.json feature 3
wait_for_slot

OUTPUT_FILE="outputs/0123_0030_d_5_s.out"
run_job 123 "./models/adult/0030_d_5_s.json" "0030_d_5_s.json" 3 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 124: 0030_d_5_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0124_0030_d_5_s.out"
run_job 124 "./models/adult/0030_d_5_s.json" "0030_d_5_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 125: 0030_d_5_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0125_0030_d_5_s.out"
run_job 125 "./models/adult/0030_d_5_s.json" "0030_d_5_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 126: 0030_d_5_s.json feature 6
wait_for_slot

OUTPUT_FILE="outputs/0126_0030_d_5_s.out"
run_job 126 "./models/adult/0030_d_5_s.json" "0030_d_5_s.json" 6 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 127: 0030_d_5_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0127_0030_d_5_s.out"
run_job 127 "./models/adult/0030_d_5_s.json" "0030_d_5_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 128: 0030_d_5_s.json feature 8
wait_for_slot

OUTPUT_FILE="outputs/0128_0030_d_5_s.out"
run_job 128 "./models/adult/0030_d_5_s.json" "0030_d_5_s.json" 8 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 129: 0030_d_5_s.json feature 9
wait_for_slot

OUTPUT_FILE="outputs/0129_0030_d_5_s.out"
run_job 129 "./models/adult/0030_d_5_s.json" "0030_d_5_s.json" 9 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 130: 0030_d_5_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0130_0030_d_5_s.out"
run_job 130 "./models/adult/0030_d_5_s.json" "0030_d_5_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 131: 0030_d_5_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0131_0030_d_5_s.out"
run_job 131 "./models/adult/0030_d_5_s.json" "0030_d_5_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 132: 0030_d_5_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0132_0030_d_5_s.out"
run_job 132 "./models/adult/0030_d_5_s.json" "0030_d_5_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 133: 0030_d_5_s.json feature 13
wait_for_slot

OUTPUT_FILE="outputs/0133_0030_d_5_s.out"
run_job 133 "./models/adult/0030_d_5_s.json" "0030_d_5_s.json" 13 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 134: 0030_d_6_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0134_0030_d_6_s.out"
run_job 134 "./models/adult/0030_d_6_s.json" "0030_d_6_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 135: 0030_d_6_s.json feature 1
wait_for_slot

OUTPUT_FILE="outputs/0135_0030_d_6_s.out"
run_job 135 "./models/adult/0030_d_6_s.json" "0030_d_6_s.json" 1 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 136: 0030_d_6_s.json feature 2
wait_for_slot

OUTPUT_FILE="outputs/0136_0030_d_6_s.out"
run_job 136 "./models/adult/0030_d_6_s.json" "0030_d_6_s.json" 2 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 137: 0030_d_6_s.json feature 3
wait_for_slot

OUTPUT_FILE="outputs/0137_0030_d_6_s.out"
run_job 137 "./models/adult/0030_d_6_s.json" "0030_d_6_s.json" 3 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 138: 0030_d_6_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0138_0030_d_6_s.out"
run_job 138 "./models/adult/0030_d_6_s.json" "0030_d_6_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 139: 0030_d_6_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0139_0030_d_6_s.out"
run_job 139 "./models/adult/0030_d_6_s.json" "0030_d_6_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 140: 0030_d_6_s.json feature 6
wait_for_slot

OUTPUT_FILE="outputs/0140_0030_d_6_s.out"
run_job 140 "./models/adult/0030_d_6_s.json" "0030_d_6_s.json" 6 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 141: 0030_d_6_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0141_0030_d_6_s.out"
run_job 141 "./models/adult/0030_d_6_s.json" "0030_d_6_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 142: 0030_d_6_s.json feature 8
wait_for_slot

OUTPUT_FILE="outputs/0142_0030_d_6_s.out"
run_job 142 "./models/adult/0030_d_6_s.json" "0030_d_6_s.json" 8 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 143: 0030_d_6_s.json feature 9
wait_for_slot

OUTPUT_FILE="outputs/0143_0030_d_6_s.out"
run_job 143 "./models/adult/0030_d_6_s.json" "0030_d_6_s.json" 9 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 144: 0030_d_6_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0144_0030_d_6_s.out"
run_job 144 "./models/adult/0030_d_6_s.json" "0030_d_6_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 145: 0030_d_6_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0145_0030_d_6_s.out"
run_job 145 "./models/adult/0030_d_6_s.json" "0030_d_6_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 146: 0030_d_6_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0146_0030_d_6_s.out"
run_job 146 "./models/adult/0030_d_6_s.json" "0030_d_6_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 147: 0030_d_6_s.json feature 13
wait_for_slot

OUTPUT_FILE="outputs/0147_0030_d_6_s.out"
run_job 147 "./models/adult/0030_d_6_s.json" "0030_d_6_s.json" 13 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 148: 0040_d_2_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0148_0040_d_2_s.out"
run_job 148 "./models/adult/0040_d_2_s.json" "0040_d_2_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 149: 0040_d_2_s.json feature 3
wait_for_slot

OUTPUT_FILE="outputs/0149_0040_d_2_s.out"
run_job 149 "./models/adult/0040_d_2_s.json" "0040_d_2_s.json" 3 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 150: 0040_d_2_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0150_0040_d_2_s.out"
run_job 150 "./models/adult/0040_d_2_s.json" "0040_d_2_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 151: 0040_d_2_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0151_0040_d_2_s.out"
run_job 151 "./models/adult/0040_d_2_s.json" "0040_d_2_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 152: 0040_d_2_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0152_0040_d_2_s.out"
run_job 152 "./models/adult/0040_d_2_s.json" "0040_d_2_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 153: 0040_d_2_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0153_0040_d_2_s.out"
run_job 153 "./models/adult/0040_d_2_s.json" "0040_d_2_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 154: 0040_d_2_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0154_0040_d_2_s.out"
run_job 154 "./models/adult/0040_d_2_s.json" "0040_d_2_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 155: 0040_d_2_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0155_0040_d_2_s.out"
run_job 155 "./models/adult/0040_d_2_s.json" "0040_d_2_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 156: 0040_d_3_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0156_0040_d_3_s.out"
run_job 156 "./models/adult/0040_d_3_s.json" "0040_d_3_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 157: 0040_d_3_s.json feature 1
wait_for_slot

OUTPUT_FILE="outputs/0157_0040_d_3_s.out"
run_job 157 "./models/adult/0040_d_3_s.json" "0040_d_3_s.json" 1 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 158: 0040_d_3_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0158_0040_d_3_s.out"
run_job 158 "./models/adult/0040_d_3_s.json" "0040_d_3_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 159: 0040_d_3_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0159_0040_d_3_s.out"
run_job 159 "./models/adult/0040_d_3_s.json" "0040_d_3_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 160: 0040_d_3_s.json feature 6
wait_for_slot

OUTPUT_FILE="outputs/0160_0040_d_3_s.out"
run_job 160 "./models/adult/0040_d_3_s.json" "0040_d_3_s.json" 6 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 161: 0040_d_3_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0161_0040_d_3_s.out"
run_job 161 "./models/adult/0040_d_3_s.json" "0040_d_3_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 162: 0040_d_3_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0162_0040_d_3_s.out"
run_job 162 "./models/adult/0040_d_3_s.json" "0040_d_3_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 163: 0040_d_3_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0163_0040_d_3_s.out"
run_job 163 "./models/adult/0040_d_3_s.json" "0040_d_3_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 164: 0040_d_3_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0164_0040_d_3_s.out"
run_job 164 "./models/adult/0040_d_3_s.json" "0040_d_3_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 165: 0040_d_4_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0165_0040_d_4_s.out"
run_job 165 "./models/adult/0040_d_4_s.json" "0040_d_4_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 166: 0040_d_4_s.json feature 1
wait_for_slot

OUTPUT_FILE="outputs/0166_0040_d_4_s.out"
run_job 166 "./models/adult/0040_d_4_s.json" "0040_d_4_s.json" 1 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 167: 0040_d_4_s.json feature 2
wait_for_slot

OUTPUT_FILE="outputs/0167_0040_d_4_s.out"
run_job 167 "./models/adult/0040_d_4_s.json" "0040_d_4_s.json" 2 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 168: 0040_d_4_s.json feature 3
wait_for_slot

OUTPUT_FILE="outputs/0168_0040_d_4_s.out"
run_job 168 "./models/adult/0040_d_4_s.json" "0040_d_4_s.json" 3 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 169: 0040_d_4_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0169_0040_d_4_s.out"
run_job 169 "./models/adult/0040_d_4_s.json" "0040_d_4_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 170: 0040_d_4_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0170_0040_d_4_s.out"
run_job 170 "./models/adult/0040_d_4_s.json" "0040_d_4_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 171: 0040_d_4_s.json feature 6
wait_for_slot

OUTPUT_FILE="outputs/0171_0040_d_4_s.out"
run_job 171 "./models/adult/0040_d_4_s.json" "0040_d_4_s.json" 6 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 172: 0040_d_4_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0172_0040_d_4_s.out"
run_job 172 "./models/adult/0040_d_4_s.json" "0040_d_4_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 173: 0040_d_4_s.json feature 9
wait_for_slot

OUTPUT_FILE="outputs/0173_0040_d_4_s.out"
run_job 173 "./models/adult/0040_d_4_s.json" "0040_d_4_s.json" 9 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 174: 0040_d_4_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0174_0040_d_4_s.out"
run_job 174 "./models/adult/0040_d_4_s.json" "0040_d_4_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 175: 0040_d_4_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0175_0040_d_4_s.out"
run_job 175 "./models/adult/0040_d_4_s.json" "0040_d_4_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 176: 0040_d_4_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0176_0040_d_4_s.out"
run_job 176 "./models/adult/0040_d_4_s.json" "0040_d_4_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 177: 0040_d_4_s.json feature 13
wait_for_slot

OUTPUT_FILE="outputs/0177_0040_d_4_s.out"
run_job 177 "./models/adult/0040_d_4_s.json" "0040_d_4_s.json" 13 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 178: 0040_d_5_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0178_0040_d_5_s.out"
run_job 178 "./models/adult/0040_d_5_s.json" "0040_d_5_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 179: 0040_d_5_s.json feature 1
wait_for_slot

OUTPUT_FILE="outputs/0179_0040_d_5_s.out"
run_job 179 "./models/adult/0040_d_5_s.json" "0040_d_5_s.json" 1 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 180: 0040_d_5_s.json feature 2
wait_for_slot

OUTPUT_FILE="outputs/0180_0040_d_5_s.out"
run_job 180 "./models/adult/0040_d_5_s.json" "0040_d_5_s.json" 2 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 181: 0040_d_5_s.json feature 3
wait_for_slot

OUTPUT_FILE="outputs/0181_0040_d_5_s.out"
run_job 181 "./models/adult/0040_d_5_s.json" "0040_d_5_s.json" 3 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 182: 0040_d_5_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0182_0040_d_5_s.out"
run_job 182 "./models/adult/0040_d_5_s.json" "0040_d_5_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 183: 0040_d_5_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0183_0040_d_5_s.out"
run_job 183 "./models/adult/0040_d_5_s.json" "0040_d_5_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 184: 0040_d_5_s.json feature 6
wait_for_slot

OUTPUT_FILE="outputs/0184_0040_d_5_s.out"
run_job 184 "./models/adult/0040_d_5_s.json" "0040_d_5_s.json" 6 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 185: 0040_d_5_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0185_0040_d_5_s.out"
run_job 185 "./models/adult/0040_d_5_s.json" "0040_d_5_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 186: 0040_d_5_s.json feature 8
wait_for_slot

OUTPUT_FILE="outputs/0186_0040_d_5_s.out"
run_job 186 "./models/adult/0040_d_5_s.json" "0040_d_5_s.json" 8 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 187: 0040_d_5_s.json feature 9
wait_for_slot

OUTPUT_FILE="outputs/0187_0040_d_5_s.out"
run_job 187 "./models/adult/0040_d_5_s.json" "0040_d_5_s.json" 9 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 188: 0040_d_5_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0188_0040_d_5_s.out"
run_job 188 "./models/adult/0040_d_5_s.json" "0040_d_5_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 189: 0040_d_5_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0189_0040_d_5_s.out"
run_job 189 "./models/adult/0040_d_5_s.json" "0040_d_5_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 190: 0040_d_5_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0190_0040_d_5_s.out"
run_job 190 "./models/adult/0040_d_5_s.json" "0040_d_5_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 191: 0040_d_5_s.json feature 13
wait_for_slot

OUTPUT_FILE="outputs/0191_0040_d_5_s.out"
run_job 191 "./models/adult/0040_d_5_s.json" "0040_d_5_s.json" 13 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 192: 0040_d_6_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0192_0040_d_6_s.out"
run_job 192 "./models/adult/0040_d_6_s.json" "0040_d_6_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 193: 0040_d_6_s.json feature 1
wait_for_slot

OUTPUT_FILE="outputs/0193_0040_d_6_s.out"
run_job 193 "./models/adult/0040_d_6_s.json" "0040_d_6_s.json" 1 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 194: 0040_d_6_s.json feature 2
wait_for_slot

OUTPUT_FILE="outputs/0194_0040_d_6_s.out"
run_job 194 "./models/adult/0040_d_6_s.json" "0040_d_6_s.json" 2 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 195: 0040_d_6_s.json feature 3
wait_for_slot

OUTPUT_FILE="outputs/0195_0040_d_6_s.out"
run_job 195 "./models/adult/0040_d_6_s.json" "0040_d_6_s.json" 3 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 196: 0040_d_6_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0196_0040_d_6_s.out"
run_job 196 "./models/adult/0040_d_6_s.json" "0040_d_6_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 197: 0040_d_6_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0197_0040_d_6_s.out"
run_job 197 "./models/adult/0040_d_6_s.json" "0040_d_6_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 198: 0040_d_6_s.json feature 6
wait_for_slot

OUTPUT_FILE="outputs/0198_0040_d_6_s.out"
run_job 198 "./models/adult/0040_d_6_s.json" "0040_d_6_s.json" 6 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 199: 0040_d_6_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0199_0040_d_6_s.out"
run_job 199 "./models/adult/0040_d_6_s.json" "0040_d_6_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 200: 0040_d_6_s.json feature 8
wait_for_slot

OUTPUT_FILE="outputs/0200_0040_d_6_s.out"
run_job 200 "./models/adult/0040_d_6_s.json" "0040_d_6_s.json" 8 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 201: 0040_d_6_s.json feature 9
wait_for_slot

OUTPUT_FILE="outputs/0201_0040_d_6_s.out"
run_job 201 "./models/adult/0040_d_6_s.json" "0040_d_6_s.json" 9 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 202: 0040_d_6_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0202_0040_d_6_s.out"
run_job 202 "./models/adult/0040_d_6_s.json" "0040_d_6_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 203: 0040_d_6_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0203_0040_d_6_s.out"
run_job 203 "./models/adult/0040_d_6_s.json" "0040_d_6_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 204: 0040_d_6_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0204_0040_d_6_s.out"
run_job 204 "./models/adult/0040_d_6_s.json" "0040_d_6_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 205: 0040_d_6_s.json feature 13
wait_for_slot

OUTPUT_FILE="outputs/0205_0040_d_6_s.out"
run_job 205 "./models/adult/0040_d_6_s.json" "0040_d_6_s.json" 13 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 206: 0050_d_2_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0206_0050_d_2_s.out"
run_job 206 "./models/adult/0050_d_2_s.json" "0050_d_2_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 207: 0050_d_2_s.json feature 1
wait_for_slot

OUTPUT_FILE="outputs/0207_0050_d_2_s.out"
run_job 207 "./models/adult/0050_d_2_s.json" "0050_d_2_s.json" 1 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 208: 0050_d_2_s.json feature 3
wait_for_slot

OUTPUT_FILE="outputs/0208_0050_d_2_s.out"
run_job 208 "./models/adult/0050_d_2_s.json" "0050_d_2_s.json" 3 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 209: 0050_d_2_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0209_0050_d_2_s.out"
run_job 209 "./models/adult/0050_d_2_s.json" "0050_d_2_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 210: 0050_d_2_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0210_0050_d_2_s.out"
run_job 210 "./models/adult/0050_d_2_s.json" "0050_d_2_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 211: 0050_d_2_s.json feature 6
wait_for_slot

OUTPUT_FILE="outputs/0211_0050_d_2_s.out"
run_job 211 "./models/adult/0050_d_2_s.json" "0050_d_2_s.json" 6 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 212: 0050_d_2_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0212_0050_d_2_s.out"
run_job 212 "./models/adult/0050_d_2_s.json" "0050_d_2_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 213: 0050_d_2_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0213_0050_d_2_s.out"
run_job 213 "./models/adult/0050_d_2_s.json" "0050_d_2_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 214: 0050_d_2_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0214_0050_d_2_s.out"
run_job 214 "./models/adult/0050_d_2_s.json" "0050_d_2_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 215: 0050_d_2_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0215_0050_d_2_s.out"
run_job 215 "./models/adult/0050_d_2_s.json" "0050_d_2_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 216: 0050_d_3_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0216_0050_d_3_s.out"
run_job 216 "./models/adult/0050_d_3_s.json" "0050_d_3_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 217: 0050_d_3_s.json feature 1
wait_for_slot

OUTPUT_FILE="outputs/0217_0050_d_3_s.out"
run_job 217 "./models/adult/0050_d_3_s.json" "0050_d_3_s.json" 1 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 218: 0050_d_3_s.json feature 2
wait_for_slot

OUTPUT_FILE="outputs/0218_0050_d_3_s.out"
run_job 218 "./models/adult/0050_d_3_s.json" "0050_d_3_s.json" 2 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 219: 0050_d_3_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0219_0050_d_3_s.out"
run_job 219 "./models/adult/0050_d_3_s.json" "0050_d_3_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 220: 0050_d_3_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0220_0050_d_3_s.out"
run_job 220 "./models/adult/0050_d_3_s.json" "0050_d_3_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 221: 0050_d_3_s.json feature 6
wait_for_slot

OUTPUT_FILE="outputs/0221_0050_d_3_s.out"
run_job 221 "./models/adult/0050_d_3_s.json" "0050_d_3_s.json" 6 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 222: 0050_d_3_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0222_0050_d_3_s.out"
run_job 222 "./models/adult/0050_d_3_s.json" "0050_d_3_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 223: 0050_d_3_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0223_0050_d_3_s.out"
run_job 223 "./models/adult/0050_d_3_s.json" "0050_d_3_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 224: 0050_d_3_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0224_0050_d_3_s.out"
run_job 224 "./models/adult/0050_d_3_s.json" "0050_d_3_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 225: 0050_d_3_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0225_0050_d_3_s.out"
run_job 225 "./models/adult/0050_d_3_s.json" "0050_d_3_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 226: 0050_d_4_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0226_0050_d_4_s.out"
run_job 226 "./models/adult/0050_d_4_s.json" "0050_d_4_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 227: 0050_d_4_s.json feature 1
wait_for_slot

OUTPUT_FILE="outputs/0227_0050_d_4_s.out"
run_job 227 "./models/adult/0050_d_4_s.json" "0050_d_4_s.json" 1 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 228: 0050_d_4_s.json feature 2
wait_for_slot

OUTPUT_FILE="outputs/0228_0050_d_4_s.out"
run_job 228 "./models/adult/0050_d_4_s.json" "0050_d_4_s.json" 2 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 229: 0050_d_4_s.json feature 3
wait_for_slot

OUTPUT_FILE="outputs/0229_0050_d_4_s.out"
run_job 229 "./models/adult/0050_d_4_s.json" "0050_d_4_s.json" 3 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 230: 0050_d_4_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0230_0050_d_4_s.out"
run_job 230 "./models/adult/0050_d_4_s.json" "0050_d_4_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 231: 0050_d_4_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0231_0050_d_4_s.out"
run_job 231 "./models/adult/0050_d_4_s.json" "0050_d_4_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 232: 0050_d_4_s.json feature 6
wait_for_slot

OUTPUT_FILE="outputs/0232_0050_d_4_s.out"
run_job 232 "./models/adult/0050_d_4_s.json" "0050_d_4_s.json" 6 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 233: 0050_d_4_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0233_0050_d_4_s.out"
run_job 233 "./models/adult/0050_d_4_s.json" "0050_d_4_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 234: 0050_d_4_s.json feature 8
wait_for_slot

OUTPUT_FILE="outputs/0234_0050_d_4_s.out"
run_job 234 "./models/adult/0050_d_4_s.json" "0050_d_4_s.json" 8 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 235: 0050_d_4_s.json feature 9
wait_for_slot

OUTPUT_FILE="outputs/0235_0050_d_4_s.out"
run_job 235 "./models/adult/0050_d_4_s.json" "0050_d_4_s.json" 9 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 236: 0050_d_4_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0236_0050_d_4_s.out"
run_job 236 "./models/adult/0050_d_4_s.json" "0050_d_4_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 237: 0050_d_4_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0237_0050_d_4_s.out"
run_job 237 "./models/adult/0050_d_4_s.json" "0050_d_4_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 238: 0050_d_4_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0238_0050_d_4_s.out"
run_job 238 "./models/adult/0050_d_4_s.json" "0050_d_4_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 239: 0050_d_4_s.json feature 13
wait_for_slot

OUTPUT_FILE="outputs/0239_0050_d_4_s.out"
run_job 239 "./models/adult/0050_d_4_s.json" "0050_d_4_s.json" 13 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 240: 0050_d_5_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0240_0050_d_5_s.out"
run_job 240 "./models/adult/0050_d_5_s.json" "0050_d_5_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 241: 0050_d_5_s.json feature 1
wait_for_slot

OUTPUT_FILE="outputs/0241_0050_d_5_s.out"
run_job 241 "./models/adult/0050_d_5_s.json" "0050_d_5_s.json" 1 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 242: 0050_d_5_s.json feature 2
wait_for_slot

OUTPUT_FILE="outputs/0242_0050_d_5_s.out"
run_job 242 "./models/adult/0050_d_5_s.json" "0050_d_5_s.json" 2 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 243: 0050_d_5_s.json feature 3
wait_for_slot

OUTPUT_FILE="outputs/0243_0050_d_5_s.out"
run_job 243 "./models/adult/0050_d_5_s.json" "0050_d_5_s.json" 3 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 244: 0050_d_5_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0244_0050_d_5_s.out"
run_job 244 "./models/adult/0050_d_5_s.json" "0050_d_5_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 245: 0050_d_5_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0245_0050_d_5_s.out"
run_job 245 "./models/adult/0050_d_5_s.json" "0050_d_5_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 246: 0050_d_5_s.json feature 6
wait_for_slot

OUTPUT_FILE="outputs/0246_0050_d_5_s.out"
run_job 246 "./models/adult/0050_d_5_s.json" "0050_d_5_s.json" 6 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 247: 0050_d_5_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0247_0050_d_5_s.out"
run_job 247 "./models/adult/0050_d_5_s.json" "0050_d_5_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 248: 0050_d_5_s.json feature 8
wait_for_slot

OUTPUT_FILE="outputs/0248_0050_d_5_s.out"
run_job 248 "./models/adult/0050_d_5_s.json" "0050_d_5_s.json" 8 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 249: 0050_d_5_s.json feature 9
wait_for_slot

OUTPUT_FILE="outputs/0249_0050_d_5_s.out"
run_job 249 "./models/adult/0050_d_5_s.json" "0050_d_5_s.json" 9 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 250: 0050_d_5_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0250_0050_d_5_s.out"
run_job 250 "./models/adult/0050_d_5_s.json" "0050_d_5_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 251: 0050_d_5_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0251_0050_d_5_s.out"
run_job 251 "./models/adult/0050_d_5_s.json" "0050_d_5_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 252: 0050_d_5_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0252_0050_d_5_s.out"
run_job 252 "./models/adult/0050_d_5_s.json" "0050_d_5_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 253: 0050_d_5_s.json feature 13
wait_for_slot

OUTPUT_FILE="outputs/0253_0050_d_5_s.out"
run_job 253 "./models/adult/0050_d_5_s.json" "0050_d_5_s.json" 13 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 254: 0050_d_6_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0254_0050_d_6_s.out"
run_job 254 "./models/adult/0050_d_6_s.json" "0050_d_6_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 255: 0050_d_6_s.json feature 1
wait_for_slot

OUTPUT_FILE="outputs/0255_0050_d_6_s.out"
run_job 255 "./models/adult/0050_d_6_s.json" "0050_d_6_s.json" 1 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 256: 0050_d_6_s.json feature 2
wait_for_slot

OUTPUT_FILE="outputs/0256_0050_d_6_s.out"
run_job 256 "./models/adult/0050_d_6_s.json" "0050_d_6_s.json" 2 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 257: 0050_d_6_s.json feature 3
wait_for_slot

OUTPUT_FILE="outputs/0257_0050_d_6_s.out"
run_job 257 "./models/adult/0050_d_6_s.json" "0050_d_6_s.json" 3 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 258: 0050_d_6_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0258_0050_d_6_s.out"
run_job 258 "./models/adult/0050_d_6_s.json" "0050_d_6_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 259: 0050_d_6_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0259_0050_d_6_s.out"
run_job 259 "./models/adult/0050_d_6_s.json" "0050_d_6_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 260: 0050_d_6_s.json feature 6
wait_for_slot

OUTPUT_FILE="outputs/0260_0050_d_6_s.out"
run_job 260 "./models/adult/0050_d_6_s.json" "0050_d_6_s.json" 6 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 261: 0050_d_6_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0261_0050_d_6_s.out"
run_job 261 "./models/adult/0050_d_6_s.json" "0050_d_6_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 262: 0050_d_6_s.json feature 8
wait_for_slot

OUTPUT_FILE="outputs/0262_0050_d_6_s.out"
run_job 262 "./models/adult/0050_d_6_s.json" "0050_d_6_s.json" 8 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 263: 0050_d_6_s.json feature 9
wait_for_slot

OUTPUT_FILE="outputs/0263_0050_d_6_s.out"
run_job 263 "./models/adult/0050_d_6_s.json" "0050_d_6_s.json" 9 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 264: 0050_d_6_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0264_0050_d_6_s.out"
run_job 264 "./models/adult/0050_d_6_s.json" "0050_d_6_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 265: 0050_d_6_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0265_0050_d_6_s.out"
run_job 265 "./models/adult/0050_d_6_s.json" "0050_d_6_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 266: 0050_d_6_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0266_0050_d_6_s.out"
run_job 266 "./models/adult/0050_d_6_s.json" "0050_d_6_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 267: 0050_d_6_s.json feature 13
wait_for_slot

OUTPUT_FILE="outputs/0267_0050_d_6_s.out"
run_job 267 "./models/adult/0050_d_6_s.json" "0050_d_6_s.json" 13 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 268: 0060_d_2_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0268_0060_d_2_s.out"
run_job 268 "./models/adult/0060_d_2_s.json" "0060_d_2_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 269: 0060_d_2_s.json feature 1
wait_for_slot

OUTPUT_FILE="outputs/0269_0060_d_2_s.out"
run_job 269 "./models/adult/0060_d_2_s.json" "0060_d_2_s.json" 1 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 270: 0060_d_2_s.json feature 3
wait_for_slot

OUTPUT_FILE="outputs/0270_0060_d_2_s.out"
run_job 270 "./models/adult/0060_d_2_s.json" "0060_d_2_s.json" 3 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 271: 0060_d_2_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0271_0060_d_2_s.out"
run_job 271 "./models/adult/0060_d_2_s.json" "0060_d_2_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 272: 0060_d_2_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0272_0060_d_2_s.out"
run_job 272 "./models/adult/0060_d_2_s.json" "0060_d_2_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 273: 0060_d_2_s.json feature 6
wait_for_slot

OUTPUT_FILE="outputs/0273_0060_d_2_s.out"
run_job 273 "./models/adult/0060_d_2_s.json" "0060_d_2_s.json" 6 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 274: 0060_d_2_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0274_0060_d_2_s.out"
run_job 274 "./models/adult/0060_d_2_s.json" "0060_d_2_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 275: 0060_d_2_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0275_0060_d_2_s.out"
run_job 275 "./models/adult/0060_d_2_s.json" "0060_d_2_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 276: 0060_d_2_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0276_0060_d_2_s.out"
run_job 276 "./models/adult/0060_d_2_s.json" "0060_d_2_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 277: 0060_d_2_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0277_0060_d_2_s.out"
run_job 277 "./models/adult/0060_d_2_s.json" "0060_d_2_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 278: 0060_d_3_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0278_0060_d_3_s.out"
run_job 278 "./models/adult/0060_d_3_s.json" "0060_d_3_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 279: 0060_d_3_s.json feature 1
wait_for_slot

OUTPUT_FILE="outputs/0279_0060_d_3_s.out"
run_job 279 "./models/adult/0060_d_3_s.json" "0060_d_3_s.json" 1 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 280: 0060_d_3_s.json feature 2
wait_for_slot

OUTPUT_FILE="outputs/0280_0060_d_3_s.out"
run_job 280 "./models/adult/0060_d_3_s.json" "0060_d_3_s.json" 2 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 281: 0060_d_3_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0281_0060_d_3_s.out"
run_job 281 "./models/adult/0060_d_3_s.json" "0060_d_3_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 282: 0060_d_3_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0282_0060_d_3_s.out"
run_job 282 "./models/adult/0060_d_3_s.json" "0060_d_3_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 283: 0060_d_3_s.json feature 6
wait_for_slot

OUTPUT_FILE="outputs/0283_0060_d_3_s.out"
run_job 283 "./models/adult/0060_d_3_s.json" "0060_d_3_s.json" 6 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 284: 0060_d_3_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0284_0060_d_3_s.out"
run_job 284 "./models/adult/0060_d_3_s.json" "0060_d_3_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 285: 0060_d_3_s.json feature 9
wait_for_slot

OUTPUT_FILE="outputs/0285_0060_d_3_s.out"
run_job 285 "./models/adult/0060_d_3_s.json" "0060_d_3_s.json" 9 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 286: 0060_d_3_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0286_0060_d_3_s.out"
run_job 286 "./models/adult/0060_d_3_s.json" "0060_d_3_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 287: 0060_d_3_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0287_0060_d_3_s.out"
run_job 287 "./models/adult/0060_d_3_s.json" "0060_d_3_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 288: 0060_d_3_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0288_0060_d_3_s.out"
run_job 288 "./models/adult/0060_d_3_s.json" "0060_d_3_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 289: 0060_d_3_s.json feature 13
wait_for_slot

OUTPUT_FILE="outputs/0289_0060_d_3_s.out"
run_job 289 "./models/adult/0060_d_3_s.json" "0060_d_3_s.json" 13 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 290: 0060_d_4_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0290_0060_d_4_s.out"
run_job 290 "./models/adult/0060_d_4_s.json" "0060_d_4_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 291: 0060_d_4_s.json feature 1
wait_for_slot

OUTPUT_FILE="outputs/0291_0060_d_4_s.out"
run_job 291 "./models/adult/0060_d_4_s.json" "0060_d_4_s.json" 1 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 292: 0060_d_4_s.json feature 2
wait_for_slot

OUTPUT_FILE="outputs/0292_0060_d_4_s.out"
run_job 292 "./models/adult/0060_d_4_s.json" "0060_d_4_s.json" 2 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 293: 0060_d_4_s.json feature 3
wait_for_slot

OUTPUT_FILE="outputs/0293_0060_d_4_s.out"
run_job 293 "./models/adult/0060_d_4_s.json" "0060_d_4_s.json" 3 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 294: 0060_d_4_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0294_0060_d_4_s.out"
run_job 294 "./models/adult/0060_d_4_s.json" "0060_d_4_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 295: 0060_d_4_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0295_0060_d_4_s.out"
run_job 295 "./models/adult/0060_d_4_s.json" "0060_d_4_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 296: 0060_d_4_s.json feature 6
wait_for_slot

OUTPUT_FILE="outputs/0296_0060_d_4_s.out"
run_job 296 "./models/adult/0060_d_4_s.json" "0060_d_4_s.json" 6 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 297: 0060_d_4_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0297_0060_d_4_s.out"
run_job 297 "./models/adult/0060_d_4_s.json" "0060_d_4_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 298: 0060_d_4_s.json feature 8
wait_for_slot

OUTPUT_FILE="outputs/0298_0060_d_4_s.out"
run_job 298 "./models/adult/0060_d_4_s.json" "0060_d_4_s.json" 8 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 299: 0060_d_4_s.json feature 9
wait_for_slot

OUTPUT_FILE="outputs/0299_0060_d_4_s.out"
run_job 299 "./models/adult/0060_d_4_s.json" "0060_d_4_s.json" 9 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 300: 0060_d_4_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0300_0060_d_4_s.out"
run_job 300 "./models/adult/0060_d_4_s.json" "0060_d_4_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 301: 0060_d_4_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0301_0060_d_4_s.out"
run_job 301 "./models/adult/0060_d_4_s.json" "0060_d_4_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 302: 0060_d_4_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0302_0060_d_4_s.out"
run_job 302 "./models/adult/0060_d_4_s.json" "0060_d_4_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 303: 0060_d_4_s.json feature 13
wait_for_slot

OUTPUT_FILE="outputs/0303_0060_d_4_s.out"
run_job 303 "./models/adult/0060_d_4_s.json" "0060_d_4_s.json" 13 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 304: 0060_d_5_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0304_0060_d_5_s.out"
run_job 304 "./models/adult/0060_d_5_s.json" "0060_d_5_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 305: 0060_d_5_s.json feature 1
wait_for_slot

OUTPUT_FILE="outputs/0305_0060_d_5_s.out"
run_job 305 "./models/adult/0060_d_5_s.json" "0060_d_5_s.json" 1 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 306: 0060_d_5_s.json feature 2
wait_for_slot

OUTPUT_FILE="outputs/0306_0060_d_5_s.out"
run_job 306 "./models/adult/0060_d_5_s.json" "0060_d_5_s.json" 2 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 307: 0060_d_5_s.json feature 3
wait_for_slot

OUTPUT_FILE="outputs/0307_0060_d_5_s.out"
run_job 307 "./models/adult/0060_d_5_s.json" "0060_d_5_s.json" 3 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 308: 0060_d_5_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0308_0060_d_5_s.out"
run_job 308 "./models/adult/0060_d_5_s.json" "0060_d_5_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 309: 0060_d_5_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0309_0060_d_5_s.out"
run_job 309 "./models/adult/0060_d_5_s.json" "0060_d_5_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 310: 0060_d_5_s.json feature 6
wait_for_slot

OUTPUT_FILE="outputs/0310_0060_d_5_s.out"
run_job 310 "./models/adult/0060_d_5_s.json" "0060_d_5_s.json" 6 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 311: 0060_d_5_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0311_0060_d_5_s.out"
run_job 311 "./models/adult/0060_d_5_s.json" "0060_d_5_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 312: 0060_d_5_s.json feature 8
wait_for_slot

OUTPUT_FILE="outputs/0312_0060_d_5_s.out"
run_job 312 "./models/adult/0060_d_5_s.json" "0060_d_5_s.json" 8 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 313: 0060_d_5_s.json feature 9
wait_for_slot

OUTPUT_FILE="outputs/0313_0060_d_5_s.out"
run_job 313 "./models/adult/0060_d_5_s.json" "0060_d_5_s.json" 9 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 314: 0060_d_5_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0314_0060_d_5_s.out"
run_job 314 "./models/adult/0060_d_5_s.json" "0060_d_5_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 315: 0060_d_5_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0315_0060_d_5_s.out"
run_job 315 "./models/adult/0060_d_5_s.json" "0060_d_5_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 316: 0060_d_5_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0316_0060_d_5_s.out"
run_job 316 "./models/adult/0060_d_5_s.json" "0060_d_5_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 317: 0060_d_5_s.json feature 13
wait_for_slot

OUTPUT_FILE="outputs/0317_0060_d_5_s.out"
run_job 317 "./models/adult/0060_d_5_s.json" "0060_d_5_s.json" 13 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 318: 0060_d_6_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0318_0060_d_6_s.out"
run_job 318 "./models/adult/0060_d_6_s.json" "0060_d_6_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 319: 0060_d_6_s.json feature 1
wait_for_slot

OUTPUT_FILE="outputs/0319_0060_d_6_s.out"
run_job 319 "./models/adult/0060_d_6_s.json" "0060_d_6_s.json" 1 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 320: 0060_d_6_s.json feature 2
wait_for_slot

OUTPUT_FILE="outputs/0320_0060_d_6_s.out"
run_job 320 "./models/adult/0060_d_6_s.json" "0060_d_6_s.json" 2 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 321: 0060_d_6_s.json feature 3
wait_for_slot

OUTPUT_FILE="outputs/0321_0060_d_6_s.out"
run_job 321 "./models/adult/0060_d_6_s.json" "0060_d_6_s.json" 3 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 322: 0060_d_6_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0322_0060_d_6_s.out"
run_job 322 "./models/adult/0060_d_6_s.json" "0060_d_6_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 323: 0060_d_6_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0323_0060_d_6_s.out"
run_job 323 "./models/adult/0060_d_6_s.json" "0060_d_6_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 324: 0060_d_6_s.json feature 6
wait_for_slot

OUTPUT_FILE="outputs/0324_0060_d_6_s.out"
run_job 324 "./models/adult/0060_d_6_s.json" "0060_d_6_s.json" 6 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 325: 0060_d_6_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0325_0060_d_6_s.out"
run_job 325 "./models/adult/0060_d_6_s.json" "0060_d_6_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 326: 0060_d_6_s.json feature 8
wait_for_slot

OUTPUT_FILE="outputs/0326_0060_d_6_s.out"
run_job 326 "./models/adult/0060_d_6_s.json" "0060_d_6_s.json" 8 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 327: 0060_d_6_s.json feature 9
wait_for_slot

OUTPUT_FILE="outputs/0327_0060_d_6_s.out"
run_job 327 "./models/adult/0060_d_6_s.json" "0060_d_6_s.json" 9 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 328: 0060_d_6_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0328_0060_d_6_s.out"
run_job 328 "./models/adult/0060_d_6_s.json" "0060_d_6_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 329: 0060_d_6_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0329_0060_d_6_s.out"
run_job 329 "./models/adult/0060_d_6_s.json" "0060_d_6_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 330: 0060_d_6_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0330_0060_d_6_s.out"
run_job 330 "./models/adult/0060_d_6_s.json" "0060_d_6_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 331: 0060_d_6_s.json feature 13
wait_for_slot

OUTPUT_FILE="outputs/0331_0060_d_6_s.out"
run_job 331 "./models/adult/0060_d_6_s.json" "0060_d_6_s.json" 13 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 332: 0070_d_2_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0332_0070_d_2_s.out"
run_job 332 "./models/adult/0070_d_2_s.json" "0070_d_2_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 333: 0070_d_2_s.json feature 1
wait_for_slot

OUTPUT_FILE="outputs/0333_0070_d_2_s.out"
run_job 333 "./models/adult/0070_d_2_s.json" "0070_d_2_s.json" 1 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 334: 0070_d_2_s.json feature 3
wait_for_slot

OUTPUT_FILE="outputs/0334_0070_d_2_s.out"
run_job 334 "./models/adult/0070_d_2_s.json" "0070_d_2_s.json" 3 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 335: 0070_d_2_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0335_0070_d_2_s.out"
run_job 335 "./models/adult/0070_d_2_s.json" "0070_d_2_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 336: 0070_d_2_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0336_0070_d_2_s.out"
run_job 336 "./models/adult/0070_d_2_s.json" "0070_d_2_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 337: 0070_d_2_s.json feature 6
wait_for_slot

OUTPUT_FILE="outputs/0337_0070_d_2_s.out"
run_job 337 "./models/adult/0070_d_2_s.json" "0070_d_2_s.json" 6 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 338: 0070_d_2_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0338_0070_d_2_s.out"
run_job 338 "./models/adult/0070_d_2_s.json" "0070_d_2_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 339: 0070_d_2_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0339_0070_d_2_s.out"
run_job 339 "./models/adult/0070_d_2_s.json" "0070_d_2_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 340: 0070_d_2_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0340_0070_d_2_s.out"
run_job 340 "./models/adult/0070_d_2_s.json" "0070_d_2_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 341: 0070_d_2_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0341_0070_d_2_s.out"
run_job 341 "./models/adult/0070_d_2_s.json" "0070_d_2_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 342: 0070_d_3_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0342_0070_d_3_s.out"
run_job 342 "./models/adult/0070_d_3_s.json" "0070_d_3_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 343: 0070_d_3_s.json feature 1
wait_for_slot

OUTPUT_FILE="outputs/0343_0070_d_3_s.out"
run_job 343 "./models/adult/0070_d_3_s.json" "0070_d_3_s.json" 1 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 344: 0070_d_3_s.json feature 2
wait_for_slot

OUTPUT_FILE="outputs/0344_0070_d_3_s.out"
run_job 344 "./models/adult/0070_d_3_s.json" "0070_d_3_s.json" 2 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 345: 0070_d_3_s.json feature 3
wait_for_slot

OUTPUT_FILE="outputs/0345_0070_d_3_s.out"
run_job 345 "./models/adult/0070_d_3_s.json" "0070_d_3_s.json" 3 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 346: 0070_d_3_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0346_0070_d_3_s.out"
run_job 346 "./models/adult/0070_d_3_s.json" "0070_d_3_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 347: 0070_d_3_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0347_0070_d_3_s.out"
run_job 347 "./models/adult/0070_d_3_s.json" "0070_d_3_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 348: 0070_d_3_s.json feature 6
wait_for_slot

OUTPUT_FILE="outputs/0348_0070_d_3_s.out"
run_job 348 "./models/adult/0070_d_3_s.json" "0070_d_3_s.json" 6 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 349: 0070_d_3_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0349_0070_d_3_s.out"
run_job 349 "./models/adult/0070_d_3_s.json" "0070_d_3_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 350: 0070_d_3_s.json feature 8
wait_for_slot

OUTPUT_FILE="outputs/0350_0070_d_3_s.out"
run_job 350 "./models/adult/0070_d_3_s.json" "0070_d_3_s.json" 8 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 351: 0070_d_3_s.json feature 9
wait_for_slot

OUTPUT_FILE="outputs/0351_0070_d_3_s.out"
run_job 351 "./models/adult/0070_d_3_s.json" "0070_d_3_s.json" 9 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 352: 0070_d_3_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0352_0070_d_3_s.out"
run_job 352 "./models/adult/0070_d_3_s.json" "0070_d_3_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 353: 0070_d_3_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0353_0070_d_3_s.out"
run_job 353 "./models/adult/0070_d_3_s.json" "0070_d_3_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 354: 0070_d_3_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0354_0070_d_3_s.out"
run_job 354 "./models/adult/0070_d_3_s.json" "0070_d_3_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 355: 0070_d_3_s.json feature 13
wait_for_slot

OUTPUT_FILE="outputs/0355_0070_d_3_s.out"
run_job 355 "./models/adult/0070_d_3_s.json" "0070_d_3_s.json" 13 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 356: 0070_d_4_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0356_0070_d_4_s.out"
run_job 356 "./models/adult/0070_d_4_s.json" "0070_d_4_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 357: 0070_d_4_s.json feature 1
wait_for_slot

OUTPUT_FILE="outputs/0357_0070_d_4_s.out"
run_job 357 "./models/adult/0070_d_4_s.json" "0070_d_4_s.json" 1 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 358: 0070_d_4_s.json feature 2
wait_for_slot

OUTPUT_FILE="outputs/0358_0070_d_4_s.out"
run_job 358 "./models/adult/0070_d_4_s.json" "0070_d_4_s.json" 2 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 359: 0070_d_4_s.json feature 3
wait_for_slot

OUTPUT_FILE="outputs/0359_0070_d_4_s.out"
run_job 359 "./models/adult/0070_d_4_s.json" "0070_d_4_s.json" 3 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 360: 0070_d_4_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0360_0070_d_4_s.out"
run_job 360 "./models/adult/0070_d_4_s.json" "0070_d_4_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 361: 0070_d_4_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0361_0070_d_4_s.out"
run_job 361 "./models/adult/0070_d_4_s.json" "0070_d_4_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 362: 0070_d_4_s.json feature 6
wait_for_slot

OUTPUT_FILE="outputs/0362_0070_d_4_s.out"
run_job 362 "./models/adult/0070_d_4_s.json" "0070_d_4_s.json" 6 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 363: 0070_d_4_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0363_0070_d_4_s.out"
run_job 363 "./models/adult/0070_d_4_s.json" "0070_d_4_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 364: 0070_d_4_s.json feature 8
wait_for_slot

OUTPUT_FILE="outputs/0364_0070_d_4_s.out"
run_job 364 "./models/adult/0070_d_4_s.json" "0070_d_4_s.json" 8 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 365: 0070_d_4_s.json feature 9
wait_for_slot

OUTPUT_FILE="outputs/0365_0070_d_4_s.out"
run_job 365 "./models/adult/0070_d_4_s.json" "0070_d_4_s.json" 9 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 366: 0070_d_4_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0366_0070_d_4_s.out"
run_job 366 "./models/adult/0070_d_4_s.json" "0070_d_4_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 367: 0070_d_4_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0367_0070_d_4_s.out"
run_job 367 "./models/adult/0070_d_4_s.json" "0070_d_4_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 368: 0070_d_4_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0368_0070_d_4_s.out"
run_job 368 "./models/adult/0070_d_4_s.json" "0070_d_4_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 369: 0070_d_4_s.json feature 13
wait_for_slot

OUTPUT_FILE="outputs/0369_0070_d_4_s.out"
run_job 369 "./models/adult/0070_d_4_s.json" "0070_d_4_s.json" 13 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 370: 0070_d_5_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0370_0070_d_5_s.out"
run_job 370 "./models/adult/0070_d_5_s.json" "0070_d_5_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 371: 0070_d_5_s.json feature 1
wait_for_slot

OUTPUT_FILE="outputs/0371_0070_d_5_s.out"
run_job 371 "./models/adult/0070_d_5_s.json" "0070_d_5_s.json" 1 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 372: 0070_d_5_s.json feature 2
wait_for_slot

OUTPUT_FILE="outputs/0372_0070_d_5_s.out"
run_job 372 "./models/adult/0070_d_5_s.json" "0070_d_5_s.json" 2 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 373: 0070_d_5_s.json feature 3
wait_for_slot

OUTPUT_FILE="outputs/0373_0070_d_5_s.out"
run_job 373 "./models/adult/0070_d_5_s.json" "0070_d_5_s.json" 3 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 374: 0070_d_5_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0374_0070_d_5_s.out"
run_job 374 "./models/adult/0070_d_5_s.json" "0070_d_5_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 375: 0070_d_5_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0375_0070_d_5_s.out"
run_job 375 "./models/adult/0070_d_5_s.json" "0070_d_5_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 376: 0070_d_5_s.json feature 6
wait_for_slot

OUTPUT_FILE="outputs/0376_0070_d_5_s.out"
run_job 376 "./models/adult/0070_d_5_s.json" "0070_d_5_s.json" 6 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 377: 0070_d_5_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0377_0070_d_5_s.out"
run_job 377 "./models/adult/0070_d_5_s.json" "0070_d_5_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 378: 0070_d_5_s.json feature 8
wait_for_slot

OUTPUT_FILE="outputs/0378_0070_d_5_s.out"
run_job 378 "./models/adult/0070_d_5_s.json" "0070_d_5_s.json" 8 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 379: 0070_d_5_s.json feature 9
wait_for_slot

OUTPUT_FILE="outputs/0379_0070_d_5_s.out"
run_job 379 "./models/adult/0070_d_5_s.json" "0070_d_5_s.json" 9 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 380: 0070_d_5_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0380_0070_d_5_s.out"
run_job 380 "./models/adult/0070_d_5_s.json" "0070_d_5_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 381: 0070_d_5_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0381_0070_d_5_s.out"
run_job 381 "./models/adult/0070_d_5_s.json" "0070_d_5_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 382: 0070_d_5_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0382_0070_d_5_s.out"
run_job 382 "./models/adult/0070_d_5_s.json" "0070_d_5_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 383: 0070_d_5_s.json feature 13
wait_for_slot

OUTPUT_FILE="outputs/0383_0070_d_5_s.out"
run_job 383 "./models/adult/0070_d_5_s.json" "0070_d_5_s.json" 13 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 384: 0070_d_6_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0384_0070_d_6_s.out"
run_job 384 "./models/adult/0070_d_6_s.json" "0070_d_6_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 385: 0070_d_6_s.json feature 1
wait_for_slot

OUTPUT_FILE="outputs/0385_0070_d_6_s.out"
run_job 385 "./models/adult/0070_d_6_s.json" "0070_d_6_s.json" 1 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 386: 0070_d_6_s.json feature 2
wait_for_slot

OUTPUT_FILE="outputs/0386_0070_d_6_s.out"
run_job 386 "./models/adult/0070_d_6_s.json" "0070_d_6_s.json" 2 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 387: 0070_d_6_s.json feature 3
wait_for_slot

OUTPUT_FILE="outputs/0387_0070_d_6_s.out"
run_job 387 "./models/adult/0070_d_6_s.json" "0070_d_6_s.json" 3 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 388: 0070_d_6_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0388_0070_d_6_s.out"
run_job 388 "./models/adult/0070_d_6_s.json" "0070_d_6_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 389: 0070_d_6_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0389_0070_d_6_s.out"
run_job 389 "./models/adult/0070_d_6_s.json" "0070_d_6_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 390: 0070_d_6_s.json feature 6
wait_for_slot

OUTPUT_FILE="outputs/0390_0070_d_6_s.out"
run_job 390 "./models/adult/0070_d_6_s.json" "0070_d_6_s.json" 6 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 391: 0070_d_6_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0391_0070_d_6_s.out"
run_job 391 "./models/adult/0070_d_6_s.json" "0070_d_6_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 392: 0070_d_6_s.json feature 8
wait_for_slot

OUTPUT_FILE="outputs/0392_0070_d_6_s.out"
run_job 392 "./models/adult/0070_d_6_s.json" "0070_d_6_s.json" 8 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 393: 0070_d_6_s.json feature 9
wait_for_slot

OUTPUT_FILE="outputs/0393_0070_d_6_s.out"
run_job 393 "./models/adult/0070_d_6_s.json" "0070_d_6_s.json" 9 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 394: 0070_d_6_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0394_0070_d_6_s.out"
run_job 394 "./models/adult/0070_d_6_s.json" "0070_d_6_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 395: 0070_d_6_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0395_0070_d_6_s.out"
run_job 395 "./models/adult/0070_d_6_s.json" "0070_d_6_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 396: 0070_d_6_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0396_0070_d_6_s.out"
run_job 396 "./models/adult/0070_d_6_s.json" "0070_d_6_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 397: 0070_d_6_s.json feature 13
wait_for_slot

OUTPUT_FILE="outputs/0397_0070_d_6_s.out"
run_job 397 "./models/adult/0070_d_6_s.json" "0070_d_6_s.json" 13 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 398: 0080_d_2_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0398_0080_d_2_s.out"
run_job 398 "./models/adult/0080_d_2_s.json" "0080_d_2_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 399: 0080_d_2_s.json feature 1
wait_for_slot

OUTPUT_FILE="outputs/0399_0080_d_2_s.out"
run_job 399 "./models/adult/0080_d_2_s.json" "0080_d_2_s.json" 1 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 400: 0080_d_2_s.json feature 3
wait_for_slot

OUTPUT_FILE="outputs/0400_0080_d_2_s.out"
run_job 400 "./models/adult/0080_d_2_s.json" "0080_d_2_s.json" 3 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 401: 0080_d_2_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0401_0080_d_2_s.out"
run_job 401 "./models/adult/0080_d_2_s.json" "0080_d_2_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 402: 0080_d_2_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0402_0080_d_2_s.out"
run_job 402 "./models/adult/0080_d_2_s.json" "0080_d_2_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 403: 0080_d_2_s.json feature 6
wait_for_slot

OUTPUT_FILE="outputs/0403_0080_d_2_s.out"
run_job 403 "./models/adult/0080_d_2_s.json" "0080_d_2_s.json" 6 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 404: 0080_d_2_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0404_0080_d_2_s.out"
run_job 404 "./models/adult/0080_d_2_s.json" "0080_d_2_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 405: 0080_d_2_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0405_0080_d_2_s.out"
run_job 405 "./models/adult/0080_d_2_s.json" "0080_d_2_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 406: 0080_d_2_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0406_0080_d_2_s.out"
run_job 406 "./models/adult/0080_d_2_s.json" "0080_d_2_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 407: 0080_d_2_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0407_0080_d_2_s.out"
run_job 407 "./models/adult/0080_d_2_s.json" "0080_d_2_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 408: 0080_d_2_s.json feature 13
wait_for_slot

OUTPUT_FILE="outputs/0408_0080_d_2_s.out"
run_job 408 "./models/adult/0080_d_2_s.json" "0080_d_2_s.json" 13 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 409: 0080_d_3_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0409_0080_d_3_s.out"
run_job 409 "./models/adult/0080_d_3_s.json" "0080_d_3_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 410: 0080_d_3_s.json feature 1
wait_for_slot

OUTPUT_FILE="outputs/0410_0080_d_3_s.out"
run_job 410 "./models/adult/0080_d_3_s.json" "0080_d_3_s.json" 1 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 411: 0080_d_3_s.json feature 2
wait_for_slot

OUTPUT_FILE="outputs/0411_0080_d_3_s.out"
run_job 411 "./models/adult/0080_d_3_s.json" "0080_d_3_s.json" 2 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 412: 0080_d_3_s.json feature 3
wait_for_slot

OUTPUT_FILE="outputs/0412_0080_d_3_s.out"
run_job 412 "./models/adult/0080_d_3_s.json" "0080_d_3_s.json" 3 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 413: 0080_d_3_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0413_0080_d_3_s.out"
run_job 413 "./models/adult/0080_d_3_s.json" "0080_d_3_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 414: 0080_d_3_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0414_0080_d_3_s.out"
run_job 414 "./models/adult/0080_d_3_s.json" "0080_d_3_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 415: 0080_d_3_s.json feature 6
wait_for_slot

OUTPUT_FILE="outputs/0415_0080_d_3_s.out"
run_job 415 "./models/adult/0080_d_3_s.json" "0080_d_3_s.json" 6 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 416: 0080_d_3_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0416_0080_d_3_s.out"
run_job 416 "./models/adult/0080_d_3_s.json" "0080_d_3_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 417: 0080_d_3_s.json feature 8
wait_for_slot

OUTPUT_FILE="outputs/0417_0080_d_3_s.out"
run_job 417 "./models/adult/0080_d_3_s.json" "0080_d_3_s.json" 8 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 418: 0080_d_3_s.json feature 9
wait_for_slot

OUTPUT_FILE="outputs/0418_0080_d_3_s.out"
run_job 418 "./models/adult/0080_d_3_s.json" "0080_d_3_s.json" 9 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 419: 0080_d_3_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0419_0080_d_3_s.out"
run_job 419 "./models/adult/0080_d_3_s.json" "0080_d_3_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 420: 0080_d_3_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0420_0080_d_3_s.out"
run_job 420 "./models/adult/0080_d_3_s.json" "0080_d_3_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 421: 0080_d_3_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0421_0080_d_3_s.out"
run_job 421 "./models/adult/0080_d_3_s.json" "0080_d_3_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 422: 0080_d_3_s.json feature 13
wait_for_slot

OUTPUT_FILE="outputs/0422_0080_d_3_s.out"
run_job 422 "./models/adult/0080_d_3_s.json" "0080_d_3_s.json" 13 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 423: 0080_d_4_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0423_0080_d_4_s.out"
run_job 423 "./models/adult/0080_d_4_s.json" "0080_d_4_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 424: 0080_d_4_s.json feature 1
wait_for_slot

OUTPUT_FILE="outputs/0424_0080_d_4_s.out"
run_job 424 "./models/adult/0080_d_4_s.json" "0080_d_4_s.json" 1 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 425: 0080_d_4_s.json feature 2
wait_for_slot

OUTPUT_FILE="outputs/0425_0080_d_4_s.out"
run_job 425 "./models/adult/0080_d_4_s.json" "0080_d_4_s.json" 2 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 426: 0080_d_4_s.json feature 3
wait_for_slot

OUTPUT_FILE="outputs/0426_0080_d_4_s.out"
run_job 426 "./models/adult/0080_d_4_s.json" "0080_d_4_s.json" 3 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 427: 0080_d_4_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0427_0080_d_4_s.out"
run_job 427 "./models/adult/0080_d_4_s.json" "0080_d_4_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 428: 0080_d_4_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0428_0080_d_4_s.out"
run_job 428 "./models/adult/0080_d_4_s.json" "0080_d_4_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 429: 0080_d_4_s.json feature 6
wait_for_slot

OUTPUT_FILE="outputs/0429_0080_d_4_s.out"
run_job 429 "./models/adult/0080_d_4_s.json" "0080_d_4_s.json" 6 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 430: 0080_d_4_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0430_0080_d_4_s.out"
run_job 430 "./models/adult/0080_d_4_s.json" "0080_d_4_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 431: 0080_d_4_s.json feature 8
wait_for_slot

OUTPUT_FILE="outputs/0431_0080_d_4_s.out"
run_job 431 "./models/adult/0080_d_4_s.json" "0080_d_4_s.json" 8 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 432: 0080_d_4_s.json feature 9
wait_for_slot

OUTPUT_FILE="outputs/0432_0080_d_4_s.out"
run_job 432 "./models/adult/0080_d_4_s.json" "0080_d_4_s.json" 9 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 433: 0080_d_4_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0433_0080_d_4_s.out"
run_job 433 "./models/adult/0080_d_4_s.json" "0080_d_4_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 434: 0080_d_4_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0434_0080_d_4_s.out"
run_job 434 "./models/adult/0080_d_4_s.json" "0080_d_4_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 435: 0080_d_4_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0435_0080_d_4_s.out"
run_job 435 "./models/adult/0080_d_4_s.json" "0080_d_4_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 436: 0080_d_4_s.json feature 13
wait_for_slot

OUTPUT_FILE="outputs/0436_0080_d_4_s.out"
run_job 436 "./models/adult/0080_d_4_s.json" "0080_d_4_s.json" 13 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 437: 0080_d_5_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0437_0080_d_5_s.out"
run_job 437 "./models/adult/0080_d_5_s.json" "0080_d_5_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 438: 0080_d_5_s.json feature 1
wait_for_slot

OUTPUT_FILE="outputs/0438_0080_d_5_s.out"
run_job 438 "./models/adult/0080_d_5_s.json" "0080_d_5_s.json" 1 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 439: 0080_d_5_s.json feature 2
wait_for_slot

OUTPUT_FILE="outputs/0439_0080_d_5_s.out"
run_job 439 "./models/adult/0080_d_5_s.json" "0080_d_5_s.json" 2 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 440: 0080_d_5_s.json feature 3
wait_for_slot

OUTPUT_FILE="outputs/0440_0080_d_5_s.out"
run_job 440 "./models/adult/0080_d_5_s.json" "0080_d_5_s.json" 3 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 441: 0080_d_5_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0441_0080_d_5_s.out"
run_job 441 "./models/adult/0080_d_5_s.json" "0080_d_5_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 442: 0080_d_5_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0442_0080_d_5_s.out"
run_job 442 "./models/adult/0080_d_5_s.json" "0080_d_5_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 443: 0080_d_5_s.json feature 6
wait_for_slot

OUTPUT_FILE="outputs/0443_0080_d_5_s.out"
run_job 443 "./models/adult/0080_d_5_s.json" "0080_d_5_s.json" 6 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 444: 0080_d_5_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0444_0080_d_5_s.out"
run_job 444 "./models/adult/0080_d_5_s.json" "0080_d_5_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 445: 0080_d_5_s.json feature 8
wait_for_slot

OUTPUT_FILE="outputs/0445_0080_d_5_s.out"
run_job 445 "./models/adult/0080_d_5_s.json" "0080_d_5_s.json" 8 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 446: 0080_d_5_s.json feature 9
wait_for_slot

OUTPUT_FILE="outputs/0446_0080_d_5_s.out"
run_job 446 "./models/adult/0080_d_5_s.json" "0080_d_5_s.json" 9 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 447: 0080_d_5_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0447_0080_d_5_s.out"
run_job 447 "./models/adult/0080_d_5_s.json" "0080_d_5_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 448: 0080_d_5_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0448_0080_d_5_s.out"
run_job 448 "./models/adult/0080_d_5_s.json" "0080_d_5_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 449: 0080_d_5_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0449_0080_d_5_s.out"
run_job 449 "./models/adult/0080_d_5_s.json" "0080_d_5_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 450: 0080_d_5_s.json feature 13
wait_for_slot

OUTPUT_FILE="outputs/0450_0080_d_5_s.out"
run_job 450 "./models/adult/0080_d_5_s.json" "0080_d_5_s.json" 13 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 451: 0080_d_6_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0451_0080_d_6_s.out"
run_job 451 "./models/adult/0080_d_6_s.json" "0080_d_6_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 452: 0080_d_6_s.json feature 1
wait_for_slot

OUTPUT_FILE="outputs/0452_0080_d_6_s.out"
run_job 452 "./models/adult/0080_d_6_s.json" "0080_d_6_s.json" 1 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 453: 0080_d_6_s.json feature 2
wait_for_slot

OUTPUT_FILE="outputs/0453_0080_d_6_s.out"
run_job 453 "./models/adult/0080_d_6_s.json" "0080_d_6_s.json" 2 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 454: 0080_d_6_s.json feature 3
wait_for_slot

OUTPUT_FILE="outputs/0454_0080_d_6_s.out"
run_job 454 "./models/adult/0080_d_6_s.json" "0080_d_6_s.json" 3 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 455: 0080_d_6_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0455_0080_d_6_s.out"
run_job 455 "./models/adult/0080_d_6_s.json" "0080_d_6_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 456: 0080_d_6_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0456_0080_d_6_s.out"
run_job 456 "./models/adult/0080_d_6_s.json" "0080_d_6_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 457: 0080_d_6_s.json feature 6
wait_for_slot

OUTPUT_FILE="outputs/0457_0080_d_6_s.out"
run_job 457 "./models/adult/0080_d_6_s.json" "0080_d_6_s.json" 6 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 458: 0080_d_6_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0458_0080_d_6_s.out"
run_job 458 "./models/adult/0080_d_6_s.json" "0080_d_6_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 459: 0080_d_6_s.json feature 8
wait_for_slot

OUTPUT_FILE="outputs/0459_0080_d_6_s.out"
run_job 459 "./models/adult/0080_d_6_s.json" "0080_d_6_s.json" 8 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 460: 0080_d_6_s.json feature 9
wait_for_slot

OUTPUT_FILE="outputs/0460_0080_d_6_s.out"
run_job 460 "./models/adult/0080_d_6_s.json" "0080_d_6_s.json" 9 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 461: 0080_d_6_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0461_0080_d_6_s.out"
run_job 461 "./models/adult/0080_d_6_s.json" "0080_d_6_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 462: 0080_d_6_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0462_0080_d_6_s.out"
run_job 462 "./models/adult/0080_d_6_s.json" "0080_d_6_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 463: 0080_d_6_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0463_0080_d_6_s.out"
run_job 463 "./models/adult/0080_d_6_s.json" "0080_d_6_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 464: 0080_d_6_s.json feature 13
wait_for_slot

OUTPUT_FILE="outputs/0464_0080_d_6_s.out"
run_job 464 "./models/adult/0080_d_6_s.json" "0080_d_6_s.json" 13 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 465: 0090_d_2_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0465_0090_d_2_s.out"
run_job 465 "./models/adult/0090_d_2_s.json" "0090_d_2_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 466: 0090_d_2_s.json feature 1
wait_for_slot

OUTPUT_FILE="outputs/0466_0090_d_2_s.out"
run_job 466 "./models/adult/0090_d_2_s.json" "0090_d_2_s.json" 1 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 467: 0090_d_2_s.json feature 2
wait_for_slot

OUTPUT_FILE="outputs/0467_0090_d_2_s.out"
run_job 467 "./models/adult/0090_d_2_s.json" "0090_d_2_s.json" 2 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 468: 0090_d_2_s.json feature 3
wait_for_slot

OUTPUT_FILE="outputs/0468_0090_d_2_s.out"
run_job 468 "./models/adult/0090_d_2_s.json" "0090_d_2_s.json" 3 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 469: 0090_d_2_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0469_0090_d_2_s.out"
run_job 469 "./models/adult/0090_d_2_s.json" "0090_d_2_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 470: 0090_d_2_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0470_0090_d_2_s.out"
run_job 470 "./models/adult/0090_d_2_s.json" "0090_d_2_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 471: 0090_d_2_s.json feature 6
wait_for_slot

OUTPUT_FILE="outputs/0471_0090_d_2_s.out"
run_job 471 "./models/adult/0090_d_2_s.json" "0090_d_2_s.json" 6 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 472: 0090_d_2_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0472_0090_d_2_s.out"
run_job 472 "./models/adult/0090_d_2_s.json" "0090_d_2_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 473: 0090_d_2_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0473_0090_d_2_s.out"
run_job 473 "./models/adult/0090_d_2_s.json" "0090_d_2_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 474: 0090_d_2_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0474_0090_d_2_s.out"
run_job 474 "./models/adult/0090_d_2_s.json" "0090_d_2_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 475: 0090_d_2_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0475_0090_d_2_s.out"
run_job 475 "./models/adult/0090_d_2_s.json" "0090_d_2_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 476: 0090_d_2_s.json feature 13
wait_for_slot

OUTPUT_FILE="outputs/0476_0090_d_2_s.out"
run_job 476 "./models/adult/0090_d_2_s.json" "0090_d_2_s.json" 13 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 477: 0090_d_3_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0477_0090_d_3_s.out"
run_job 477 "./models/adult/0090_d_3_s.json" "0090_d_3_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 478: 0090_d_3_s.json feature 1
wait_for_slot

OUTPUT_FILE="outputs/0478_0090_d_3_s.out"
run_job 478 "./models/adult/0090_d_3_s.json" "0090_d_3_s.json" 1 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 479: 0090_d_3_s.json feature 2
wait_for_slot

OUTPUT_FILE="outputs/0479_0090_d_3_s.out"
run_job 479 "./models/adult/0090_d_3_s.json" "0090_d_3_s.json" 2 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 480: 0090_d_3_s.json feature 3
wait_for_slot

OUTPUT_FILE="outputs/0480_0090_d_3_s.out"
run_job 480 "./models/adult/0090_d_3_s.json" "0090_d_3_s.json" 3 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 481: 0090_d_3_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0481_0090_d_3_s.out"
run_job 481 "./models/adult/0090_d_3_s.json" "0090_d_3_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 482: 0090_d_3_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0482_0090_d_3_s.out"
run_job 482 "./models/adult/0090_d_3_s.json" "0090_d_3_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 483: 0090_d_3_s.json feature 6
wait_for_slot

OUTPUT_FILE="outputs/0483_0090_d_3_s.out"
run_job 483 "./models/adult/0090_d_3_s.json" "0090_d_3_s.json" 6 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 484: 0090_d_3_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0484_0090_d_3_s.out"
run_job 484 "./models/adult/0090_d_3_s.json" "0090_d_3_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 485: 0090_d_3_s.json feature 8
wait_for_slot

OUTPUT_FILE="outputs/0485_0090_d_3_s.out"
run_job 485 "./models/adult/0090_d_3_s.json" "0090_d_3_s.json" 8 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 486: 0090_d_3_s.json feature 9
wait_for_slot

OUTPUT_FILE="outputs/0486_0090_d_3_s.out"
run_job 486 "./models/adult/0090_d_3_s.json" "0090_d_3_s.json" 9 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 487: 0090_d_3_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0487_0090_d_3_s.out"
run_job 487 "./models/adult/0090_d_3_s.json" "0090_d_3_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 488: 0090_d_3_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0488_0090_d_3_s.out"
run_job 488 "./models/adult/0090_d_3_s.json" "0090_d_3_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 489: 0090_d_3_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0489_0090_d_3_s.out"
run_job 489 "./models/adult/0090_d_3_s.json" "0090_d_3_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 490: 0090_d_3_s.json feature 13
wait_for_slot

OUTPUT_FILE="outputs/0490_0090_d_3_s.out"
run_job 490 "./models/adult/0090_d_3_s.json" "0090_d_3_s.json" 13 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 491: 0090_d_4_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0491_0090_d_4_s.out"
run_job 491 "./models/adult/0090_d_4_s.json" "0090_d_4_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 492: 0090_d_4_s.json feature 1
wait_for_slot

OUTPUT_FILE="outputs/0492_0090_d_4_s.out"
run_job 492 "./models/adult/0090_d_4_s.json" "0090_d_4_s.json" 1 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 493: 0090_d_4_s.json feature 2
wait_for_slot

OUTPUT_FILE="outputs/0493_0090_d_4_s.out"
run_job 493 "./models/adult/0090_d_4_s.json" "0090_d_4_s.json" 2 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 494: 0090_d_4_s.json feature 3
wait_for_slot

OUTPUT_FILE="outputs/0494_0090_d_4_s.out"
run_job 494 "./models/adult/0090_d_4_s.json" "0090_d_4_s.json" 3 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 495: 0090_d_4_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0495_0090_d_4_s.out"
run_job 495 "./models/adult/0090_d_4_s.json" "0090_d_4_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 496: 0090_d_4_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0496_0090_d_4_s.out"
run_job 496 "./models/adult/0090_d_4_s.json" "0090_d_4_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 497: 0090_d_4_s.json feature 6
wait_for_slot

OUTPUT_FILE="outputs/0497_0090_d_4_s.out"
run_job 497 "./models/adult/0090_d_4_s.json" "0090_d_4_s.json" 6 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 498: 0090_d_4_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0498_0090_d_4_s.out"
run_job 498 "./models/adult/0090_d_4_s.json" "0090_d_4_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 499: 0090_d_4_s.json feature 8
wait_for_slot

OUTPUT_FILE="outputs/0499_0090_d_4_s.out"
run_job 499 "./models/adult/0090_d_4_s.json" "0090_d_4_s.json" 8 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 500: 0090_d_4_s.json feature 9
wait_for_slot

OUTPUT_FILE="outputs/0500_0090_d_4_s.out"
run_job 500 "./models/adult/0090_d_4_s.json" "0090_d_4_s.json" 9 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 501: 0090_d_4_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0501_0090_d_4_s.out"
run_job 501 "./models/adult/0090_d_4_s.json" "0090_d_4_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 502: 0090_d_4_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0502_0090_d_4_s.out"
run_job 502 "./models/adult/0090_d_4_s.json" "0090_d_4_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 503: 0090_d_4_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0503_0090_d_4_s.out"
run_job 503 "./models/adult/0090_d_4_s.json" "0090_d_4_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 504: 0090_d_4_s.json feature 13
wait_for_slot

OUTPUT_FILE="outputs/0504_0090_d_4_s.out"
run_job 504 "./models/adult/0090_d_4_s.json" "0090_d_4_s.json" 13 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 505: 0090_d_5_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0505_0090_d_5_s.out"
run_job 505 "./models/adult/0090_d_5_s.json" "0090_d_5_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 506: 0090_d_5_s.json feature 1
wait_for_slot

OUTPUT_FILE="outputs/0506_0090_d_5_s.out"
run_job 506 "./models/adult/0090_d_5_s.json" "0090_d_5_s.json" 1 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 507: 0090_d_5_s.json feature 2
wait_for_slot

OUTPUT_FILE="outputs/0507_0090_d_5_s.out"
run_job 507 "./models/adult/0090_d_5_s.json" "0090_d_5_s.json" 2 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 508: 0090_d_5_s.json feature 3
wait_for_slot

OUTPUT_FILE="outputs/0508_0090_d_5_s.out"
run_job 508 "./models/adult/0090_d_5_s.json" "0090_d_5_s.json" 3 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 509: 0090_d_5_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0509_0090_d_5_s.out"
run_job 509 "./models/adult/0090_d_5_s.json" "0090_d_5_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 510: 0090_d_5_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0510_0090_d_5_s.out"
run_job 510 "./models/adult/0090_d_5_s.json" "0090_d_5_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 511: 0090_d_5_s.json feature 6
wait_for_slot

OUTPUT_FILE="outputs/0511_0090_d_5_s.out"
run_job 511 "./models/adult/0090_d_5_s.json" "0090_d_5_s.json" 6 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 512: 0090_d_5_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0512_0090_d_5_s.out"
run_job 512 "./models/adult/0090_d_5_s.json" "0090_d_5_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 513: 0090_d_5_s.json feature 8
wait_for_slot

OUTPUT_FILE="outputs/0513_0090_d_5_s.out"
run_job 513 "./models/adult/0090_d_5_s.json" "0090_d_5_s.json" 8 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 514: 0090_d_5_s.json feature 9
wait_for_slot

OUTPUT_FILE="outputs/0514_0090_d_5_s.out"
run_job 514 "./models/adult/0090_d_5_s.json" "0090_d_5_s.json" 9 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 515: 0090_d_5_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0515_0090_d_5_s.out"
run_job 515 "./models/adult/0090_d_5_s.json" "0090_d_5_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 516: 0090_d_5_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0516_0090_d_5_s.out"
run_job 516 "./models/adult/0090_d_5_s.json" "0090_d_5_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 517: 0090_d_5_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0517_0090_d_5_s.out"
run_job 517 "./models/adult/0090_d_5_s.json" "0090_d_5_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 518: 0090_d_5_s.json feature 13
wait_for_slot

OUTPUT_FILE="outputs/0518_0090_d_5_s.out"
run_job 518 "./models/adult/0090_d_5_s.json" "0090_d_5_s.json" 13 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 519: 0090_d_6_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0519_0090_d_6_s.out"
run_job 519 "./models/adult/0090_d_6_s.json" "0090_d_6_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 520: 0090_d_6_s.json feature 1
wait_for_slot

OUTPUT_FILE="outputs/0520_0090_d_6_s.out"
run_job 520 "./models/adult/0090_d_6_s.json" "0090_d_6_s.json" 1 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 521: 0090_d_6_s.json feature 2
wait_for_slot

OUTPUT_FILE="outputs/0521_0090_d_6_s.out"
run_job 521 "./models/adult/0090_d_6_s.json" "0090_d_6_s.json" 2 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 522: 0090_d_6_s.json feature 3
wait_for_slot

OUTPUT_FILE="outputs/0522_0090_d_6_s.out"
run_job 522 "./models/adult/0090_d_6_s.json" "0090_d_6_s.json" 3 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 523: 0090_d_6_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0523_0090_d_6_s.out"
run_job 523 "./models/adult/0090_d_6_s.json" "0090_d_6_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 524: 0090_d_6_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0524_0090_d_6_s.out"
run_job 524 "./models/adult/0090_d_6_s.json" "0090_d_6_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 525: 0090_d_6_s.json feature 6
wait_for_slot

OUTPUT_FILE="outputs/0525_0090_d_6_s.out"
run_job 525 "./models/adult/0090_d_6_s.json" "0090_d_6_s.json" 6 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 526: 0090_d_6_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0526_0090_d_6_s.out"
run_job 526 "./models/adult/0090_d_6_s.json" "0090_d_6_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 527: 0090_d_6_s.json feature 8
wait_for_slot

OUTPUT_FILE="outputs/0527_0090_d_6_s.out"
run_job 527 "./models/adult/0090_d_6_s.json" "0090_d_6_s.json" 8 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 528: 0090_d_6_s.json feature 9
wait_for_slot

OUTPUT_FILE="outputs/0528_0090_d_6_s.out"
run_job 528 "./models/adult/0090_d_6_s.json" "0090_d_6_s.json" 9 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 529: 0090_d_6_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0529_0090_d_6_s.out"
run_job 529 "./models/adult/0090_d_6_s.json" "0090_d_6_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 530: 0090_d_6_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0530_0090_d_6_s.out"
run_job 530 "./models/adult/0090_d_6_s.json" "0090_d_6_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 531: 0090_d_6_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0531_0090_d_6_s.out"
run_job 531 "./models/adult/0090_d_6_s.json" "0090_d_6_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 532: 0090_d_6_s.json feature 13
wait_for_slot

OUTPUT_FILE="outputs/0532_0090_d_6_s.out"
run_job 532 "./models/adult/0090_d_6_s.json" "0090_d_6_s.json" 13 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 533: 0100_d_2_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0533_0100_d_2_s.out"
run_job 533 "./models/adult/0100_d_2_s.json" "0100_d_2_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 534: 0100_d_2_s.json feature 1
wait_for_slot

OUTPUT_FILE="outputs/0534_0100_d_2_s.out"
run_job 534 "./models/adult/0100_d_2_s.json" "0100_d_2_s.json" 1 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 535: 0100_d_2_s.json feature 2
wait_for_slot

OUTPUT_FILE="outputs/0535_0100_d_2_s.out"
run_job 535 "./models/adult/0100_d_2_s.json" "0100_d_2_s.json" 2 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 536: 0100_d_2_s.json feature 3
wait_for_slot

OUTPUT_FILE="outputs/0536_0100_d_2_s.out"
run_job 536 "./models/adult/0100_d_2_s.json" "0100_d_2_s.json" 3 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 537: 0100_d_2_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0537_0100_d_2_s.out"
run_job 537 "./models/adult/0100_d_2_s.json" "0100_d_2_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 538: 0100_d_2_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0538_0100_d_2_s.out"
run_job 538 "./models/adult/0100_d_2_s.json" "0100_d_2_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 539: 0100_d_2_s.json feature 6
wait_for_slot

OUTPUT_FILE="outputs/0539_0100_d_2_s.out"
run_job 539 "./models/adult/0100_d_2_s.json" "0100_d_2_s.json" 6 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 540: 0100_d_2_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0540_0100_d_2_s.out"
run_job 540 "./models/adult/0100_d_2_s.json" "0100_d_2_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 541: 0100_d_2_s.json feature 8
wait_for_slot

OUTPUT_FILE="outputs/0541_0100_d_2_s.out"
run_job 541 "./models/adult/0100_d_2_s.json" "0100_d_2_s.json" 8 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 542: 0100_d_2_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0542_0100_d_2_s.out"
run_job 542 "./models/adult/0100_d_2_s.json" "0100_d_2_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 543: 0100_d_2_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0543_0100_d_2_s.out"
run_job 543 "./models/adult/0100_d_2_s.json" "0100_d_2_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 544: 0100_d_2_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0544_0100_d_2_s.out"
run_job 544 "./models/adult/0100_d_2_s.json" "0100_d_2_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 545: 0100_d_2_s.json feature 13
wait_for_slot

OUTPUT_FILE="outputs/0545_0100_d_2_s.out"
run_job 545 "./models/adult/0100_d_2_s.json" "0100_d_2_s.json" 13 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 546: 0100_d_3_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0546_0100_d_3_s.out"
run_job 546 "./models/adult/0100_d_3_s.json" "0100_d_3_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 547: 0100_d_3_s.json feature 1
wait_for_slot

OUTPUT_FILE="outputs/0547_0100_d_3_s.out"
run_job 547 "./models/adult/0100_d_3_s.json" "0100_d_3_s.json" 1 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 548: 0100_d_3_s.json feature 2
wait_for_slot

OUTPUT_FILE="outputs/0548_0100_d_3_s.out"
run_job 548 "./models/adult/0100_d_3_s.json" "0100_d_3_s.json" 2 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 549: 0100_d_3_s.json feature 3
wait_for_slot

OUTPUT_FILE="outputs/0549_0100_d_3_s.out"
run_job 549 "./models/adult/0100_d_3_s.json" "0100_d_3_s.json" 3 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 550: 0100_d_3_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0550_0100_d_3_s.out"
run_job 550 "./models/adult/0100_d_3_s.json" "0100_d_3_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 551: 0100_d_3_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0551_0100_d_3_s.out"
run_job 551 "./models/adult/0100_d_3_s.json" "0100_d_3_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 552: 0100_d_3_s.json feature 6
wait_for_slot

OUTPUT_FILE="outputs/0552_0100_d_3_s.out"
run_job 552 "./models/adult/0100_d_3_s.json" "0100_d_3_s.json" 6 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 553: 0100_d_3_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0553_0100_d_3_s.out"
run_job 553 "./models/adult/0100_d_3_s.json" "0100_d_3_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 554: 0100_d_3_s.json feature 8
wait_for_slot

OUTPUT_FILE="outputs/0554_0100_d_3_s.out"
run_job 554 "./models/adult/0100_d_3_s.json" "0100_d_3_s.json" 8 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 555: 0100_d_3_s.json feature 9
wait_for_slot

OUTPUT_FILE="outputs/0555_0100_d_3_s.out"
run_job 555 "./models/adult/0100_d_3_s.json" "0100_d_3_s.json" 9 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 556: 0100_d_3_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0556_0100_d_3_s.out"
run_job 556 "./models/adult/0100_d_3_s.json" "0100_d_3_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 557: 0100_d_3_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0557_0100_d_3_s.out"
run_job 557 "./models/adult/0100_d_3_s.json" "0100_d_3_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 558: 0100_d_3_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0558_0100_d_3_s.out"
run_job 558 "./models/adult/0100_d_3_s.json" "0100_d_3_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 559: 0100_d_3_s.json feature 13
wait_for_slot

OUTPUT_FILE="outputs/0559_0100_d_3_s.out"
run_job 559 "./models/adult/0100_d_3_s.json" "0100_d_3_s.json" 13 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 560: 0100_d_4_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0560_0100_d_4_s.out"
run_job 560 "./models/adult/0100_d_4_s.json" "0100_d_4_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 561: 0100_d_4_s.json feature 1
wait_for_slot

OUTPUT_FILE="outputs/0561_0100_d_4_s.out"
run_job 561 "./models/adult/0100_d_4_s.json" "0100_d_4_s.json" 1 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 562: 0100_d_4_s.json feature 2
wait_for_slot

OUTPUT_FILE="outputs/0562_0100_d_4_s.out"
run_job 562 "./models/adult/0100_d_4_s.json" "0100_d_4_s.json" 2 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 563: 0100_d_4_s.json feature 3
wait_for_slot

OUTPUT_FILE="outputs/0563_0100_d_4_s.out"
run_job 563 "./models/adult/0100_d_4_s.json" "0100_d_4_s.json" 3 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 564: 0100_d_4_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0564_0100_d_4_s.out"
run_job 564 "./models/adult/0100_d_4_s.json" "0100_d_4_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 565: 0100_d_4_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0565_0100_d_4_s.out"
run_job 565 "./models/adult/0100_d_4_s.json" "0100_d_4_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 566: 0100_d_4_s.json feature 6
wait_for_slot

OUTPUT_FILE="outputs/0566_0100_d_4_s.out"
run_job 566 "./models/adult/0100_d_4_s.json" "0100_d_4_s.json" 6 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 567: 0100_d_4_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0567_0100_d_4_s.out"
run_job 567 "./models/adult/0100_d_4_s.json" "0100_d_4_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 568: 0100_d_4_s.json feature 8
wait_for_slot

OUTPUT_FILE="outputs/0568_0100_d_4_s.out"
run_job 568 "./models/adult/0100_d_4_s.json" "0100_d_4_s.json" 8 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 569: 0100_d_4_s.json feature 9
wait_for_slot

OUTPUT_FILE="outputs/0569_0100_d_4_s.out"
run_job 569 "./models/adult/0100_d_4_s.json" "0100_d_4_s.json" 9 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 570: 0100_d_4_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0570_0100_d_4_s.out"
run_job 570 "./models/adult/0100_d_4_s.json" "0100_d_4_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 571: 0100_d_4_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0571_0100_d_4_s.out"
run_job 571 "./models/adult/0100_d_4_s.json" "0100_d_4_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 572: 0100_d_4_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0572_0100_d_4_s.out"
run_job 572 "./models/adult/0100_d_4_s.json" "0100_d_4_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 573: 0100_d_4_s.json feature 13
wait_for_slot

OUTPUT_FILE="outputs/0573_0100_d_4_s.out"
run_job 573 "./models/adult/0100_d_4_s.json" "0100_d_4_s.json" 13 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 574: 0100_d_5_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0574_0100_d_5_s.out"
run_job 574 "./models/adult/0100_d_5_s.json" "0100_d_5_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 575: 0100_d_5_s.json feature 1
wait_for_slot

OUTPUT_FILE="outputs/0575_0100_d_5_s.out"
run_job 575 "./models/adult/0100_d_5_s.json" "0100_d_5_s.json" 1 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 576: 0100_d_5_s.json feature 2
wait_for_slot

OUTPUT_FILE="outputs/0576_0100_d_5_s.out"
run_job 576 "./models/adult/0100_d_5_s.json" "0100_d_5_s.json" 2 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 577: 0100_d_5_s.json feature 3
wait_for_slot

OUTPUT_FILE="outputs/0577_0100_d_5_s.out"
run_job 577 "./models/adult/0100_d_5_s.json" "0100_d_5_s.json" 3 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 578: 0100_d_5_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0578_0100_d_5_s.out"
run_job 578 "./models/adult/0100_d_5_s.json" "0100_d_5_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 579: 0100_d_5_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0579_0100_d_5_s.out"
run_job 579 "./models/adult/0100_d_5_s.json" "0100_d_5_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 580: 0100_d_5_s.json feature 6
wait_for_slot

OUTPUT_FILE="outputs/0580_0100_d_5_s.out"
run_job 580 "./models/adult/0100_d_5_s.json" "0100_d_5_s.json" 6 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 581: 0100_d_5_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0581_0100_d_5_s.out"
run_job 581 "./models/adult/0100_d_5_s.json" "0100_d_5_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 582: 0100_d_5_s.json feature 8
wait_for_slot

OUTPUT_FILE="outputs/0582_0100_d_5_s.out"
run_job 582 "./models/adult/0100_d_5_s.json" "0100_d_5_s.json" 8 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 583: 0100_d_5_s.json feature 9
wait_for_slot

OUTPUT_FILE="outputs/0583_0100_d_5_s.out"
run_job 583 "./models/adult/0100_d_5_s.json" "0100_d_5_s.json" 9 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 584: 0100_d_5_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0584_0100_d_5_s.out"
run_job 584 "./models/adult/0100_d_5_s.json" "0100_d_5_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 585: 0100_d_5_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0585_0100_d_5_s.out"
run_job 585 "./models/adult/0100_d_5_s.json" "0100_d_5_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 586: 0100_d_5_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0586_0100_d_5_s.out"
run_job 586 "./models/adult/0100_d_5_s.json" "0100_d_5_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 587: 0100_d_5_s.json feature 13
wait_for_slot

OUTPUT_FILE="outputs/0587_0100_d_5_s.out"
run_job 587 "./models/adult/0100_d_5_s.json" "0100_d_5_s.json" 13 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 588: 0100_d_6_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0588_0100_d_6_s.out"
run_job 588 "./models/adult/0100_d_6_s.json" "0100_d_6_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 589: 0100_d_6_s.json feature 1
wait_for_slot

OUTPUT_FILE="outputs/0589_0100_d_6_s.out"
run_job 589 "./models/adult/0100_d_6_s.json" "0100_d_6_s.json" 1 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 590: 0100_d_6_s.json feature 2
wait_for_slot

OUTPUT_FILE="outputs/0590_0100_d_6_s.out"
run_job 590 "./models/adult/0100_d_6_s.json" "0100_d_6_s.json" 2 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 591: 0100_d_6_s.json feature 3
wait_for_slot

OUTPUT_FILE="outputs/0591_0100_d_6_s.out"
run_job 591 "./models/adult/0100_d_6_s.json" "0100_d_6_s.json" 3 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 592: 0100_d_6_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0592_0100_d_6_s.out"
run_job 592 "./models/adult/0100_d_6_s.json" "0100_d_6_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 593: 0100_d_6_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0593_0100_d_6_s.out"
run_job 593 "./models/adult/0100_d_6_s.json" "0100_d_6_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 594: 0100_d_6_s.json feature 6
wait_for_slot

OUTPUT_FILE="outputs/0594_0100_d_6_s.out"
run_job 594 "./models/adult/0100_d_6_s.json" "0100_d_6_s.json" 6 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 595: 0100_d_6_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0595_0100_d_6_s.out"
run_job 595 "./models/adult/0100_d_6_s.json" "0100_d_6_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 596: 0100_d_6_s.json feature 8
wait_for_slot

OUTPUT_FILE="outputs/0596_0100_d_6_s.out"
run_job 596 "./models/adult/0100_d_6_s.json" "0100_d_6_s.json" 8 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 597: 0100_d_6_s.json feature 9
wait_for_slot

OUTPUT_FILE="outputs/0597_0100_d_6_s.out"
run_job 597 "./models/adult/0100_d_6_s.json" "0100_d_6_s.json" 9 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 598: 0100_d_6_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0598_0100_d_6_s.out"
run_job 598 "./models/adult/0100_d_6_s.json" "0100_d_6_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 599: 0100_d_6_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0599_0100_d_6_s.out"
run_job 599 "./models/adult/0100_d_6_s.json" "0100_d_6_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 600: 0100_d_6_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0600_0100_d_6_s.out"
run_job 600 "./models/adult/0100_d_6_s.json" "0100_d_6_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 601: 0100_d_6_s.json feature 13
wait_for_slot

OUTPUT_FILE="outputs/0601_0100_d_6_s.out"
run_job 601 "./models/adult/0100_d_6_s.json" "0100_d_6_s.json" 13 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 602: test_0010_d_3_s.json feature 0
wait_for_slot

OUTPUT_FILE="outputs/0602_test_0010_d_3_s.out"
run_job 602 "./models/adult/test_0010_d_3_s.json" "test_0010_d_3_s.json" 0 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 603: test_0010_d_3_s.json feature 4
wait_for_slot

OUTPUT_FILE="outputs/0603_test_0010_d_3_s.out"
run_job 603 "./models/adult/test_0010_d_3_s.json" "test_0010_d_3_s.json" 4 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 604: test_0010_d_3_s.json feature 5
wait_for_slot

OUTPUT_FILE="outputs/0604_test_0010_d_3_s.out"
run_job 604 "./models/adult/test_0010_d_3_s.json" "test_0010_d_3_s.json" 5 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 605: test_0010_d_3_s.json feature 7
wait_for_slot

OUTPUT_FILE="outputs/0605_test_0010_d_3_s.out"
run_job 605 "./models/adult/test_0010_d_3_s.json" "test_0010_d_3_s.json" 7 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 606: test_0010_d_3_s.json feature 10
wait_for_slot

OUTPUT_FILE="outputs/0606_test_0010_d_3_s.out"
run_job 606 "./models/adult/test_0010_d_3_s.json" "test_0010_d_3_s.json" 10 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 607: test_0010_d_3_s.json feature 11
wait_for_slot

OUTPUT_FILE="outputs/0607_test_0010_d_3_s.out"
run_job 607 "./models/adult/test_0010_d_3_s.json" "test_0010_d_3_s.json" 11 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

# Job 608: test_0010_d_3_s.json feature 12
wait_for_slot

OUTPUT_FILE="outputs/0608_test_0010_d_3_s.out"
run_job 608 "./models/adult/test_0010_d_3_s.json" "test_0010_d_3_s.json" 12 $OUTPUT_FILE "ganak" &
RUNNING_JOBS=$((RUNNING_JOBS + 1))

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
