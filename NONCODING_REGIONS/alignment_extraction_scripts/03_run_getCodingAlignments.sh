#!/bin/bash
#PURPOSE: Run Elysia's getCodingAlignments.R script to get alignments for CDS
#https://github.com/ECSaputra/alignment-extraction
#
# Job name:
#SBATCH --job-name=run_getCodingAlignments
#SBATCH --output=run_getCodingAlignments-%j.log
#SBATCH --mail-type=ALL # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=emily.kopania@genetics.utah.edu # Where to send mail
#SBATCH --cpus-per-task=1 # Number of cores per MPI rank (ie number of threads, I think)
#SBATCH --nodes=1 #Number of nodes
#SBATCH --ntasks=1 # Number of MPI ranks (ie number of processes, I think)
#SBATCH --mem-per-cpu=20G #Not sure if I should mess with these...
##SBATCH --time=1-0 #Set time limit to 7 days zero hours (overrides server default of 2 day limit)
# Partition:
#SBATCH --account=redwood-shared-short
#SBATCH --partition=redwood-shared-short
#
## Command(s) to run:
module load R/4.1.1

Rscript ~/software/alignment-extraction/getCodingAlignments.R -c chr1 -r Homo_sapiens -i CDS-information/ -o /scratch/general/pe-nfs1/kopania/zoonomia_alignments/coding-region-alignment/chr1/ -a /scratch/general/pe-nfs1/kopania/zoonomia_alignments/split_chr_maf/chr1Split/ -p zoonomia_mam241_chr1_split

echo "Done!"
