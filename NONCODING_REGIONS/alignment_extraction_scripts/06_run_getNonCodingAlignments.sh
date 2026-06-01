#!/bin/bash
#PURPOSE: Generate commannds to run Elysia's getNonCodingAlignments.R script in parallel
#getNonCodingAlignments.R gets alignments for CNEs
#https://github.com/ECSaputra/alignment-extraction
#
# Job name:
#SBATCH --job-name=getNonCodingAlignments
##SBATCH --output=getNonCodingAlignments-%j.log
#SBATCH --output=getNonCodingAlignments-%A-%a.log
#SBATCH --array=1-22 #job array to run multiple chromosomes in one job submission
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cluster=htc
##SBATCH --partition=<partition>
#SBATCH --mail-user=emk270@pitt.edu
#SBATCH --mail-type=ALL
#SBATCH --time=1-00:00:00 #Time limit 1 days
#SBATCH --qos=normal
##SBATCH --mem-per-cpu=8G
#
## Command(s) to run:

source activate ~/software/envs/python3.9_env/

#For longer chromosomes that were split into smaller mafs
#chr="chrY"
chr="chr${SLURM_ARRAY_TASK_ID}"
echo "Getting noncoding alignments for ${chr}"

mkdir /ix1/nclark/ekopania/zoonomia_mammals_241/noncoding-region-alignment/${chr}

Rscript ~/software/alignment-extraction/getNonCodingAlignments.R -c ${chr} -r Homo_sapiens -i ~/BED_BY_CHR/gerpElements_noexons_withNames_longCNEs_all.${chr}.bed -o /ix1/nclark/ekopania/zoonomia_mammals_241/noncoding-region-alignment/${chr}/ -a /ix1/nclark/ekopania/zoonomia_mammals_241/split_chr_maf/${chr}Split/ -p zoonomia_mam241_${chr}_split

##For shorter chromosomes that were not split
ls ~/BED_BY_CHR/*alt.bed ~/BED_BY_CHR/*random.bed ~/BED_BY_CHR/*v1.bed ~/BED_BY_CHR/*v2.bed | while read file; do
	chr=$(echo "${file}" | cut -d "." -f 2)
	echo "Getting noncoding alignments for ${chr}"

	mkdir /ix1/nclark/ekopania/zoonomia_mammals_241/noncoding-region-alignment/${chr}
#
#	#Temporarily copies the maf file to its own directory and unzips it so that getNonCodingAlignments.R can read it properly
	inmaf="/ix1/nclark/ekopania/zoonomia_mammals_241/whole_chr_maf/zoonomia_mam241_${chr}.maf"
#	mkdir /ix1/nclark/ekopania/zoonomia_mammals_241/${chr}Split
#	cp ${inmaf} /ix1/nclark/ekopania/zoonomia_mammals_241/${chr}Split
#	#gunzip /ix1/nclark/ekopania/zoonomia_mammals_241/${chr}Split/zoonomia_mam241_${chr}.noduplicates.maf.gz
#	#newname=$(echo "${inmaf}" | cut -d "/" -f 7 | cut -d "." -f 1)
#	mv /ix1/nclark/ekopania/zoonomia_mammals_241/${chr}Split/zoonomia_mam241_${chr}.maf /ix1/nclark/ekopania/zoonomia_mammals_241/${chr}Split/zoonomia_mam241_${chr}_split1.maf
#	Rscript ~/software/alignment-extraction/getNonCodingAlignments.R -c ${chr} -r Homo_sapiens -i ~/BED_BY_CHR/gerpElements_noexons_withNames_longCNEs_all.${chr}.bed -o /ix1/nclark/ekopania/zoonomia_mammals_241/noncoding-region-alignment/${chr}/ -a /ix1/nclark/ekopania/zoonomia_mammals_241/${chr}Split/ -p zoonomia_mam241_${chr}_split
#	#cleanup
#	rm /ix1/nclark/ekopania/zoonomia_mammals_241/${chr}Split/zoonomia_mam241_${chr}_split1.maf
#	rmdir /ix1/nclark/ekopania/zoonomia_mammals_241/${chr}Split
done

echo "Done!"
