#!/bin/bash
#PURPOSE: Run Rscript for generating RER trees
#
# Job name:
#SBATCH --job-name=RERtrees
#SBATCH --output=RERtrees-%j.log
##SBATCH --output=RERtrees-%A-%a.log
##SBATCH --array=1-22 #job array to run chromosomes 1-22 in one job submission
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cluster=htc
##SBATCH --partition=<partition>
##SBATCH --nodelist=htc-n56
#SBATCH --constraint=amd,genoa
##SBATCH --mail-user=emk270@pitt.edu
##SBATCH --mail-type=ALL
#SBATCH --time=7-00:00:00 #Time limit 7 days
##SBATCH --qos=normal
#SBATCH --mem-per-cpu=6G
#
## Command(s) to run:
source activate ~/software/envs/rerconverge

#chr="chr${SLURM_ARRAY_TASK_ID}"
chr="chrScaffold"

Rscript 05_getRERtrees.r ${chr}

echo "Done!"
