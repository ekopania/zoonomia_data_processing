#!/bin/bash
#PURPOSE: Run mafTools mafExtractor to extract CNE regions based on alignment to hg38
#https://github.com/ComparativeGenomicsToolkit/mafTools/tree/master/mafExtractor
#
# Job name:
#SBATCH --job-name=mafExtractor
#SBATCH --output=mafExtractor-%j.log
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cluster=htc
#SBATCH --mail-user=emk270@pitt.edu
#SBATCH --mail-type=ALL
#SBATCH --time=1-00:00:00 #Time limit 7 days
##SBATCH --qos=normal #DO NOT SET THIS otherwise the max time will be 3 days
#SBATCH --mem-per-cpu=64G
#
## Command(s) to run:

echo "Extracting region chr1CNE785..."
/ihome/nclark/emk270/software/mafTools/bin/mafExtractor --seq Homo_sapiens.chr1 --start 14694 --stop 14838 --maf 241-mammalian-2020v2b.dupFiltered.maf > chr1CNE785.maf
echo "Done!"

