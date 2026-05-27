#!/bin/bash
#PURPOSE: Replace asterisks with "N"
#PHAST msa_view introduced the asterisks as ambiguity characters when converting from maf to fasta but phangorn doesn't know what to do with them, so replace with "N" since these are ambiguity characters phangorn can handle
#Info on msa_view: http://compgen.cshl.edu/phast/help-pages/msa_view.txt
#
# Job name:
#SBATCH --job-name=replaceAsterisks
#SBATCH --output=replaceAsterisks-%j.log
##SBATCH --output=replaceAsterisks-%A-%a.log
##SBATCH --array=1-22 #job array to run chromosomes 1-22 in one job submission
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cluster=htc
##SBATCH --partition=<partition>
##SBATCH --mail-user=emk270@pitt.edu
##SBATCH --mail-type=ALL
#SBATCH --time=1-00:00:00 #Time limit 1 days
#SBATCH --qos=normal
#SBATCH --mem-per-cpu=2G
#
## Command(s) to run:

startdir="coding_region_alignment_filtered-50percent-20bp_translatedAA_keepEarlyStops/AA"
enddir="coding_region_alignment_filtered-50percent-20bp_translatedAA_keepEarlyStops_replaceAsterisk"

#cp -r ${startdir} ${enddir}

echo "Replacing asterisks with '-' for every fasta in ${enddir}"
for file in ${enddir}/AA/*fa; do
	sed -i 's/\*/-/g' ${file}
done

echo "Done!"
