#!/bin/bash
#PURPOSE: Parse MAF into smaller chunks
#
# Job name:
#SBATCH --job-name=mafParse
##SBATCH --output=mafParse-%j.log
#SBATCH --output=mafParse-%A-%a.log
#SBATCH --array=1-22 #job array to run multiple chromosomes in one job submission
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cluster=htc
##SBATCH --partition=<partition>
##SBATCH --mail-user=emk270@pitt.edu
##SBATCH --mail-type=ALL
#SBATCH --time=2-00:00:00 #Time limit 2 days
#SBATCH --qos=normal
#SBATCH --mem-per-cpu=8G
#
## Command(s) to run:

module load phast/1.5

echo "Parsing..."

ls /ix1/nclark/ekopania/zoonomia_mammals_241/whole_chr_maf/zoonomia_mam241_chr${SLURM_ARRAY_TASK_ID}.maf | while read file; do
#ls /ix1/nclark/ekopania/zoonomia_mammals_241/whole_chr_maf/zoonomia_mam241_chrX.maf | while read file; do
	echo "Working on file ${file}"
	#gunzip "${file}"
	#newname=$(echo "${file}" | cut -d "." -f 1-3)
	splitname=$(echo "${file}" | cut -d "." -f 1)
	#maf_parse ${newname} --split 300000 --out-root ${splitname}_split
	maf_parse ${file} --split 300000 --out-root ${splitname}_split
	#gzip ${newname}
done

echo "Done!"
