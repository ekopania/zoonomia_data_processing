#!/bin/bash
#PURPOSE: Run Elysia's getGeneBoundaries.R script to get gene boundaries for CDS
#https://github.com/ECSaputra/alignment-extraction
#
# Job name:
#SBATCH --job-name=run_getGeneBoundaries
##SBATCH --output=run_getGeneBoundaries-%j.log
#SBATCH --output=run_getGeneBoundaries-%A-%a.log
#SBATCH --array=1-22 #job array to run chromosomes 1-22 in one job submission
#SBATCH --cpus-per-task=1 # Number of cores per MPI rank (ie number of threads, I think)
#SBATCH --nodes=1 #Number of nodes
#SBATCH --ntasks=1 # Number of MPI ranks (ie number of processes, I think)
#SBATCH --mem-per-cpu=8G #Not sure if I should mess with these...
#SBATCH --time=1-0 #Set time limit to 7 days zero hours (overrides server default of 2 day limit)
#
## Command(s) to run:
module load gcc/12.2.0 r/4.4.0

#chr="chrX"
chr="chr${SLURM_ARRAY_TASK_ID}"

#Note: -i GTF MUST be split by chromosome prior to running this script!
Rscript ~/software/alignment-extraction/getGeneBoundaries.R -c ${chr} -i CDS-coordinates/hg38.gencode.coding.${chr}.gtf -o CDS-information/

echo "Done!"
