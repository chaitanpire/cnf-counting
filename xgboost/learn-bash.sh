#!/bin/bash

declare -A modelTrees=(
  [binary_mnist]='1000'
  [breast_cancer]='0004'
  [cod-rna]='0080'
  [covtype]='0080'
  [diabetes]='0020'
  [fashion]='0200'
  [higgs]='0300'
  [ijcnn]='0060'
  [ori_mnist]='0200'
  [webspam]='0100'
)

#!/bin/bash

declare -A modelTrees=(
  [binary_mnist]='1000'
  [breast_cancer]='0004'
  [cod-rna]='0080'
  [covtype]='0080'
  [diabetes]='0020'
  [fashion]='0200'
  [higgs]='0300'
  [ijcnn]='0060'
  [ori_mnist]='0200'
  [webspam]='0100'
)


modelnames=("breast_cancer" "diabetes" "ijcnn")
modeltypes=("robust" "unrobust")

Loop over model names and model types
for modelname in "${modelnames[@]}"; do
  for modeltype in "${modeltypes[@]}"; do
    echo "Running: python3 ./experiments/daily_run_nam.py run ${modelname} ${modeltype}"
        python3 ./experiments/daily_run_nam.py run ${modelname} ${modeltype}  
        echo "Running: python3 ./experiments/daily_run_nam.py results ${modelname} ${modeltype}"
        python3 ./experiments/daily_run_nam.py results ${modelname} ${modeltype} 
  done
done





modelnames=("adult" "pimadiabetes")
depth=("5" "6")
trees=("200" "300" "500")

for modelname in "${modelnames[@]}"; do
  for d in "${depth[@]}"; do
    for t in "${trees[@]}"; do
      echo "Running: python3 ./experiments/daily_run_nam.py run ${modelname} t${t}_d${d}  "
      python3 ./experiments/daily_run_nam.py run ${modelname} t${t}_d${d}
      echo "Running: python3 ./experiments/daily_run_nam.py results ${modelname} t${t}_d${d}"
      python3 ./experiments/daily_run_nam.py results ${modelname} t${t}_d${d}
    done
  done
done

modelnames=("german_credit")
depth=("5" "6")
trees=("500" "800")

# Loop over model names and model types
for modelname in "${modelnames[@]}"; do
  for d in "${depth[@]}"; do
    for t in "${trees[@]}"; do
        echo "Running: python3 ./experiments/daily_run_nam.py run ${modelname} t${t}_d${d}.json  "
        python3 ./experiments/daily_run_nam.py run ${modelname} t${t}_d${d}.json  
        echo "Running: python3 ./experiments/daily_run_nam.py results ${modelname} t${t}_d${d}.json  "
        python3 ./experiments/daily_run_nam.py results ${modelname} t${t}_d${d}.json 
    done
  done
done


# modelnames=("spambase")
# depth=("5" "6")
# trees=("200" "300" "500")

# for modelname in "${modelnames[@]}"; do
#   for d in "${depth[@]}"; do
#     for t in "${trees[@]}"; do
#         echo "./src/learn-data.py --model ./models/${modelname}/${modelname}_t${t}_d${d}.json  --data ./models/dataset/${modelname}/train.csv --output ./output/learned-clauses_${modelname}_t${t}_d${d} --details ./models/dataset/${modelname}/details.csv"
#         ./src/learn-data.py --model ./models/${modelname}/${modelname}_t${t}_d${d}.json  --data ./models/dataset/${modelname}/train.csv --output ./output/learned-clauses_${modelname}_t${t}_d${d} --max_clauses 1500
#     done
#   done
# done


# modelnames=("breast_cancer" "diabetes" "ijcnn")
# modeltypes=("robust" "unrobust")

# #Loop over model names and model types
# # for modelname in "${modelnames[@]}"; do
# #   for modeltype in "${modeltypes[@]}"; do
# #     echo "Running: ./src/learn-data.py --model ./models/tree_verification_models/${modelname}_${modeltype}/${modelTrees[$modelname]}.resaved.json  --data ./models/dataset/${modelname}/${modelname}_train.csv --output ./output/learned-clauses_${modelname}_${modeltype} --details ./models/dataset/${modelname}/${modelname}_details.csv"
# #     ./src/learn-data.py --model ./models/tree_verification_models/${modelname}_${modeltype}/${modelTrees[$modelname]}.resaved.json  --data ./models/dataset/${modelname}/${modelname}_train.csv --output ./output/learned-clauses_${modelname}_${modeltype} --details ./models/dataset/${modelname}/${modelname}_details.csv --max_clauses 1500
# #   done
# # done





# modelnames=("adult" "churn" "pimadiabetes")
# depth=("5" "6")
# trees=("200" "300" "500")

# for modelname in "${modelnames[@]}"; do
#   for d in "${depth[@]}"; do
#     for t in "${trees[@]}"; do
#         echo "./src/learn-data.py --model ./models/${modelname}/${modelname}_t${t}_d${d}.json  --data ./models/dataset/${modelname}/train.csv --output ./output/learned-clauses_${modelname}_t${t}_d${d} --details ./models/dataset/${modelname}/details.csv"
#         ./src/learn-data.py --model ./models/${modelname}/${modelname}_t${t}_d${d}.json  --data ./models/dataset/${modelname}/train.csv --output ./output/learned-clauses_${modelname}_t${t}_d${d} --details ./models/dataset/${modelname}/details.csv --max_clauses 1500
#     done
#   done
# done

# modelnames=("german_credit")
# depth=("5" "6")
# trees=("500" "800")

# # Loop over model names and model types
# for modelname in "${modelnames[@]}"; do
#   for d in "${depth[@]}"; do
#     for t in "${trees[@]}"; do
#         echo "Running: ./src/learn-data.py --model ./models/${modelname}/${modelname}_t${t}_d${d}.json  --data ./models/dataset/${modelname}/train.csv --output ./output/learned-clauses_${modelname}_t${t}_d${d} --details ./models/dataset/${modelname}/details.csv"
#         ./src/learn-data.py --model ./models/${modelname}/${modelname}_t${t}_d${d}.json  --data ./models/dataset/${modelname}/train.csv --output ./output/learned-clauses_${modelname}_t${t}_d${d} --details ./models/dataset/${modelname}/details.csv --max_clauses 1500
#     done
#   done
# done


# modelnames=("spambase")
# depth=("5" "6")
# trees=("200" "300" "500")

# for modelname in "${modelnames[@]}"; do
#   for d in "${depth[@]}"; do
#     for t in "${trees[@]}"; do
#         echo "./src/learn-data.py --model ./models/${modelname}/${modelname}_t${t}_d${d}.json  --data ./models/dataset/${modelname}/train.csv --output ./output/learned-clauses_${modelname}_t${t}_d${d} --details ./models/dataset/${modelname}/details.csv"
#         ./src/learn-data.py --model ./models/${modelname}/${modelname}_t${t}_d${d}.json  --data ./models/dataset/${modelname}/train.csv --output ./output/learned-clauses_${modelname}_t${t}_d${d} --max_clauses 1500
#     done
#   done
# done