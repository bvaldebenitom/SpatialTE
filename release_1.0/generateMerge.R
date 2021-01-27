TE_coverage_info.txt <- read.delim("TE_coverage_info.txt",header=TRUE,sep="\t")
TE_mapping_scores.txt <- read.delim("TE_mapping_scores.txt",header=TRUE,sep="\t")
nrow(TE_coverage_info.txt)
nrow(TE_mapping_scores.txt)
merged <- merge(TE_coverage_info.txt,TE_mapping_scores.txt,by.x="te_id")
nrow(merged)
write.table(merged,file="TE_coverage_mappingscores.txt",quote=FALSE,sep="\t",row.names=FALSE)
merged <- merged[order(-merged$tecoverage),]
merged$tecoverage <- merged$tecoverage*100
ms100 <- merged[which(merged$MS==100 & merged$nreads>=10 & merged$basescovered>=50),]
ms0 <- merged[which(merged$MS==0 & merged$nreads>=10 & merged$basescovered>=50),]
write.table(ms100,file="TE_coverage_mappingscore_ms100.txt",quote=FALSE,sep="\t",row.names=FALSE)
write.table(ms0,file="TE_coverage_mappingscore_ms0.txt",quote=FALSE,sep="\t",row.names=FALSE)
