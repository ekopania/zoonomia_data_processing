#!/bin/bash
#PURPOSE: Use mafTools mafDuplicateFilter to remove duplicates from Zoonomia maf
#https://github.com/ComparativeGenomicsToolkit/mafTools/tree/master/mafDuplicateFilter
#
# Job name:
#SBATCH --job-name=mafDuplicateFilter
#SBATCH --output=mafDuplicateFilter-%j.log
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cluster=htc
#SBATCH --mail-user=emk270@pitt.edu
#SBATCH --mail-type=ALL
#SBATCH --time=7-00:00:00 #Time limit 7 days
##SBATCH --qos=normal #DO NOT SET THIS otherwise the max time will be 3 days
#SBATCH --mem-per-cpu=64G
#
## Command(s) to run:

#echo "Uncompress gzipped maf..."
#gunzip 241-mammalian-2020v2b.maf.gz

echo "Beginning filtering..."
/ihome/nclark/emk270/software/mafTools/bin/mafDuplicateFilter --maf 241-mammalian-2020v2b.maf > 241-mammalian-2020v2b.dupFiltered.maf

echo "Done!"
