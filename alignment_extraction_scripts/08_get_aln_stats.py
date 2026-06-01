#!/usr/bin/python
############################################################
# Gets gap and missing data stats for noncoding alignments
# Modified from Gregg Thomas's script for analyzing murine data
############################################################

import sys, os, argparse
from Bio.Seq import Seq

############################################################
# Functions

def fastaGetDict(i_name):
#fastaGetDict reads a FASTA file and returns a dictionary containing all sequences in the file with 
#the key:value format as title:sequence.

	seqdict = {};
	for line in open(i_name, "r"):
		line = line.replace("\n", "");
		if line[:1] == '>':
			curkey = line;
			seqdict[curkey] = "";
		else:
			seqdict[curkey] = seqdict[curkey] + line;

	return seqdict;


def countGaps(seqs):
# This function goes through every sequence in an alignment and calculates
# the average number of gaps (-).

    len_sum, num_seqs, num_gaps, all_gap = 0, 0, [], 0;
    for title in seqs:
        num_seqs += 1;
        full_len = len(seqs[title]);
        gap_len = len( [ base for base in seqs[title] if base == "-" ] );
        len_sum += gap_len;
        num_gaps.append(gap_len)
        if(gap_len == full_len):
            all_gap += 1;

#    return len_sum / num_seqs, sum(num_gaps)/len(num_gaps), all_gap;
    return sum(num_gaps)/len(num_gaps), all_gap;


def countMissing(seqs):
# This function goes through every sequence in an alignment and calculates
# the average number of sites with missing data (*).

    len_sum, num_seqs, num_missing, all_missing = 0, 0, [], 0;
    for title in seqs:
        num_seqs += 1;
        full_len = len(seqs[title]);
        missing_len = len( [ base for base in seqs[title] if base == "*" ] );
        len_sum += missing_len;
        num_missing.append(missing_len)
        if(missing_len == full_len):
            all_missing += 1;

    #return len_sum / num_seqs, sum(num_missing)/len(num_missing), all_missing;
    return sum(num_missing)/len(num_missing), all_missing;



def countUniqIdentSeqs(seqs):
# This function goes through every sequence in an alignment and counts how 
# many sequences are unique or identical.

    uniq_seqs, ident_seqs, found = 0, 0, [];
    seq_list = list(seqs.values());
    for seq in seq_list:
        if seq_list.count(seq) == 1:
            uniq_seqs += 1;
        if seq_list.count(seq) != 1 and seq not in found:
            ident_seqs += 1;
            found.append(seq);

    return uniq_seqs, ident_seqs;


def siteCount(seqs, aln_len):
# This function goes through every site in an alignment to check for invariant sites, gappy sites, 
# and stop codons.

    invar_sites, gap_sites, high_gap_sites20, high_gap_sites50, missing_sites, high_missing_sites20, high_missing_sites50 = 0, 0, 0, 0, 0, 0, 0;

    seq_list = list(seqs.values());
    #print(codon_seqs);
    for i in range(aln_len):
        site = [];
        for j in range(len(seq_list)):
            site.append(seq_list[j][i]);

        #print(site)
        if site.count(site[0]) == len(site):
            invar_sites += 1;


        num_gaps = site.count("-");
        #print(num_gaps)
        if num_gaps > 1:
            gap_sites += 1;

            #if 1 - (num_gaps / len(site)) > 0.2: #Not sure why Gregg subtracted from 1?
            if num_gaps / len(site) > 0.2:
                high_gap_sites20 += 1;
            if num_gaps / len(site) > 0.5:
                high_gap_sites50 += 1;

        num_missing = site.count("*");
        if num_missing > 1:
            missing_sites += 1;

            if num_missing / len(site) > 0.2:
                high_missing_sites20 += 1;
            if num_missing / len(site) > 0.5:
                high_missing_sites50 += 1;

    return invar_sites, gap_sites, high_gap_sites20, high_gap_sites50, missing_sites, high_missing_sites20, high_missing_sites50;


############################################################
# Options

parser = argparse.ArgumentParser(description="Codon alignment check filter");
parser.add_argument("-i", dest="input", help="Directory of alignments.", default=False);
parser.add_argument("-o", dest="output", help="Desired output directory for output stats.", default=False);
parser.add_argument("--overwrite", dest="overwrite", help="If the output directory already exists and you wish to overwrite it, set this option.", action="store_true", default=False);
# IO options
args = parser.parse_args();

if not args.input or not os.path.isdir(args.input):
    sys.exit( " * Error 1: An input directory with aligned CDS sequences must be defined with -i.");
args.input = os.path.abspath(args.input);

if not args.output:
    sys.exit( " * Error 2: An output directory must be defined with -o.");

args.output = os.path.abspath(args.output);
if args.output[-1] == "/":
    args.output = args.output[:-1];
if os.path.isdir(args.output) and not args.overwrite:
    sys.exit( " * Error 3: Output directory (-o) already exists! Explicity specify --overwrite to overwrite it.");

if not os.path.isdir(args.output):
    os.system("mkdir " + args.output);

log_file = os.path.join(args.output, "aln-stats.tab");
# Output file

with open(log_file, "w") as logfile:
    aln_headers = ["align", "num seqs", "aln length", "avg gap length", "num all gap", "avg missing length", "num all missing", "uniq seqs", "ident seqs", "invariant sites", "any gap sites", "20% gap sites", "50% gap sites", "any missing sites", "20% missing sites", "50% missing sites"];
    logfile.write(", ".join(aln_headers) + "\n");

    #sample_headers = ["sample"] + ["num alns", "num gappy"];

    #sample_stats = {};
    # The sample counts dict
    
    fa_files = [ f for f in os.listdir(args.input) if f.endswith(".fa") ];
    num_alns = len(fa_files);
    num_alns_str = str(num_alns);
    num_alns_len = len(num_alns_str);
    # Read align file names from input directory

    first_aln, counter, skipped = True, 0, 0;
    # Loop tracking variables

    for f in fa_files:
        if counter % 500 == 0:
            counter_str = str(counter);
            while len(counter_str) != num_alns_len:
                counter_str = "0" + counter_str;
        counter += 1;
        # Loop progress   

        #print(f);

        cur_out = { h : "NA" for h in aln_headers };
        cur_out["align"] = f;
        # Initialize the current output dictionary.

        cur_infile = os.path.join(args.input, f);
        # Get the current input file

        seqs_orig = fastaGetDict(cur_infile);
        seqs = { t : seqs_orig[t].upper() for t in seqs_orig };
        samples = list(seqs.keys());
        # Read the sequences

        num_seqs = len(seqs);

        cur_out["num seqs"] = str(num_seqs);
        # Count the number of samples in the alignment

        cur_out["aln length"] = len(seqs[samples[0]]);
        # Count the overall length of the alignment

        cur_out["avg gap length"], cur_out["num all gap"] = countGaps(seqs);

        cur_out["avg missing length"], cur_out["num all missing"] = countMissing(seqs);

        cur_out["uniq seqs"], cur_out["ident seqs"] = countUniqIdentSeqs(seqs);

        cur_out["invariant sites"], cur_out["any gap sites"], cur_out["20% gap sites"], cur_out["50% gap sites"], cur_out["any missing sites"], cur_out["20% missing sites"], cur_out["50% missing sites"]  = siteCount(seqs, cur_out["aln length"]);

        outline = [ str(cur_out[col]) for col in aln_headers ];
        logfile.write(", ".join(outline) + "\n");
