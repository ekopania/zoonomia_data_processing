#!/bin/bash
#PURPOSE: Get alignment summary stats using AMAS
#https://github.com/marekborowiec/AMAS/tree/master
#
# Job name:
#SBATCH --job-name=amas_summary
#SBATCH --output=amas_summary-%j.log
##SBATCH --output=amas_summary-%A-%a.log
##SBATCH --array=1-22 #job array to run chromosomes 1-22 in one job submission
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cluster=htc
##SBATCH --partition=<partition>
##SBATCH --mail-user=emk270@pitt.edu
##SBATCH --mail-type=ALL
#SBATCH --time=1-00:00:00 #Time limit 1 days
#SBATCH --qos=normal
#SBATCH --mem-per-cpu=4G
#
## Command(s) to run:

chr="Y"

echo "Getting AMAS summary stats for all CNEs on chromosome ${chr}..."

python ~/software/AMAS/amas/AMAS.py summary --by-taxon -f fasta -d dna -i /ix1/nclark/shared_data/241mammals/noncoding-region-alignment-noNs/chr${chr}/*.fa -o /ix1/nclark/ekopania/zoonomia_mammals_241/amas_summary.chr${chr}.txt

echo "Done!"
