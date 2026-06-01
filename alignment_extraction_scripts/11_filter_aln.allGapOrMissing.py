#!/usr/bin/python

#PURPOSE: Remove sequences that are all missing data from fasta

import sys, os, argparse
from Bio import SeqIO
import numpy as np

############################################################
# Options
parser = argparse.ArgumentParser(description="Filter sequences that are only missing data from fasta");
parser.add_argument("-i", dest="input", help="Directory of alignments.", default=False);
parser.add_argument("-o", dest="output", help="Desired output directory for filtered alignment fastas.", default=False);
parser.add_argument("--overwrite", dest="overwrite", help="If the output directory already exists and you wish to overwrite it, set this option.", action="store_true", default=False);
parser.add_argument("--statsonly", dest="statsonly", help="Set this option to get alignment stats without performing the filtering.", action="store_true", default=False);
# IO options
args = parser.parse_args();

if not args.input or not os.path.isdir(args.input):
  sys.exit( " * Error 1: An input directory with aligned fasta sequences must be defined with -i.");
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

log_file = os.path.join(args.output, "aln-filter.log");

with open(log_file, "w") as logfile:
  logfile.write("####Filtering missing data from files in " + args.input + "\n");
  fa_files = [ f for f in os.listdir(args.input) if f.endswith(".fa") ];
  for f in fa_files:
    logfile.write("Working on alignment: " + f + "\n")
    short_name=f.strip().split(".")[0]
    if not args.statsonly:
      outfile=short_name + ".filterMissingSeqs.fa"
      outpath=os.path.join(args.output, outfile)
      logfile.write("Writing output to " + outpath + "\n")
    #records = list(SeqIO.parse("/ix1/nclark/ekopania/zoonomia_mammals_241/noncoding-region-alignment/chrY/chrYCNE1610450.fa", "fasta"))
    #records = list(SeqIO.parse("/ix1/nclark/ekopania/zoonomia_mammals_241/noncoding-region-alignment/chr1/chr1CNE100001.fa", "fasta"))
    records = list(SeqIO.parse(os.path.join(args.input, f), "fasta"))

    keep_sequences = []
    removed_sequences = []
    for r in records:
      if len(np.unique(r.seq)) == 1:
        if np.unique(r.seq) == "*":
          #print("Removing sequence " + r.id)
          removed_sequences.append(r)
        elif np.unique(r.seq) == "-":
          removed_sequences.append(r)
        elif np.unique(r.seq) == "N":
          removed_sequences.append(r)
        else:
          logfile.write("Sequence for " + r.id + "is weird; look at it manually\n")
      else:
        #print("Keeping sequence " + r.id)
        keep_sequences.append(r)
    
    logfile.write("Removed %i sequences because they were only missing data or gaps\n" % len(removed_sequences))
    logfile.write("Keeping %i sequences after filtering\n" % len(keep_sequences))
    
    if not args.statsonly:
      #Write to fasta
      SeqIO.write(keep_sequences, outpath, "fasta")

logfile.close()

