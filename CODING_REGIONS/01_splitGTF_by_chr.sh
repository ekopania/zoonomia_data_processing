#!/bin/bash
#PURPOSE: Split GTF by chromosome; Elysia's scripts assume GTFs are split and will try to assign all genes in the GTF to the input chromosome 
#
# Job name:
#SBATCH --job-name=splitGTFbyChr
#SBATCH --output=splitGTFbyChr-%j.log
#SBATCH --cpus-per-task=1 # Number of cores per MPI rank (ie number of threads, I think)
#SBATCH --nodes=1 #Number of nodes
#SBATCH --ntasks=1 # Number of MPI ranks (ie number of processes, I think)
#SBATCH --mem-per-cpu=8G #Not sure if I should mess with these...
#SBATCH --time=1-0 #Set time limit to 7 days zero hours (overrides server default of 2 day limit)
#
## Command(s) to run:

all_chrs=$(awk '{print $1}' CDS-coordinates/hg38.gencode.coding.gtf | uniq)
chr_array=($all_chrs)
for chr in "${chr_array[@]}"; do 
	echo "Working on ${chr}..."
	#Use -P and \t to get the exact chr only (i.e., just chr2 and not chr2, chr20, chr21, chr22)
	grep -P "${chr}\t" CDS-coordinates/hg38.gencode.coding.gtf > CDS-coordinates/hg38.gencode.coding.${chr}.gtf
done

echo "Done!"
