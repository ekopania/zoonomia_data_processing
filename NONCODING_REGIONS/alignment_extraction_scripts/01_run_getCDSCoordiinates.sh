#!/bin/bash
#PURPOSE: Run Elysia's getCDSCoordinates.R script to extract CDS coords from GTFParse 
#https://github.com/ECSaputra/alignment-extraction
#
# Job name:
#SBATCH --job-name=run_getCDSCoordinates
#SBATCH --output=run_getCDSCoordinates-%j.log
#SBATCH --mail-type=ALL # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=emily.kopania@genetics.utah.edu # Where to send mail
#SBATCH --cpus-per-task=1 # Number of cores per MPI rank (ie number of threads, I think)
#SBATCH --nodes=1 #Number of nodes
#SBATCH --ntasks=1 # Number of MPI ranks (ie number of processes, I think)
#SBATCH --mem-per-cpu=8G #Not sure if I should mess with these...
##SBATCH --time=1-0 #Set time limit to 7 days zero hours (overrides server default of 2 day limit)
# Partition:
#SBATCH --account=redwood-shared-short
#SBATCH --partition=redwood-shared-short
#
## Command(s) to run:
module load R/4.1.1

Rscript ~/software/alignment-extraction/getCDSCoordinates.R -i /uufs/chpc.utah.edu/common/HIPAA/proj_clarklab/kopania/RESOURCES/hg38_ref/gencode.v43.annotation.gtf -o CDS-coordinates/hg38.gencode.coding.chr1.gtf

echo "Done!"
