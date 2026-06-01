#!/bin/bash
#PURPOSE: Run Elysia's getGeneBoundaries.R script to get gene boundaries for CDS
#https://github.com/ECSaputra/alignment-extraction
#
# Job name:
#SBATCH --job-name=run_getGeneBoundaries
#SBATCH --output=run_getGeneBoundaries-%j.log
#SBATCH --mail-type=ALL # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=emily.kopania@genetics.utah.edu # Where to send mail
#SBATCH --cpus-per-task=1 # Number of cores per MPI rank (ie number of threads, I think)
#SBATCH --nodes=1 #Number of nodes
#SBATCH --ntasks=1 # Number of MPI ranks (ie number of processes, I think)
#SBATCH --mem-per-cpu=8G #Not sure if I should mess with these...
##SBATCH --time=1-0 #Set time limit to 7 days zero hours (overrides server default of 2 day limit)
# Partition:
#SBATCH --account=clarkn-rw
#SBATCH --partition=clarkn-shared-rw
#
## Command(s) to run:
module load R/4.1.1

Rscript ~/software/alignment-extraction/getGeneBoundaries.R -c chr1 -i CDS-coordinates/hg38.gencode.coding.chr1.distinct.gtf -o CDS-information/

echo "Done!"
