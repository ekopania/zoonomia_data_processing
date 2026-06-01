#!/bin/bash
#PURPOSE: Run python script to filter sequences based on percent gap or missing and total non-gap and non-missing length
#
# Job name:
#SBATCH --job-name=run_aln_filter
##SBATCH --output=run_aln_filter-%j.log
#SBATCH --output=run_aln_filter-%A-%a.log
#SBATCH --array=1-22 #job array to run chromosomes 1-22 in one job submission
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cluster=htc
##SBATCH --partition=<partition>
##SBATCH --mail-user=emk270@pitt.edu
##SBATCH --mail-type=ALL
#SBATCH --time=1-00:00:00
#SBATCH --qos=normal
#SBATCH --mem-per-cpu=6G
#
## Command(s) to run:
#module load python/ondemand-jupyter-python3.10
#module load python/anaconda2.7-5.2.0
#module load biopython/1.73
source activate ~/software/envs/biopython/

#chr="chrScaffold"
chr="chr${SLURM_ARRAY_TASK_ID}"

#GET STATS ONLY
#python 11_filter_aln.allGapOrMissing.py -i /ix1/nclark/ekopania/zoonomia_mammals_241/noncoding-region-alignment/${chr}/ -o /ix1/nclark/ekopania/zoonomia_mammals_241/noncoding-region-alignment-filtered/${chr}/ --statsonly

#FILTER OUT SEQUENCES THAT ARE ALL GAP OR ALL MISSING
#python 11_filter_aln.allGapOrMissing.py -i /ix1/nclark/ekopania/zoonomia_mammals_241/noncoding-region-alignment/${chr}/ -o /ix1/nclark/ekopania/zoonomia_mammals_241/noncoding-region-alignment-filtered/${chr}

#FILTER ON PERCENT GAP OR MISSING AND TOTAL NON-GAP AND NON-MISSING LENGTH
#For testing
#python 12_filter_aln.py  -i TEST_ALNS -o TEST_ALNS_FILTERED -p .2 -l 10 --statsonly

#Full run - 50% gap or missing threshold cutoff; min length 10bp
#python 12_filter_aln.py  -i /ix1/nclark/ekopania/zoonomia_mammals_241/noncoding-region-alignment-filtered/${chr} -o /ix1/nclark/ekopania/zoonomia_mammals_241/noncoding-region-alignment-filtered-50percent-10bp/${chr} -p .5 -l 10 --statsonly
#Full run - 20% gap or missing threshold cutoff; min length 10bp
#python 12_filter_aln.py  -i /ix1/nclark/ekopania/zoonomia_mammals_241/noncoding-region-alignment-filtered/${chr} -o /ix1/nclark/ekopania/zoonomia_mammals_241/noncoding-region-alignment-filtered-20percent-10bp/${chr} -p .2 -l 10 --statsonly
#Full run - 5% gap or missing threshold cutoff; min length 10bp
#python 12_filter_aln.py  -i /ix1/nclark/ekopania/zoonomia_mammals_241/noncoding-region-alignment-filtered/${chr} -o /ix1/nclark/ekopania/zoonomia_mammals_241/noncoding-region-alignment-filtered-05percent-10bp/${chr} -p .05 -l 10 --statsonly

#Full run - 50% gap or missing threshold cutoff; min length 20bp
python 12_filter_aln.py  -i /ix1/nclark/ekopania/zoonomia_mammals_241/noncoding-region-alignment-filtered/${chr} -o /ix1/nclark/ekopania/zoonomia_mammals_241/noncoding-region-alignment-filtered-50percent-20bp/${chr} -p .5 -l 20


echo "Done!"
