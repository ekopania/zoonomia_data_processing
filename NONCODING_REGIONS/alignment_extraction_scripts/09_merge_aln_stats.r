#PURPOSE: Merge alignment stats and plot histograms

#Read in alignmetn files
stats_files<-list.files(path="~/MAMMAL_DIGITS/alignment_extraction_scripts/aln_stats", pattern="aln-stats.tab", full.names=TRUE, recursive=TRUE)
print(stats_files)

#Merge alignment stats files across chromosomes
stats_header<-colnames(read.csv(stats_files[1], nrows=1))
all_stats<-c()
for(f in stats_files){
        stats<-read.csv(f)
        all_stats<-rbind(all_stats, stats)
}
#Clean up the alignment stats data frame
all_stats<-as.data.frame(all_stats)
colnames(all_stats)<-stats_header
all_stats$align<-unlist(sapply(all_stats$align, function(x) sub("\\.fa", "", x)))
all_stats$avg.gap.prop<-all_stats$avg.gap.length/all_stats$aln.length
all_stats$avg.missing.prop<-all_stats$avg.missing.length/all_stats$aln.length
all_stats$invariant.sites.prop<-all_stats$invariant.sites/all_stats$aln.length
print("Dimensions and head of all stats:")
print(dim(all_stats))
print(head(all_stats))

#Write merged file
write.table(all_stats, file="aln_stats_all.txt", row.names=FALSE, col.names=TRUE, sep="\t", quote=FALSE)

#Plot histograms
pdf("alignment_stats_histograms.pdf", onefile=TRUE)
hist(all_stats$num.seqs, xlab="Number of sequences")
hist(all_stats$aln.length, xlab="Alignment length", breaks=200)
hist(all_stats$num.all.gap, xlab="Number of samples that are all gap")
hist(all_stats$num.all.missing, xlab="Number of samples that are all missing data")
hist(all_stats$uniq.seqs, xlab="Number of unique sequences")
hist(all_stats$ident.seqs, xlab="Number of identical sequences")
hist(all_stats$avg.gap.prop, xlab="Average proportion of gaps across samples")
hist(all_stats$avg.missing.prop, xlab="Average proportion of sites that are missing across samples")
hist(all_stats$invariant.sites.prop, xlab="Proportion of sites that are invariant across all samples")
dev.off()

png("alignment_stats.avg_gap.png")
plot(sort(all_stats$avg.gap.prop), main="Average proportion of gaps across samples", xaxt='n')
dev.off()
png("alignment_stats.avg_missing.png")
plot(sort(all_stats$avg.missing.prop), main="Average proportion of sites that are missing across samples", xaxt='n')
dev.off()

png("alignment_stats.gapVSmissing.png")
plot(all_stats$avg.gap.prop, all_stats$avg.missing.prop, main="Average gap vs average missing proportion, by CNE")
dev.off()
cor.test(all_stats$avg.gap.prop, all_stats$avg.missing.prop, method="pearson")
cor.test(all_stats$avg.gap.prop, all_stats$avg.missing.prop, method="spearman")
