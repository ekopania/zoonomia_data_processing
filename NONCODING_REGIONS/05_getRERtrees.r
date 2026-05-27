library(RERconverge)
#Use my edited function with varargs (...) to allow user specified levels and ambiguity characters
#Use my edited function that checks if alignment has any invariant sites and sets optInv=F if not
source("/ihome/nclark/emk270/software/RERconverge/R/estimateTreeFuncs.R")

#Read in chromosome alignment directory as a command line argument
args<-commandArgs(TRUE)
if (length(args)!=1) {
  stop("Enter a chromosome name on the command line")
}


#Alignment directory
#my_alndir<-paste0("/ix1/nclark/ekopania/zoonomia_mammals_241/noncoding-region-alignment-filtered-50percent-20bp/", args[1])
my_alndir<-paste0("/ix1/nclark/ekopania/zoonomia_mammals_241/noncoding-region-alignment/", args[1])
print(paste("Alignment directory:", my_alndir))

#Zoonomia 241 mammals species tree
my_intree<-"/ix1/nclark/ekopania/zoonomia_mammals_241/241-mammalian-2020v2.phast-242.nh"
print(paste("Species tree:", my_intree))

#Output file directory and prefix
my_output<-paste0("/ix1/nclark/ekopania/zoonomia_mammals_241/241mammals_trees_for_RERconverge_", args[1], "_HKY.tre")
print(paste("Output file:", my_output))

#Generate RER trees; track how long it takes
Sys.time()
#estimatePhangornTreeAll(alndir=my_alndir, treefile=my_intree, output.file=my_output, type='USER', levels=c("a","c","g","t","-"), ambiguity=c("n","*"), format="fasta")
estimatePhangornTreeAll(alndir=my_alndir, pattern="*.fa", treefile=my_intree, output.file=my_output, type="DNA", submodel="HKY")
Sys.time()
