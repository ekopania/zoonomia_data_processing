#!/bin/bash
#PURPOSE: Commannds to run Elysia's getNonCodingAlignments.R script in parallel
#getNonCodingAlignments.R gets alignments for CNEs
#https://github.com/ECSaputra/alignment-extraction
#
# Job name:
#SBATCH --job-name=parallel_getNonCodingAlignments
#SBATCH --output=parallel_getNonCodingAlignments-%j.log
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cluster=htc
##SBATCH --partition=<partition>
##SBATCH --mail-user=emk270@pitt.edu
##SBATCH --mail-type=ALL
#SBATCH --time=1-00:00:00 #Time limit 1 day
#SBATCH --qos=normal
##SBATCH --mem-per-cpu=8G
#
## Command(s) to run:

parallel -j 50 < parallel_commands_getNonCodingAlignments.sh

echo "Done!"
