from z3 import *
import re
import random
from subprocess import check_output
import os

index = 1
incremental = {}
backwards = {}


def to_pseudo_boolean(expr, toplevel=False):
    if is_const(expr):  # A Boolean variable (e.g., x)
        global incremental
        if expr not in incremental.keys():
            global index
            global backwards
            incremental[expr] = f"x{index}"
            backwards[f"x{index}"] = expr
            index += 1
        if toplevel:
            return f"+1 {incremental[expr]} = 1"
        return f"{incremental[expr]}"
    elif is_eq(expr):
            if toplevel:
                # Use single '=' to match PB16/PBF format expected by PBEncoder
                return f"+1 {to_pseudo_boolean(expr.children()[0])} = {to_pseudo_boolean(expr.children()[1])} = 1"
            return f"{to_pseudo_boolean(expr.children()[0])} = {to_pseudo_boolean(expr.children()[1])}"
    elif is_not(expr):  # A negation (e.g., Not(x))
        assert len(expr.children()) == 1
        # PBEncoder expects negated variables to be written as x-<n>
        # so transform ~xN into x-<N> when possible.
        child = expr.children()[0]
        inner = to_pseudo_boolean(child, False)
        if inner.startswith("x"):
            negvar = "x-" + inner[1:]
            if toplevel:
                return f"+1 {negvar} = 1"
            return negvar
        else:
            # fallback: preserve old-style ~ prefix (may not be accepted by encoder)
            if toplevel:
                return f"+1 ~{inner} = 1"
            return f"~{inner}"
    elif is_or(expr):  # An OR clause (e.g., Or(x, y))
        # Check if any child is a PB constraint (not a simple boolean)
        children = expr.children()
        has_pb_child = any(
            is_app_of(c, Z3_OP_PB_GE) or 
            is_app_of(c, Z3_OP_PB_LE) or 
            is_app_of(c, Z3_OP_PB_EQ)
            for c in children
        )
        if has_pb_child:
            # Cannot directly encode OR of PB constraints in OPB format
            # This should have been handled by preprocessing/tseitin
            raise NotImplementedError(
                "OR of PB constraints found after tseitin-cnf. "
                "Use auxiliary variables to rewrite Or(PbGe(...), PbGe(...)) "
                "before conversion."
            )
        terms = [to_pseudo_boolean(child) for child in children]
        return "+1 " + " +1 ".join(terms) + " >= 1"
    elif is_and(expr):  # An AND clause (e.g., And(x, y))
        constraints = []
        for child in expr.children():
            constraints.append("+1 " + to_pseudo_boolean(child) + " >= 1")
        return "\n".join(constraints)
    elif (
        is_app_of(expr, Z3_OP_PB_GE)
        or is_app_of(expr, Z3_OP_PB_LE)
        or is_app_of(expr, Z3_OP_PB_EQ)
    ):
        # pdb.set_trace()
        terms = []
        coeffs = expr.params()[1:]  # Get the coefficients and variables
        for i, coeff in enumerate(coeffs):
            constant = coeff
            if is_app_of(expr, Z3_OP_PB_LE):
                constant = -constant
            variable = to_pseudo_boolean(expr.arg(i))  # Get the variable
            suffix = ""
            if constant > 0:
                suffix = "+"
            terms.append(f"{suffix}{constant} {variable}")
        rhs = expr.params()[0]  # The right-hand side of the >= constraint

        if is_app_of(expr, Z3_OP_PB_LE):
            rhs = -rhs
        rel_op = ">="
        if is_app_of(expr, Z3_OP_PB_EQ):
                # use single '=' for equality to match the encoder
                rel_op = "="
        return " ".join(terms) + f" {rel_op} {rhs}"
    elif is_app_of(expr, Z3_OP_PB_AT_MOST):
        terms = []

        for i in range(expr.num_args()):
            variable = to_pseudo_boolean(expr.arg(i))  # Get the variable
            terms.append(f"+1 {variable}")
        rhs = expr.params()[0]  # The right-hand side of the >= constraint
        rel_op = "<="
        return " ".join(terms) + f" {rel_op} {rhs}"
    else:
        pdb.set_trace()
        raise NotImplementedError(f"Unhandled expression type: {expr}")


import pdb


def convert(cons):
    pb_constraints = []
    t = Tactic("tseitin-cnf")
    for constraint in cons:
        try:
            cnfs = t(constraint)[0]
            for cnf in cnfs:
                pb_constraints.append(to_pseudo_boolean(cnf, True))
        except Exception as e:
            pdb.set_trace()
            print(e)
    # PBEncoder expects the comment header to use "#variable=" and "#constraint="
    # and the variable count should be the number of declared variables (index-1)
    header = f"* #variable= {index-1} #constraint= {len(pb_constraints)}\n"
    return header + ";\n".join(pb_constraints) + ";"


def dump_pb16(cons, filename, wf=1, comment=None):
    """
    Dump Z3 constraints to a PB16-style input file suitable for the Warners
    PB-to-SAT encoder.

    Parameters
    - cons: iterable of Z3 constraint expressions
    - filename: output file path (will be overwritten)
    - wf: weight-format hint (1 = unweighted, 2 = weighted). Written as a
          comment line in the header for human readers but the encoder has
          its own CLI switches.
    - comment: optional multi-line string to include as a commented block

    The function resets the internal var-numbering (`incremental`) so the
    generated variable names are compact (x1..xn) and writes a header and
    PB constraint lines following the PB16 example in the repo README.
    """
    print(cons)
    global index, incremental, backwards

    # Reset the variable numbering mapping so output is compact and stable
    index = 1
    incremental = {}
    backwards = {}

    pb_constraints = []
    t = Tactic("tseitin-cnf")
    for constraint in cons:
        try:
            cnfs = t(constraint)[0]
            for cnf in cnfs:
                pb_constraints.append(to_pseudo_boolean(cnf, True))
        except Exception as e:
            # Surface conversion errors with context
            raise RuntimeError(f"Conversion to PB failed for constraint: {e}") from e
    print("Backwards :")
    print(backwards)
    nvars = index - 1
    ncons = len(pb_constraints)

    # Write file following the example format
    with open(filename, "w", encoding="utf-8") as fh:
        fh.write(f"* #variable= {nvars} #constraint= {ncons}\n")
        fh.write("****************************************\n")
        fh.write("*\n")
        if comment:
            for line in comment.splitlines():
                fh.write(f"* {line}\n")
            fh.write("*\n")
        fh.write(f"* wf={wf}\n")
        fh.write("\n")

        for line in pb_constraints:
            # Ensure constraint line ends with a semicolon per PB16 example
            text = line.strip()
            # Remove any coefficient==0 terms (these are harmless and the Encoder
            # rejects them). We do this by tokenizing the line and dropping any
            # '<coef> <var>' pair where coef == 0.
            tokens = text.split()
            cleaned_tokens = []
            i = 0
            try:
                while i < len(tokens):
                    if tokens[i] in ['=', '>=', '<=']:
                        # copy the rest (relation and rhs)
                        cleaned_tokens.extend(tokens[i:])
                        break
                    coef = int(tokens[i])
                    var = tokens[i+1]
                    if coef != 0:
                        cleaned_tokens.append(str(coef))
                        cleaned_tokens.append(var)
                    # skip this pair regardless
                    i += 2
            except Exception:
                # If tokenization/parsing fails, fall back to original text
                cleaned_tokens = tokens

            new_text = " ".join(cleaned_tokens)
            if not new_text.endswith(";"):
                new_text = new_text + " ;"
            fh.write(new_text + "\n")

    return filename


class RoundingModel:
    def __init__(self):
        self.sat = False
        self.assign = {}

    def __bool__(self):
        return self.sat

    def __getitem__(self, i):
        return self.assign[i]


def roundingSolve(cons, soplex=False):
    filename = f"roundingtemp_{random.randint(0, 1000)}.opb"
    with open(filename, "w") as f:
        print(convert(cons), file=f)
    args = ["./roundingsat", filename, "--print-sol=1", "--verbosity=0"]
    if soplex:
        args[0] = "./roundingsatsoplex"
    roundingout = check_output(args)
    # os.remove(filename)
    resModel = RoundingModel()
    roundingout = str(roundingout, encoding="utf-8")

    if re.search(r"UNSATISFIABLE", roundingout):
        resModel.sat = False
        print("UNSATISFIABLE")
        return resModel
    else:
        resModel.sat = True

    solution = roundingout.split()[3:]
    for i in solution:
        if i[0] == "-":
            resModel.assign[backwards[i[1:]]] = False
        else:
            resModel.assign[backwards[i]] = True
    return resModel
