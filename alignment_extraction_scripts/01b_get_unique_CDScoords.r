#PUROSE: Some CDS coordinates are in the hg38 gtf multiple times (I think this happens when exons are in multiple genes, for examaple). This script changes gets only the distinct rows from the gtf output by Elysia's script for downstream analyses

library(dplyr)
#Chromosome or scaffold name
myChr<-"chr1"

myGTF<-read.table(paste("CDS-coordinates/hg38.gencode.coding",myChr,"gtf", sep="."))

distinctGTF<-distinct(myGTF)

write.table(distinctGTF, file=paste("CDS-coordinates/hg38.gencode.coding",myChr,"distinct.gtf", sep="."), sep="\t", quote=FALSE, col.names=FALSE, row.names=FALSE)
