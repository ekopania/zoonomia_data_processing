#!/bin/bash
#PURPOSE: Run python script for getting alignment stats
#
# Job name:
#SBATCH --job-name=aln_stats
#SBATCH --output=aln_stats-%j.log
##SBATCH --output=aln_stats-%A-%a.log
##SBATCH --array=1-22 #job array to run multiple chromosomes in one job submission
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cluster=htc
##SBATCH --partition=<partition>
##SBATCH --mail-user=emk270@pitt.edu
##SBATCH --mail-type=ALL
#SBATCH --time=1-00:00:00
#SBATCH --qos=normal
#SBATCH --mem-per-cpu=8G
#
## Command(s) to run:

source activate ~/software/envs/biopython

#chr=${SLURM_ARRAY_TASK_ID}
chr="Scaffold"
#echo "Getting alignment stats for all noncoding alignments on chr${chr}"

python 08_get_aln_stats.py -i /ix1/nclark/ekopania/zoonomia_mammals_241/noncoding-region-alignment/chr${chr}/ -o aln_stats/chr${chr}/
#python 08_get_aln_stats.py -i /ix1/nclark/ekopania/zoonomia_mammals_241/noncoding-region-alignment-filtered/chr${chr}/ -o aln_stats_filtered/chr${chr}/

echo "Done!"
