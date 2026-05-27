#PURPOSE: Translate nucleotide to amino acid alignments

#MODIFIED BY E. KOPANIA 11 MARCH 2026
#Past version used rphast msa.codon.clean, but this function removes all sequence after an early stop codon
#We want to translate early stop codons as stop codons but keep remaining sequence
#This version uses rphast strip.gaps.msa for gap stripping instead of msa.codon.clean

#Original script written by Justine Denby:/ihome/nclark/jjd108/summer_2025/for_pipeline_translate_alignments.r

library(rphast)

#Full path to directory containing nucleotide alignments in fasta format; must end with "/"
alnpath<-"/ix1/nclark/ekopania/zoonomia_mammals_241/CODING_REGIONS/coding_region_alignment_filtered-50percent-20bp/alignments/"

#write working directory -- this is where your translated alignments will be created
setwd("/ix1/nclark/ekopania/zoonomia_mammals_241/CODING_REGIONS/coding_region_alignment_filtered-50percent-20bp_translatedAA_keepEarlyStops/")

#this is a directory that has all of the gene files with each MSA within
genes <- list.files(alnpath)

#holds the skipped files due to alignments not being % 3
skipped_files <- character()
#holds the skipped files due to alignments being empty after gap stripping
empty_files <- character()

print(Sys.time())

#create two directories for the rphast pipeline -- one to hold all gene files before and after translation
dir.create("CODON", showWarnings = FALSE)
dir.create("AA", showWarnings = FALSE)


for (gene in genes) {
  print(paste0("gene currently running: ", gene))
  
  tryCatch({
#this try-catch checks the length of each alignment to ensure that they are a length of % 3 -- rphast throws an error if not
    msa <- read.msa(paste(alnpath, gene, sep=''), format="FASTA")
    #Use strip.gaps.msa instead of codon.clean.msa
    #The following command will remove gaps (-) from the Homo_sapiens sequence, and remove the corresponding columns from the rest of the alignment
    #DOES NOT do anything with early stop codons
    msa_stripped <- strip.gaps.msa(msa, c("Homo_sapiens"))
    
    msa_aa <- msa_stripped
    #Rphasts's translate.msa function will work, even if there are early stops
    #Missing data translated as "*" (i.e., NNN or NAG will both be translated as *)
    #Stop codons will be translated as "$" (both early stop codons and end of alignment)
    seqs_aa <- translate.msa(msa_stripped)
    seqs_aa <- gsub("\\*", "-", seqs_aa)
    seqs_aa <- gsub("\\$", "*", seqs_aa)
    msa_aa$seqs <- seqs_aa
    
    write.msa(msa_aa, paste0("AA/", gene))
    write.msa(msa_stripped, paste0("CODON/", gene))
    print("gene finished")
  }, error = function(e) {
    if (grepl("msa length \\(\\d+\\) not multiple of three after gap removal", e$message)) {
        warning(paste("Skipping file", gene, "due to length not being multiple of three after gap removal"))
        skipped_files <<- c(skipped_files, gene)
    } else if (grepl("frame should only contain values between 1 and ncol", e$message)) {
        warning(paste("Skipping file", gene, "because alignment is empty after gap removal"))
        empty_files <<- c(empty_files, gene)
    } else {
        stop(e)
    }
  })
}

#prints out if any of the files were skipped and which ones were
if ( (length(skipped_files) > 0) | (length(empty_files) > 0) ){
  cat("\nThe following files were skipped due to length not being multiple of three:\n")
  print(skipped_files)
  cat("\nThe following files were skipped due to cleaned alignments being empty:\n")
  print(empty_files)
} else {
  cat("\nAll files processed successfully.\n")
}

print(Sys.time())
