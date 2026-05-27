#!/bin/bash
#PURPOSE: Run python script to filter sequences based on percent gap or missing and total non-gap and non-missing length
#
# Job name:
#SBATCH --job-name=run_aln_filter
#SBATCH --output=run_aln_filter-%j.log
##SBATCH --output=run_aln_filter-%A-%a.log
##SBATCH --array=1-22 #job array to run chromosomes 1-22 in one job submission
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cluster=htc
##SBATCH --partition=<partition>
##SBATCH --mail-user=emk270@pitt.edu
##SBATCH --mail-type=ALL
#SBATCH --time=1-00:00:00
##SBATCH --qos=normal
#SBATCH --mem-per-cpu=6G
#
## Command(s) to run:
#module load python/ondemand-jupyter-python3.10
#module load python/anaconda2.7-5.2.0
#module load biopython/1.73
source activate ~/software/envs/biopython/

chr="chr17"
#chr="chr${SLURM_ARRAY_TASK_ID}"

#GET STATS ONLY

# 0% gap or missing threshold cutoff; min length 1bp (i.e., get stats for full alignments w/o filtering)
# I wrote it to filter out everything with proportion gap or missing > -p, so setting p > 1 means nothing will get filtered out based on percent gap or missing
# Also has to have a length of zero to nclude everything because this is the non-gap and non-missing length
#python 05_filter_aln.py -i /ix1/nclark/ekopania/zoonomia_mammals_241/CODING_REGIONS/coding_region_alignment/${chr} -o /ix1/nclark/ekopania/zoonomia_mammals_241/CODING_REGIONS/coding_region_alignment_filtered-0percent-0bp/${chr} -p 2 -l 0 --statsonly

# 100% gap or missing threshold cutoff; min length 1bp (i.e., just get stats for seqs that are all missing or gap)
#python 05_filter_aln.py  -i /ix1/nclark/ekopania/zoonomia_mammals_241/CODING_REGIONS/coding_region_alignment/${chr} -o /ix1/nclark/ekopania/zoonomia_mammals_241/CODING_REGIONS/coding_region_alignment_filtered-100percent-1bp/${chr} -p 1 -l 1 --statsonly

#FILTER

#Full run - 50% gap or missing threshold cutoff; min length 20bp
python 05_filter_aln.py  -i /ix1/nclark/ekopania/zoonomia_mammals_241/CODING_REGIONS/coding_region_alignment/${chr} -o /ix1/nclark/ekopania/zoonomia_mammals_241/CODING_REGIONS/coding_region_alignment_filtered-50percent-20bp/${chr} -p .5 -l 20


####OLD need to update with new script names

#FILTER OUT SEQUENCES THAT ARE ALL GAP OR ALL MISSING
#python 05_filter_aln.allGapOrMissing.py -i /ix1/nclark/ekopania/zoonomia_mammals_241/CODING_REGIONS/coding_region_alignment/${chr}/ -o /ix1/nclark/ekopania/zoonomia_mammals_241/CODING_REGIONS/coding_region_alignment_filtered/${chr}

#FILTER ON PERCENT GAP OR MISSING AND TOTAL NON-GAP AND NON-MISSING LENGTH

#Full run - 50% gap or missing threshold cutoff; min length 10bp
#python 06_filter_aln.py  -i /ix1/nclark/ekopania/zoonomia_mammals_241/CODING_REGIONS/coding_region_alignment_filtered/${chr} -o /ix1/nclark/ekopania/zoonomia_mammals_241/CODING_REGIONS/coding_region_alignment_filtered-50percent-10bp/${chr} -p .5 -l 10 --statsonly
#Full run - 20% gap or missing threshold cutoff; min length 10bp
#python 06_filter_aln.py  -i /ix1/nclark/ekopania/zoonomia_mammals_241/CODING_REGIONS/coding_region_alignment_filtered/${chr} -o /ix1/nclark/ekopania/zoonomia_mammals_241/CODING_REGIONS/coding_region_alignment_filtered-20percent-10bp/${chr} -p .2 -l 10 --statsonly
#Full run - 5% gap or missing threshold cutoff; min length 10bp
#python 06_filter_aln.py  -i /ix1/nclark/ekopania/zoonomia_mammals_241/CODING_REGIONS/coding_region_alignment_filtered/${chr} -o /ix1/nclark/ekopania/zoonomia_mammals_241/CODING_REGIONS/coding_region_alignment_filtered-05percent-10bp/${chr} -p .05 -l 10 --statsonly

echo "Done!"
