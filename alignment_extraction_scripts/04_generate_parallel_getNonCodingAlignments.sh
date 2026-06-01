#!/bin/bash
#PURPOSE: Run Elysia's getNonCodingAlignments.R script on a single file
#getNonCodingAlignments.R gets alignments for CNEs
#https://github.com/ECSaputra/alignment-extraction
#
# Job name:
#SBATCH --job-name=getNonCodingAlignments
#SBATCH --output=getNonCodingAlignments-%j.log
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

echo "#Commands to run getNonCodingAlignments.R for each chromosome or scaffold" > parallel_commands_getNonCodingAlignments.sh

ls -d /ix1/nclark/ekopania/zoonomia_mammals_241/split_chr_maf/*Split | while read dir; do
	chr=$(echo "${dir}" | cut -d "/" -f 7 | sed -e 's/Split//')
	echo "Generating command to get non-coding alignments for chromosome or scaffold ${chr}"

	mkdir /ix1/nclark/ekopania/zoonomia_mammals_241/noncoding-region-alignment/${chr}

	echo "Rscript ~/software/alignment-extraction/getNonCodingAlignments.R -c ${chr} -r Homo_sapiens -i ~/BED_BY_CHR/gerpElements_noexons_withNames_longCNEs_all.${chr}.bed -o /ix1/nclark/ekopania/zoonomia_mammals_241/noncoding-region-alignment/${chr}/ -a /ix1/nclark/ekopania/zoonomia_mammals_241/split_chr_maf/${chr}Split/ -p zoonomia_mam241_${chr}_split" >> parallel_commands_getNonCodingAlignments.sh
done

echo "Done!"
