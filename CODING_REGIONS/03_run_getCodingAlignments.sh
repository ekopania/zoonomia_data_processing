#!/bin/bash
#PURPOSE: Run Elysia's getCodingAlignments.R script to get alignments for CDS
#https://github.com/ECSaputra/alignment-extraction
#
# Job name:
#SBATCH --job-name=run_getCodingAlignments
##SBATCH --output=run_getCodingAlignments-%j.log
#SBATCH --output=run_getCodingAlignments-%A-%a.log
#SBATCH --array=1-22 #job array to run chromosomes 1-22 in one job submission
#SBATCH --cpus-per-task=1 # Number of cores per MPI rank (ie number of threads, I think)
#SBATCH --nodes=1 #Number of nodes
#SBATCH --ntasks=1 # Number of MPI ranks (ie number of processes, I think)
#SBATCH --mem-per-cpu=20G #Not sure if I should mess with these...
#SBATCH --time=1-0 #Set time limit to 7 days zero hours (overrides server default of 2 day limit)
#
## Command(s) to run:
#rphast is installed in the conda environment
source activate ~/software/envs/python3.9_env/

#chr="chrX"
chr="chr${SLURM_ARRAY_TASK_ID}"

Rscript ~/software/alignment-extraction/getCodingAlignments.R -c ${chr} -r Homo_sapiens -i CDS-information/ -o /ix1/nclark/ekopania/zoonomia_mammals_241/CODING_REGIONS/coding_region_alignment/${chr}/ -a /ix1/nclark/ekopania/zoonomia_mammals_241/split_chr_maf/${chr}Split/ -p zoonomia_mam241_${chr}_split

echo "Done!"
