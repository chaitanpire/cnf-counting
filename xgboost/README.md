# Installations
----------------

Installing python dependencies
```
pip install -r requirements.txt
```

# Running the docker image 
----------------------------

If there is difficulty in installing python dependencies. One may use docker to run our tool.

Give the following commands building the docker image.
```
$docker build -t sensitivity .
```


Give the following command to start the docker
```
$docker run -it sensitivity
```
This will take you to a command line interface. 

# Commands for running the tool
-------------------------------------

Sample commands:
```
python ./src/sensitive.py ./models/sbi/sbi-fraud.json --features 2 5
python ./src/sensitive.py ./models/sbi/sbi-fraud.json --features 2 5 --output_gap 0.2 0.8 --precision 400 --timeout 100
```
Sometimes the model does not have enough information such as names and the operating range for the feature. We need to give details file that may provide names of each feature and the operating range of the each feature.
```
python ./src/sensitive.py ./models/sbi/sbi-propensity.json --details ./models/sbi/sbi-propensity-info.csv --features 2 5
```

We can run our tool as a local sensitivity search tool also. It takes a list of sensitive feature (--features option), a point around which we search for the sensitivity (--local_check option), and perturbation upto which distance we search for the sensitivity (--perturb option).

```
python ./src/sensitive.py ./models/sbi/sbi-propensity.json --features 2 5 --local_check_sample 106000.0 343076.062 61.8049622 12741.0 0.302424997 43.0 -0.9999769999995 10.0 79182.2266 1.0079 30.0 9500.0 2.0 2.16968894 23.0 1.839926 10.0 0.666267991 0.965327024 --perturb 0.1
```

We may give the samples as inputs.

```
python ./src/sensitive.py ./models/sbi/sbi-propensity.json --features 2 5 --local_check_file ./models/sbi/sbi-propensity-random-data.csv --perturb 0.1 --output_gap 0.1 0.9
```


Data conformal senstivity checking
----------------------------------

Enable checking distance between the data and the sensitivity pair

```
python3 ./src/sensitive.py ./models/sbi/sbi-fraud.json --features 13 --output_gap 0.2 0.9 --data_file ./models/sbi/sbi-fraud-sample-data-3000.csv-cleaned.csv --compute_data_distance
```

Generating file that contains summary of patterns
```
./src/learn-data.py --model ./models/sbi/sbi-fraud.json --data ./models/sbi/sbi-fraud-sample-data-3000.csv-cleaned.csv --output ./outputs/learned-clauses-sbi-fraud.txt
```

Distribution aware search for sensitive pairs

```
python3 ./src/sensitive.py ./models/sbi/sbi-fraud.json --features 13 --gap 1.5 --data_file ./models/sbi/sbi-fraud-sample-data-3000.csv-cleaned.csv --compute_data_distance --in_distro_clauses ./outputs/learned-clauses-sbi-fraud.txt
```




# Detailed instructions for Running the tool 
--------------------------------------------

To run use the following command:
```
python ./src/sensitive.py <model file> --solver <solvername> --gap <int> --precision <int> --features 
```

Run 
```
python sensitive.py -h for help
```

# Options
```
positional arguments:
  filenum               An integer file number. (Look in utils.py for list of files) or a filename

options:
  -h, --help            show this help message and exit
  --model_library MODEL_LIBRARY
                        0:xgboost/lgbm, 1:sklearn
  --solver {z3,naive_z3,rounding,roundingsoplex,milp,veritas}
                        The solver to use. Choose either 'z3' or 'rounding'.
  --max_trees MAX_TREES
                        Maximum number of trees to consider
  --max_classes MAX_CLASSES
                        Maximum number of classes to consider
  --all_single          run on all singular feature sets
  --plot                plot the results
  --gap GAP             Gap for checking sensitivity
  --precision PRECISION
                        Scale for checking sensitivity
  --features FEATURES [FEATURES ...]
                        Indexes of the features for which to do sensitivity analysis
  --details DETAILS     File containing names of features and their bounds
  --time TIME           Stopping time (in seconds), only for veritas
  --precise             For MILP, get the precise answer
  --no-precise
  --perturb DISTANCE    Maximum perturbation allowed for an insenstive variable
  --local_check FEATURE_VALUES
                        Input vector to check sensitivity in the vicinity
  
  ==== Optimistations (default has all of them off) ====
  --all_opt             Set all of the optimisations to true

  --small_change
  --no-small_change
  --ancestor_cons
  --no-ancestor_cons
  --affected_cons
  --no-affected_cons
  --unaffected_cons
  --no-unaffected_cons
  --objective
  --no-objective

  ==== Multiclass Classification ====
  --multiclass
  --no-multiclass
  --truelabel TRUELABEL
                        Label of true class, required
  --otherlabel OTHERLABEL
                        Label of other class, required
  --strong_multi        Strong multiclass checking
  --no_strong_multi     Weak multiclass checking
```


# Installing roundingsat
----------------------

```
cd ./utils
./installrounding.sh
```


# Saving and loading the docker image 
---------------------------------------------
Saving image for sharing
```
docker save -o sensitivity.tar sensitivity:latest
```

Loading the docker image
```
docker load -i sensitivity.tar
```

# run for learning clause 
./src/learn-data.py --model ./models/tree_verification_models/ijcnn_robust_new/0060.resaved.json  --data ./models/tree_verification_models/ijcnn_robust_new/ijcnn_scale0_test.csv --output ./outputs/learned-clauses_ijcnn --details ./models/tree_verification_models/ijcnn_robust_new/ijcnn.details.csv --coverage_threshold 0.9

./src/learn-data.py --model ./models/tree_verification_models/breast_cancer_robust/0004.resaved.json  --data ./models/dataset/breast_cancer/breast_cancer_train.csv --output ./outputs/learned-clauses_breast_cancer --details ./models/dataset/breast_cancer/breast_cancer_details.csv --coverage_threshold 0.9

 ./src/learn-data.py --model ./models/tree_verification_models/diabetes_robust/0020.resaved.json  --data ./models/dataset/diabetes/diabetes_train.csv --output ./outputs/learned-clauses_diabetes. --details ./models/dataset/diabetes/diabetes_details.csv --coverage_threshold 0.9

  ./src/learn-data.py --model ./models/tree_verification_models/ijcnn_robust_new/0060.resaved.json  --data ./models/dataset/ijcnn/ijcnn_train.csv --output ./outputs/learned-clauses_ijcnn --details ./models/dataset/ijcnn/ijcnn_details.csv --coverage_threshold 0.9

  ./src/learn-data.py --model ./models/tree_verification_models/webspam_robust_new/0100.resaved.json  --data ./models/dataset/webspam/webspam_train.csv --output ./outputs/learned-clauses_webspam --details ./models/dataset/webspam/webspam_details.csv 

  ./src/learn-data.py --model ./models/tree_verification_models/higgs_robust/0300.resaved.json  --data ./models/dataset/higgs/higgs_train.csv --output ./outputs/learned-clauses_higgs_robust --details ./models/dataset/higgs/higgs_details.csv  --data_limit 100000 --coverage_threshold 0.9

  ./src/learn-data.py --model ./models/tree_verification_models/binary_mnist_robust/1000.resaved.json  --data ./models/dataset/binary_mnist/binary_mnist_train.csv --output ./outputs/learned-clauses_binary_mnist_robust --details ./models/dataset/binary_mnist/binary_mnist_details.csv  --data_limit 100000 


  ./src/learn-data.py --model ./models/tree_verification_models/binary_mnist_unrobust/1000.resaved.json  --data ./models/dataset/binary_mnist/binary_mnist_train.csv --output ./outputs/learned-clauses_binary_mnist_unrobust --details ./models/dataset/binary_mnist/binary_mnist_details.csv  --data_limit 100000 



./src/learn-data.py --model ./models/Pima_Diabetes_maxdepth_4.pkl  --data ./models/dataset/pima_diabetes/pima_diabetes_train.csv --output ./outputs/learned-clauses_pima_diabetes_unrobust --details ./models/dataset/pima_diabetes/pima_diabetes_details.csv  --data_limit 100000


python3 ./src/sensitive.py ./models/tree_verification_models/covtype_robust/0080.resaved.json --features 13 --gap 1.3 --data_file ./models/dataset/covtype/covtype_train.csv --compute_data_distance --solver z3 --multiclass  --truelabel 1  --otherlabel 0 --details ./models/dataset/covtype/covtype_details.csv

./src/learn-data.py --model ./models/tree_verification_models/covtype_robust/0080.resaved.json  --data ./models/dataset/covtype/covtype_train.csv --output ./outputs/learned-clauses_covtype_robust --details ./models/dataset/covtype/covtype_details.csv  --data_limit 100000

./src/learn-data.py --model ./models/tree_verification_models/fashion_robust/0200.resaved.json  --data ./models/dataset/fashion/fashion_train.csv --output ./outputs/learned-clauses_fashion_robust --details ./models/dataset/fashion/fashion_details.csv  --data_limit 100000

./src/learn-data.py --model ./models/tree_verification_models/fashion_unrobust/0200.resaved.json  --data ./models/dataset/fashion/fashion_train.csv --output ./outputs/learned-clauses_fashion_unrobust --details ./models/dataset/fashion/fashion_details.csv  --data_limit 100000

./src/learn-data.py --model ./models/tree_verification_models/cod-rna_robust/0080.resaved.json  --data ./models/dataset/cod-rna/cod-rna_train.csv --output ./outputs/learned-clauses_cod-rna_robust --details ./models/dataset/cod-rna/cod-rna_details.csv  --data_limit 100000

./src/learn-data.py --model ./models/tree_verification_models/ori_mnist_unrobust/0200.resaved.json  --data ./models/dataset/ori_mnist/ori_mnist_train.csv --output ./outputs/learned-clauses_ori_mnist_unrobust --details ./models/dataset/ori_mnist/ori_mnist_details.csv  --data_limit 10000

./src/learn-data.py --model ./src/model_3vs8.pkl  --data ./src/mnist3v8.csv --output ./outputs/learned-clauses_mnist3v8 --details ./models/dataset/binary_mnist/binary_mnist_details.csv  --data_limit 10000

./src/learn-data.py --model ./models/adult/adult_t200_d5.json  --data ./models/dataset/adult/train.csv --output ./outputs/learned-clauses_adult_t200_d5.txt