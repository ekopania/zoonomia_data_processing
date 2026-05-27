#!/usr/bin/python

#PURPOSE: Filter sequences from fasta based on % gap or missing data; writes new fasta file if >=10 sequences remain after filtering

import sys, os, argparse
from Bio import SeqIO
import numpy as np

def countGapOrMissing(seq):
  #This function counts the number of gap or missing sites in a sequence
  #It returns the proportion of sites that are missing or gaps and the non-gap non-missing length
  
  full_len = len(seq);
  gap_len = len( [ base for base in seq if base == "-" ] );
  mis_len = len( [ base for base in seq if base == "*" ] ) + len( [ base for base in seq if base == "N" ] );
  gap_mis_sum = gap_len + mis_len;
  nonGapMissing_len = full_len - gap_mis_sum;
  return gap_mis_sum/full_len, nonGapMissing_len;

def countGaps(recs):
# This function goes through every sequence in an alignment and calculates
# the average number of gaps (-).

    len_sum, num_seqs, num_gaps, all_gap = 0, 0, [], 0;
    for r in recs:
        num_seqs += 1;
        full_len = len(r.seq);
        gap_len = len( [ base for base in r.seq if base == "-" ] );
        len_sum += gap_len;
        num_gaps.append(gap_len)
        if(gap_len == full_len):
            all_gap += 1;

    return sum(num_gaps)/len(num_gaps);

def countMissing(recs):
# This function goes through every sequence in an alignment and calculates
# the average number of sites with missing data (* or N).

    len_sum, num_seqs, num_missing, all_missing = 0, 0, [], 0;
    for r in recs:
        num_seqs += 1;
        full_len = len(r.seq);
        missing_len = len( [ base for base in r.seq if base == "*" ] ) + len( [ base for base in r.seq if base == "N" ] );
        len_sum += missing_len;
        num_missing.append(missing_len)
        if(missing_len == full_len):
            all_missing += 1;

    return sum(num_missing)/len(num_missing);



############################################################
# Options
parser = argparse.ArgumentParser(description="Filter sequences that are only missing data from fasta");
parser.add_argument("-i", dest="input", help="Directory of alignments.", default=False);
parser.add_argument("-o", dest="output", help="Desired output directory for filtered alignment fastas.", default=False);
parser.add_argument("-p", dest="percent_threshold", help="Threshold percent of gap or missing sites to use for filtering.", type=float, default=False);
parser.add_argument("-l", dest="len_threshold", help="Threshold length of non-gap and non-missing sites to use for filtering.", type=int, default=0);
parser.add_argument("--overwrite", dest="overwrite", help="If the output directory already exists and you wish to overwrite it, set this option.", action="store_true", default=False);
parser.add_argument("--statsonly", dest="statsonly", help="Set this option to get alignment stats without performing the filtering.", action="store_true", default=False);
# IO options
args = parser.parse_args();

if not args.input or not os.path.isdir(args.input):
  sys.exit( " * Error 1: An input directory with aligned fasta sequences must be defined with -i.");
args.input = os.path.abspath(args.input);

if not args.output:
  sys.exit( " * Error 2: An output directory must be defined with -o.");

if not args.percent_threshold:
  sys.exit( " * Error 3: A percent gap or missing site for filtering must be defined with -p.");

if args.len_threshold == 0:
  print( " * Warning: No minimum length of non-gap and non-missing characters provided; defaulting to 0 (i.e., all sequences will be included).");

args.output = os.path.abspath(args.output);
if args.output[-1] == "/":
  args.output = args.output[:-1];
if os.path.isdir(args.output) and not args.overwrite:
  sys.exit( " * Error 5: Output directory (-o) already exists! Explicity specify --overwrite to overwrite it.");

if not os.path.isdir(args.output):
  os.system("mkdir " + args.output);

log_file = os.path.join(args.output, "aln-filter.log");

with open(log_file, "w") as logfile:
  logfile.write("####Filtering missing data from files in " + args.input + "\n");
  aln_headers = ["align", "num seqs", "aln length", "avg gap length", "avg missing length"];
  logfile.write(", ".join(aln_headers) + "\n");

  fa_files = [ f for f in os.listdir(args.input) if f.endswith(".fa") ];
  for f in fa_files:
    #print("Working on alignment: " + f + "\n")
    short_name=f.strip().split(".")[0]
    records = list(SeqIO.parse(os.path.join(args.input, f), "fasta"))

    keep_sequences = []
    removed_sequences = []
    for r in records:
      prop_gm, len_nongm = countGapOrMissing(r.seq)
      if prop_gm >= args.percent_threshold:
        removed_sequences.append(r)
      elif len_nongm < args.len_threshold:
        removed_sequences.append(r)
      else:
        keep_sequences.append(r)

    #Append stats to log file
    cur_out = { h : "NA" for h in aln_headers };
    cur_out["align"] = short_name;
    num_seqs = len(keep_sequences);
    cur_out["num seqs"] = str(num_seqs);
    cur_out["aln length"] = len(r.seq);
    if len(keep_sequences) == 0:
        cur_out["avg gap length"] = "NA"
        cur_out["avg missing length"] = "NA"
    else:
        cur_out["avg gap length"] = countGaps(keep_sequences);
        cur_out["avg missing length"] = countMissing(keep_sequences);
    outline = [ str(cur_out[col]) for col in aln_headers ];
    logfile.write(", ".join(outline) + "\n");

    #logfile.write("Removed %i sequences because they did not pass filtering\n" % len(removed_sequences))
    #logfile.write("Keeping %i sequences after filtering\n" % len(keep_sequences))
    
    if not args.statsonly:
      if num_seqs >= 10:
        #Write to fasta
        outfile=short_name + ".filter.fa"
        outpath=os.path.join(args.output, outfile)
        #logfile.write("Writing output to " + outpath + "\n")
        SeqIO.write(keep_sequences, outpath, "fasta")

logfile.close()
