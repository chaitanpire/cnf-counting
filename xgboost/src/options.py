import argparse
import utils
import pandas as pd

class Options:
    def __init__(self):
        self.in_distro_clauses_file = ""
        self.data_file = ""
        self.model_file = ""
        self.modelName = ""
        self.modeltype = ""
        self.details_file = None
        self.output_file = ""
        self.output_csv_file = ""
        self.max_learned_clause_size = 3 # default value
        self.solver = "z3"
        self.data_limit = 10000
        self.max_splits = 100000
        self.gap = 0.2
        self.output_gap = None # [0.3,0.7]
        self.sureofcounter = False
        self.encoding = ""
        self.truelabel = -2
        self.otherlabel = -2
        self.multiclass = False
        self.verbosity = 0
        self.local_check_file = None
        self.local_check_samples = None
        self.timeout = 1200
        self.max_clauses = None
        
def arguments_to_options(args):
    options=Options()

    options.solver = args.solver
    if args.solver == "naive_z3":
        options.encoding = "allsum"
    else:
        options.encoding = "pb"

    if args.sure_counterexamples: options.sureofcounter = True
    options.verbosity              = args.verbosity
    options.in_distro_clauses_file = args.in_distro_clauses
    options.data_file              = args.data_file
    options.model_library          = args.model_library 
    options.output_gap             = args.output_gap
    options.local_check_file       = args.local_check_file
    options.timeout                = args.timeout
    options.max_trees              = args.max_trees

    if args.local_check_sample:
        options.local_check_samples    = [args.local_check_sample]
    
    if args.local_check_file:
        local_samples = pd.read_csv( args.local_check_file )
        samples = []
        for index, row in local_samples.iterrows():
            samples.append( row.tolist() )
        options.local_check_samples = samples
    
    if options.output_gap != None:
        options.lgap = options.output_gap[0]
        options.ugap = options.output_gap[1]
        # if options.model_library == "xgboost":
        #     options.lgap = utils.sigmoid_inv( options.output_gap[0] )
        #     options.ugap = utils.sigmoid_inv( options.output_gap[1] )
        # elif options.model_library == "rf":
        #     options.lgap = options.output_gap[0]-0.5
        #     options.ugap = options.output_gap[1]-0.5
        # else:
        #     print(f"Unsupported {options.model_library}")
        #     exit() 
    else:
        options.lgap = 0.5-args.gap
        options.ugap = 0.5+args.gap
    utils.dump_info( options, 5, f"Effective gap {options.lgap} and {options.ugap}")

    if args.multiclass:
        options.truelabel = (args.truelabel)  # -1 indicates take or else we have a represantitive class
        options.otherlabel = args.otherlabel
        options.multiclass = True
    else:
        options.truelabel = -2  # Binary
        options.otherlabel = -2
        options.multiclass = False
    return options

def process_arguments():
    parser = argparse.ArgumentParser(
        description="Find sensitivity on any single feature"
    )
    parser.add_argument(
        "filenum",
        help="An integer file number. (Look in utils.py for list of files) or a filename",
    )
    parser.add_argument(
        "--model_library", help="0:xgboost  1:lgbm 2:sklearn", type=str, default="xgboost"
    )

    parser.add_argument(
        "--truelabel", help="Label of true class, required", type=int, default=-1
    )
    parser.add_argument(
        "--otherlabel", help="Label of other class, required", type=int, default=-1
    )

    # Add the 'solver' argument with choices
    parser.add_argument(
        "--solver",
        choices=["z3", "naive_z3", "rounding", "roundingsoplex", "milp", "veritas"],
        help="The solver to use. Choose either 'z3' or 'rounding'.",
    )

    # Add the 'close' argument which is a boolean (true/false)
    parser.add_argument(
        "--close",
        type=lambda x: x.lower() in ("true", "1"),
        default=False,
        help="Close option, either 'true' or 'false'. Default is 'false'.",
    )
    parser.add_argument(
        "--max_trees",
        type=int,
        default=None,
        help="Maximum number of trees to consider",
    )
    parser.add_argument(
        "--max_classes",
        type=int,
        default=100,
        help="Maximum number of classes to consider",
    )
    # parser.add_argument(
    #     "--stop",
    #     action="store_true",
    #     help="whether to stop when the range of a node becomes less than a threshold",
    # )
    parser.add_argument(
        "--debug", action="store_true", help="Run serially and stop on pdb statements"
    )
    parser.add_argument(
        "--strong_multi", action="store_true", help="Strong multiclass checking"
    )
    parser.add_argument(
        "--no_strong_multi", action="store_true", help="Weak multiclass checking"
    )
    parser.add_argument(
        "--stop_param",
        type=float,
        default=0.1,
        help="Tunes how aggresssively we fold nodes",
    )
    parser.add_argument(
        "--all_single", action="store_true", help="run on all singular feature sets"
    )

    parser.add_argument(
        "--prob", action="store_true", help="Activate probability objective"
    )

    parser.add_argument(
        "--dump_opb",
        type=str,
        default=None,
        help="Write the generated PB constraints to an OPB file and exit",
    )

    parser.add_argument(
        "--dump_pb16",
        type=str,
        default=None,
        help="Write the generated PB constraints to a PB16 file (Warners encoder input) and exit",
    )

    parser.add_argument(
        "--projected_file",
        type=str,
        default=None,
        help="Write the projected variable ids (one per line) to this file when dumping PB/OPB",
    )

    parser.add_argument(
        "--timeout",
        type=int,
        default=1200,
        help="Timeout for each senstivity task",
    )
    
    parser.add_argument(
        "--lambda",
        type=int,
        default=100,
        help="Lambda for the objective function",
    )
    parser.add_argument(
        "--dataset",
        type=int,
        default=-1,
        help="dataset index",
    )

    parser.add_argument(
        "--all_features", action="store_true", help="Allow all features to change"
    )

    for feature in [
        "small_change",
        "ancestor_cons",
        "affected_cons",
        "unaffected_cons",
        "precise",
        "multiclass",
        "objective",
        "all_opt",
        "compute_data_distance",
    ]:
        parser.add_argument(f"--{feature}", action="store_true", default=False)
        parser.add_argument(f"--no-{feature}", dest="feature", action="store_false")

    parser.add_argument("--plot", action="store_true", help="plot the results")

    parser.add_argument(
        "--sure_counterexamples",
        action="store_true",
        help="Be sure about counterexamples and unsure about fairness",
    )
    parser.add_argument(
        "--gap", type=float, default=0.2, help="Gap for checking sensitivity"
    )

    
    parser.add_argument(
        "--output_gap",
        type=float,
        nargs="+",
        default=None,
        help="Give the expected gap in the probability of the model"
    )    
    
    parser.add_argument(
        "--precision", type=float, default=0, help="Scale for checking sensitivity"
    )
    parser.add_argument(
        "--k",
        type=int,
        default=None,
        help="Require exactly k differing split-bits between the two samples on the sensitive features",
    )
    parser.add_argument(
        "--features",
        type=int,
        nargs="+",
        default=None,
        help="Indexes of the features for which to do sensitivity analysis",
    )

    #local sensitivity argument added
    parser.add_argument(
        "--local_check_sample",
        type=float,
        nargs='+',
        default=None,
        help="input vector to check sensitivity in the vicinity"
    )

    #local sensitivity argument added
    parser.add_argument(
        "--local_check_file",
        type=str,
        default=None,
        help="File containing samples for which we need to run the tool",
    )

    #perturbation argument added
    parser.add_argument(
        "--perturb",
        type=float,
        default=0.1,
        help="maximum perturbation allowed for an insensitive variable"
    )

    parser.add_argument(
        "--details",
        type=str,
        default=None,
        help="File containing names of features and their bounds",
    )

    parser.add_argument(
        "--time",
        type=float,
        default=1e8,
        help="Stopping time (in seconds), only for veritas",
    )

    parser.add_argument(
        "--in_distro_clauses",
        type=str,
        default="",
        help="File containing clauses that encodes valid combinations in the seen data")

    parser.add_argument(
        "--data_file",
        type=str,
        default="",
        help="File containing data")

    parser.add_argument(
        "--verbosity",
        type=int,
        default=0,
        help="Sets the level of verbosity of the tool!",
    )
    
    # Parse the arguments
    args = parser.parse_args()
    if args.output_gap:
        if ( len(args.output_gap) != 2 or
             args.output_gap[0] >= 1 or args.output_gap[0] <= 0 or
             args.output_gap[1] >= 1 or args.output_gap[1] <= 0) :
            print("Incorrect inputs for output_gap option!")
            print("Expected: --output_gap <lgap> <ugap>")
            exit()
        if args.output_gap[1] < args.output_gap[0]:
            args.output_gap = [args.output_gap[1],args.output_gap[0]]
    
    if args.all_opt:
        args.objective = True
        args.unaffected_cons = True
        args.affected_cons = True
        args.ancestor_cons = True
        pass
    
    if args.solver == None:
        args.solver = "z3"
    options = arguments_to_options(args)
    
    return args,options
