#!/bin/bash

source $1

logfile=${experimentBasename}".log"

stpipeline_outdir=${experimentBasename}"_results"
mkdir $stpipeline_outdir
stpipeline_outdir=$(readlink -e $stpipeline_outdir)

stpipeline_tempdir=${experimentBasename}"_temp"
mkdir $stpipeline_tempdir
stpipeline_tempdir=$(readlink -e $stpipeline_tempdir)

cmd="st_pipeline_run.py --ids $barcodefile --temp-folder $stpipeline_tempdir --expName $experimentBasename --ref-map $STARindex --log-file $logfile --output-folder $stpipeline_outdir --ref-annotation $geneGTFannotation --no-clean-up --include-non-annotated --mapping-threads $threads --verbose $fastq1 $fastq2"
echo $cmd
eval $cmd

####PIPELINE START
samtools view --threads 8 -d XF:__no_feature -O BAM -o annotated_nofeature.bam annotated.bam

TE_bed="mm10_all_from_ucsc.bed"
TE_Cov="TE_coverage_info.txt"
TE_gtf="TE_with_reads.gtf"
TE_withreads_BAM="annotated_overlappingTE.bam"
TEannotated_BAM="annotated_overlappingTE_withXF.bam"
samtools view --threads 8 -O BAM -o $TE_withreads_BAM -L $TE_bed annotated_nofeature.bam
bedtools coverage -a $TE_bed -b $TE_withreads_BAM|awk 'BEGIN{FS=OFS="\t";print "chr","start","end","te_id","score","strand","nreads","basescovered","telength","tecoverage"}($NF>0){print $0}' > $TE_Cov
awk 'BEGIN{FS=OFS="\t"}{print $4}' TE_coverage_info.txt|grep -Ff - $TE_bed|awk 'BEGIN{FS=OFS="\t"}{print $1,".","exon",$2,$3,".",$6,".","gene_id \""$4"\""}' > $TE_gtf
python annotate_reads_with_TEs.py $TE_withreads_BAM $TEannotated_BAM $TE_gtf

TE_MS="TE_mapping_scores.txt"
echo -e "te_id\tuniquemappedreads\tmultimappedreads\tMS" > $TE_MS
samtools view $TEannotated_BAM|awk 'BEGIN{FS=OFS="\t"}{if($5!=255){$5=0};gsub("XF:Z:","",$NF);print $NF,$5}'|sort -t$'\t' -k1,1|bedtools groupby -i - -g 1 -c 2 -o freqdesc -delim $'\t'|awk 'BEGIN{FS=OFS="\t"}{uniquemap=0; multimap=0; if($2 ~ /255:/ && $3 ~ /0:/){uniquemap=$2;gsub("255:","",uniquemap); multimap=$3; gsub("0:","",multimap) }; if($2 ~ /0:/ && $3 ~ /255:/){multimap=$2;gsub("0:","",multimap); uniquemap=$3;gsub("255:","",uniquemap)}; if(NF==2){ if($2 ~ /255:/){ uniquemap=$2;gsub("255:","",uniquemap)} ; if($2 ~ /0:/){ multimap=$2;gsub("0:","",multimap)}  }; totalreads=uniquemap+multimap; score = uniquemap*100/totalreads;print $1,uniquemap,multimap,score}'|grep -v "ambiguous" >> $TE_MS

bedtools coverage -a $TE_bed -b $TEannotated_BAM -s|awk 'BEGIN{FS=OFS="\t";print "chr","start","end","te_id","score","strand","nreads","basescovered","telength","tecoverage"}($NF>0){print $0}' > $TE_Cov

#Generate merge in R
Rscript generateMerge.R

#Generate locus-specific results
awk 'BEGIN{FS=OFS="\t"}(NR>1){print $2,".","exon",$3,$4,".",$6,".","gene_id \""$1"\""}' TE_coverage_mappingscore_ms100.txt > tes_ms100.gtf
awk 'BEGIN{FS=OFS="\t"}(NR>1){print $1}' TE_coverage_mappingscore_ms100.txt > selected_TE_ids.txt
locusspecific_BAM="selected_TE_ms100.bam"
samtools view -O BAM -o $locusspecific_BAM -D XF:selected_TE_ids.txt -U notmatched.bam $TEannotated_BAM
python create_final_output.py selected_TE_ms100.bam tes_ms100.gtf TE_LOCUSSPECIFIC $(pwd)

#Generate sub-family results
subfamily_BAM="annotated_overlappingTE_withXF_MS0.bam"
awk 'BEGIN{FS=OFS="\t"}(NR>1){split($1,a,"\\|");print $2,".","exon",$3,$4,".",$6,".","gene_id \""a[4]"\""}' TE_coverage_mappingscore_ms0.txt > tes_ms0.gtf
python annotate_reads_with_TEs.py $TEannotated_BAM $subfamily_BAM tes_ms0.gtf
python create_final_output.py $subfamily_BAM tes_ms0.gtf TE_SUBFAMILYSPECIFIC $(pwd)

