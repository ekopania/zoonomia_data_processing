#PURPOSE: Merge alignment stats and plot histograms

perc<-"50"
len<-20

#Read in alignmetn files
stats_files<-list.files(path=paste0("/ix1/nclark/ekopania/zoonomia_mammals_241/noncoding-region-alignment-filtered-", perc, "percent-", len, "bp"), pattern="aln-filter.log", full.names=TRUE, recursive=TRUE)
print(stats_files)

#Merge alignment stats files across chromosomes
stats_header<-colnames(read.csv(stats_files[1], nrows=1, comment.char="#"))
all_stats<-c()
for(f in stats_files){
        stats<-read.csv(f, comment.char="#")
        all_stats<-rbind(all_stats, stats)
}
#Clean up the alignment stats data frame
all_stats<-as.data.frame(all_stats)
colnames(all_stats)<-stats_header
all_stats$avg.gap.prop<-all_stats$avg.gap.length/all_stats$aln.length
all_stats$avg.missing.prop<-all_stats$avg.missing.length/all_stats$aln.length
print("Dimensions and head of all stats:")
print(dim(all_stats))
print(head(all_stats))

print("Number of CNEs with at least 10 species left:")
print(length(which(all_stats$num.seqs >= 10)))

#Write merged file
write.table(all_stats, file=paste0("aln_stats_all.filtered-", perc, "percent-", len, "bp.txt"), row.names=FALSE, col.names=TRUE, sep="\t", quote=FALSE)

#Plot histograms
pdf(paste0("alignment_stats_histograms.filtered-", perc, "percent-", len, "bp.pdf"), onefile=TRUE)
hist(all_stats$num.seqs, xlab="Number of sequences")
hist(all_stats$aln.length, xlab="Alignment length", breaks=200)
hist(all_stats$avg.gap.prop, xlab="Average proportion of gaps across samples")
hist(all_stats$avg.missing.prop, xlab="Average proportion of sites that are missing across samples")
dev.off()

png(paste0("alignment_stats.filtered-", perc, "percent-", len, "bp.avg_gap.png"))
plot(sort(all_stats$avg.gap.prop), main="Average proportion of gaps across samples", xaxt='n')
dev.off()
png(paste0("alignment_stats.filtered-", perc, "percent-", len, "bp.avg_missing.png"))
plot(sort(all_stats$avg.missing.prop), main="Average proportion of sites that are missing across samples", xaxt='n')
dev.off()

png(paste0("alignment_stats.gapVSmissing.filtered-", perc, "percent-", len, "bp.png"))
plot(all_stats$avg.gap.prop, all_stats$avg.missing.prop, main="Average gap vs average missing proportion, by CNE")
dev.off()
cor.test(all_stats$avg.gap.prop, all_stats$avg.missing.prop, method="pearson")
cor.test(all_stats$avg.gap.prop, all_stats$avg.missing.prop, method="spearman")
