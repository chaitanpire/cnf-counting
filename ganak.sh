model_path=$1
feature=$2
gap=$3
precision=$4
bit_distance=$5
model_file=$(basename "$model_path")
model_name="${model_file%.json}"
out_file="./${model_name}_${feature}.opb"
projection_file="${model_name}_${feature}.txt"
cnf_file="./model_cnf/${model_name}_${feature}_cnf.opb"

echo model_path: "$model_path"
START_TIME=$(date +%s)
python3 xgboost/src/sensitive.py "$model_path" --dump_pb16 "$out_file" --solver z3 --gap $gap --precision $precision --features $feature --k $bit_distance --projected_file $projection_file
if [ $? -ne 0 ]; then
    echo "Error: sensitive.py failed for $model_name"
    exit 1
fi

./PBEncoder/Encoder -I "$out_file" -O "$cnf_file"
if [ $? -ne 0 ]; then
    echo "Error: PBEncoder failed for $model_name"
    exit 1
fi

if [ -f "$projection_file" ] && [ -f "$cnf_file" ]; then
    tmp_file="${cnf_file}.tmp"
    cat "$projection_file" "$cnf_file" > "$tmp_file"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to concatenate files for $model_name"
        exit 1
    fi
    mv "$tmp_file" "$cnf_file"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to move tmp file for $model_name"
        exit 1
    fi
else
    echo "Error: missing projection or CNF file for $model_name"
    exit 1
fi

./ganak/ganak ${cnf_file}
if [ $? -ne 0 ]; then
    echo "Error: ganak failed for $model_name"
    exit 1
fi

END_TIME=$(date +%s)
ELAPSED_TIME=$((END_TIME - START_TIME))
echo "ganak execution time for $model_name on feature $feature : $ELAPSED_TIME seconds"
