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
./PBEncoder/Encoder -I "$out_file" -O "$cnf_file"
if [ -f "$projection_file" ] && [ -f "$cnf_file" ]; then
    tmp_file="${cnf_file}.tmp"
    cat "$projection_file" "$cnf_file" > "$tmp_file"
    mv "$tmp_file" "$cnf_file"
else
    echo "Warning: missing projection or CNF file for $model_name"
fi
mkdir -p outputs
./ganak-mac/ganak ${cnf_file}
END_TIME=$(date +%s)
ELAPSED_TIME=$((END_TIME - START_TIME))
echo "ganak execution time for $model_name on feature $feature : $ELAPSED_TIME seconds"
