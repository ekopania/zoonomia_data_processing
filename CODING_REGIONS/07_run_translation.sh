#!/bin/bash
#PURPOSE: Run Rscript to translate nucleotide alignments to aa using rphast 
#
# Job name:
#SBATCH --job-name=translate
#SBATCH --output=translate-%j.log
##SBATCH --output=translate-%A-%a.log
##SBATCH --array=1-22 #job array to run chromosomes 1-22 in one job submission
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cluster=htc
##SBATCH --partition=<partition>
##SBATCH --mail-user=emk270@pitt.edu
##SBATCH --mail-type=ALL
#SBATCH --time=1-00:00:00
##SBATCH --qos=normal
#SBATCH --mem-per-cpu=6G
#
## Command(s) to run:
source activate ~/software/envs/r4.3.3/

Rscript 08_translate_alignments.r

echo "Done!"
