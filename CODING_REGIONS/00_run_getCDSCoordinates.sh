#!/bin/bash
#PURPOSE: Run Elysia's getCDSCoordinates.R script to extract CDS coords from GTFParse 
#https://github.com/ECSaputra/alignment-extraction
#
# Job name:
#SBATCH --job-name=run_getCDSCoordinates
#SBATCH --output=run_getCDSCoordinates-%j.log
#SBATCH --cpus-per-task=1 # Number of cores per MPI rank (ie number of threads, I think)
#SBATCH --nodes=1 #Number of nodes
#SBATCH --ntasks=1 # Number of MPI ranks (ie number of processes, I think)
#SBATCH --mem-per-cpu=8G #Not sure if I should mess with these...
#SBATCH --time=1-0 #Set time limit to 7 days zero hours (overrides server default of 2 day limit)
#
## Command(s) to run:
module load gcc/12.2.0 r/4.4.0

Rscript ~/software/alignment-extraction/getCDSCoordinates.R -i /ix1/nclark/shared_data/GencodeAnnotations/gencode.v47.basic.annotation.gtf -o CDS-coordinates/hg38.gencode.coding.gtf

#TEST
#Rscript ~/software/alignment-extraction/getCDSCoordinates.R -i /ix1/nclark/shared_data/GencodeAnnotations/gencode.v47.basic.annotation.chrY.gtf -o CDS-coordinates/hg38.gencode.coding.chrYtest.gtf

echo "Done!"
