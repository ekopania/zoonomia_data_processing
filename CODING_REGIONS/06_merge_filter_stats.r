#PURPOSE: Merge alignment stats and plot histograms

perc<-"50"
len<-20

#Read in alignment files
stats_files<-list.files(path=paste0("/ix1/nclark/ekopania/zoonomia_mammals_241/CODING_REGIONS/coding_region_alignment_filtered-", perc, "percent-", len, "bp"), pattern="aln-filter.log", full.names=TRUE, recursive=TRUE)
#stats_files<-list.files(path=paste0("/ix1/nclark/ekopania/zoonomia_mammals_241/CODING_REGIONS/coding_region_alignment_filtered"), pattern="aln-filter.log", full.names=TRUE, recursive=TRUE)
print(stats_files)

#Merge alignment stats files across chromosomes
stats_header<-colnames(read.csv(stats_files[1], nrows=1, comment.char="#"))
all_stats<-c()
for(f in stats_files){
        stats<-read.csv(f, comment.char="#", strip.white=TRUE)
        all_stats<-rbind(all_stats, stats)
}
#Clean up the alignment stats data frame
all_stats<-as.data.frame(all_stats)
colnames(all_stats)<-stats_header
print("Dimensions of all alignment stats:")
print(dim(all_stats))
#Filter out alignments with no kept sequences
filt_stats<-all_stats[union(which(!(is.na(all_stats$avg.gap.length))), which(!(is.na(all_stats$avg.missing.length)))),]
print("Remaining alignments after filtering:")
print(dim(filt_stats))
filt_stats$avg.gap.prop<-filt_stats$avg.gap.length/filt_stats$aln.length
filt_stats$avg.missing.prop<-filt_stats$avg.missing.length/filt_stats$aln.length
print("Dimensions and head of alignment stats after filtering:")
print(dim(filt_stats))
print(head(filt_stats))

print("Number of genes with at least 10 species left:")
print(length(which(filt_stats$num.seqs >= 10)))

#Write merged file
write.table(filt_stats, file=paste0("aln_stats.filtered-", perc, "percent-", len, "bp.txt"), row.names=FALSE, col.names=TRUE, sep="\t", quote=FALSE)

#Plot histograms
pdf(paste0("alignment_stats_histograms.filtered-", perc, "percent-", len, "bp.pdf"), onefile=TRUE)
hist(filt_stats$num.seqs, xlab="Number of sequences")
hist(filt_stats$aln.length, xlab="Alignment length", breaks=200)
hist(filt_stats$avg.gap.prop, xlab="Average proportion of gaps across samples")
hist(filt_stats$avg.missing.prop, xlab="Average proportion of sites that are missing across samples")
dev.off()

png(paste0("alignment_stats.filtered-", perc, "percent-", len, "bp.avg_gap.png"))
plot(sort(filt_stats$avg.gap.prop), main="Average proportion of gaps across samples", xaxt='n')
dev.off()
png(paste0("alignment_stats.filtered-", perc, "percent-", len, "bp.avg_missing.png"))
plot(sort(filt_stats$avg.missing.prop), main="Average proportion of sites that are missing across samples", xaxt='n')
dev.off()

#png(paste0("alignment_stats.gapVSmissing.filtered-", perc, "percent-", len, "bp.png"))
#plot(filt_stats$avg.gap.prop, filt_stats$avg.missing.prop, main="Average gap vs average missing proportion, by gene")
#dev.off()
#cor.test(filt_stats$avg.gap.prop, filt_stats$avg.missing.prop, method="pearson")
#cor.test(filt_stats$avg.gap.prop, filt_stats$avg.missing.prop, method="spearman")
