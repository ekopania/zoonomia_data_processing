source("~/software/RERconverge/R/estimateTreeFuncs.R")
my_intree<-"/ix1/nclark/ekopania/zoonomia_mammals_241/241-mammalian-2020v2.phast-242.nh"

#
mylgtree<-estimatePhangornTreeAll(alndir="test_aln_bad", pattern="*.fa", treefile=my_intree, output.file="test_output_bad.tre", type="DNA", submodel="HKY")
#Processing test_aln_bad/chrXCNE1535382.filter.fa
#
#Phylogenetic tree with 147 tips and 145 internal nodes.
#
#Tip labels:
#  Nycticebus_coucang, Otolemur_garnettii, Daubentonia_madagascariensis, Propithecus_coquereli, Indri_indri, Che                                                              irogaleus_medius, ...
#Node labels:
#  fullTreeAnc238, fullTreeAnc114, fullTreeAnc112, fullTreeAnc110, fullTreeAnc79, fullTreeAnc70, ...
#
#Unrooted; includes branch lengths.
#147 sequences with 75 character and 75 different site patterns.
#The states are a c g t
#[1] "Completed pml"

mylgtree
#model: HKY+G(4)
#loglikelihood: -4363.682
#unconstrained loglikelihood: -323.8116
#Discrete gamma model
#Number of rate categories: 4
#Shape parameter: 1
#
#Rate matrix:
#  a c g t
#a 0 1 1 1
#c 1 0 1 1
#g 1 1 0 1
#t 1 1 1 0
#
#Base frequencies:
#   a    c    g    t
#0.25 0.25 0.25 0.25

mylgtree$tree
#
#Phylogenetic tree with 147 tips and 145 internal nodes.
#
#Tip labels:
#  Nycticebus_coucang, Otolemur_garnettii, Daubentonia_madagascariensis, Propithecus_coquereli, Indri_indri, Che                                                              irogaleus_medius, ...
#Node labels:
#  fullTreeAnc238, fullTreeAnc114, fullTreeAnc112, fullTreeAnc110, fullTreeAnc79, fullTreeAnc70, ...
#
#Unrooted; includes branch lengths.

mylgtree$data
#147 sequences with 75 character and 75 different site patterns.
#The states are a c g t

mylgtree$inv
#[1] 0

mylgtree$INV
#75 x 4 sparse Matrix of class "dgCMatrix"
#
# [1,] . . . .
# [2,] . . . .
# [3,] . . . .
# [4,] . . . .
# [5,] . . . .
# [6,] . . . .
# [7,] . . . .
# [8,] . . . .
# [9,] . . . .
#[10,] . . . .
#[11,] . . . .
#[12,] . . . .
#[13,] . . . .
#[14,] . . . .
#[15,] . . . .
#[16,] . . . .
#[17,] . . . .
#[18,] . . . .
#[19,] . . . .
#[20,] . . . .
#[21,] . . . .
#[22,] . . . .
#[23,] . . . .
#[24,] . . . .
#[25,] . . . .
#[26,] . . . .
#[27,] . . . .
#[28,] . . . .
#[29,] . . . .
#[30,] . . . .
#[31,] . . . .
#[32,] . . . .
#[33,] . . . .
#[34,] . . . .
#[35,] . . . .
#[36,] . . . .
#[37,] . . . .
#[38,] . . . .
#[39,] . . . .
#[40,] . . . .
#[41,] . . . .
#[42,] . . . .
#[43,] . . . .
#[44,] . . . .
#[45,] . . . .
#[46,] . . . .
#[47,] . . . .
#[48,] . . . .
#[49,] . . . .
#[50,] . . . .
#[51,] . . . .
#[52,] . . . .
#[53,] . . . .
#[54,] . . . .
#[55,] . . . .
#[56,] . . . .
#[57,] . . . .
#[58,] . . . .
#[59,] . . . .
#[60,] . . . .
#[61,] . . . .
#[62,] . . . .
#[63,] . . . .
#[64,] . . . .
#[65,] . . . .
#[66,] . . . .
#[67,] . . . .
#[68,] . . . .
#[69,] . . . .
#[70,] . . . .
#[71,] . . . .
#[72,] . . . .
#[73,] . . . .
#[74,] . . . .
#[75,] . . . .

weight <- as.double(attr(mylgtree$data, "weight"))
weight
# [1] 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
#[39] 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
tmp <- as.vector( mylgtree$INV %*% rep(1, attr(mylgtree$data, "nc")) )
tmp
# [1] 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
#[39] 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
ind <- which(tmp > 0)
ind
#integer(0)
max_inv <- sum(weight[ind]) / sum(weight)
max_inv
#[1] 0
