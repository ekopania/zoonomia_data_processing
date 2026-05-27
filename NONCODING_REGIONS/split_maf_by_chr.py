#!/usr/bin/python -u

#PURPOSE: Custom script to split MAF by chromosome - made in part by chatGTP!

import os, gzip

def split_maf_by_chromosome(maf_file, skip_chr):
    skipped=[]
    hum_chr=""
    #A boolean to keep track of whether or not we're working through a maf block we want to write
    write_bool=False
    #Not the cleanest way to do this, but there needs to be a starting file to avoid errors on the first loop iteration; I'll just delete this later
    chr_file = open('/ix1/nclark/ekopania/zoonomia_mammals_241/temp.maf', 'w')
    with gzip.open(maf_file, 'rb') as maf:
        for line in maf:
            #This is a python3 thing - reads line as bytes so need to decode to make it a string
            str_line=line.decode("utf-8") 
            if str_line[0]=='s':
                fields = str_line.split()
                spec = fields[1].split('.')[0]
                chromosome = fields[1].split('.')[1]  # Assuming chromosome names are in the format "chrX"
                #print(spec)
                #print(chromosome)
                #We want our chromosome and scaffold files to be based on the Homo sapiens reference
                #Also, Homo_sapiens is the reference in the maf, so this should indicate a new maf block
                if spec == "Homo_sapiens":
                    #Check if we've reached a new chromosome
                    if chromosome != hum_chr:
                        hum_chr=chromosome
                        #Make sure this new chromosome is NOT in the list of chromosomes we want to skip
                        if hum_chr not in skip_chr:
                            #Close the old chromosome file we've been working with (this is why the maf needs to be sorted)
                            chr_file.close()
                            #Change this boolean so that all downstream maf lines will be written until we reach a new Homo sapiens chr
                            write_bool=True
                            print(f"Starting file for {hum_chr}")
                            chr_file = open(f'/ix1/nclark/ekopania/zoonomia_mammals_241/zoonomia_mam241_{hum_chr}.maf', 'w')
                            #Some stuff to write at the top of each new maf before we start appending sequence lines
                            chr_file.write("##maf version=1 program=Bio++\n")
                            chr_file.write("#\n")
                            chr_file.write("a\n")
                            #Write this sequence line to the new maf
                            chr_file.write(str_line)
                        else:
                            #We've reached a chr we want to skip, so don't write any lines from the maf until we reach a new hum chr
                            write_bool=False
                            if hum_chr not in skipped:
                                skipped.append(hum_chr)
                                print(f"Skipping {hum_chr} because file exists")
                    #If we're here, we've reached a new maf block but not a new chromosome; write to open chromosome file
                    else:
                        if write_bool:
                            chr_file.write(str_line)
                #If we're here, we've reached a non-human line in the maf; write to open chromosome file
                else:
                    if write_bool:
                        chr_file.write(str_line)
            #If we're here, we are not on an 's' line; should be a blank line or 'a'; write to open chromosome file
            else:
                if write_bool:
                    chr_file.write(str_line)
                #else:
                    #for file in chromosome_files.values():
                    #    file.write(str_line)
    
    #for file in chromosome_files.values():
        #file.close()

# Example usage - MUST BE SORTED
maf_file = '/ix1/nclark/ekopania/zoonomia_mammals_241/241-mammalian-2020v2b.dupFiltered.maf.gz'
#skip_chr = 'chr1, chr10, chr11, chr12, chr13, chr14, chr15, chr16, chr17, chr18, chr19, chr2, chr20, chr21, chr22, chr3, chr4, chr5, chr6, chr7, chr8, chr9, chrX, chrY'
skip_chr = ''
split_maf_by_chromosome(maf_file, skip_chr)
