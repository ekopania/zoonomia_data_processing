#!/bin/bash
#PURPOSE: Get alignment summary stats (trying to figure out how common early stops are)
#
# Job name:
#SBATCH --job-name=amasStats
#SBATCH --output=amasStats-%j.log
#SBATCH --cpus-per-task=1 # Number of cores per MPI rank (ie number of threads, I think)
#SBATCH --nodes=1 #Number of nodes
#SBATCH --ntasks=1 # Number of MPI ranks (ie number of processes, I think)
#SBATCH --mem-per-cpu=8G #Not sure if I should mess with these...
#SBATCH --time=1-0 #Set time limit to 7 days zero hours (overrides server default of 2 day limit)

#mkdir alignment_stats_50percent-20bp_translatedAA_keepEarlyStops
#ls coding_region_alignment_filtered-50percent-20bp_translatedAA_keepEarlyStops/AA/ | while read file; do
#	gene=$(echo "${file}" | cut -d "." -f 1)
#	echo "Working on ${gene}..."
#	python ~/software/AMAS/amas/AMAS.py summary -f fasta -d aa -o alignment_stats_50percent-20bp_translatedAA_keepEarlyStops/${gene}.summary.txt -i coding_region_alignment_filtered-50percent-20bp_translatedAA_keepEarlyStops/AA/${file}
#done

cat alignment_stats_50percent-20bp_translatedAA_keepEarlyStops/*.summary.txt | sort | uniq > alignment_stats_summary.50percent-20bp_translatedAA_keepEarlyStops.txt

echo "Done!"
