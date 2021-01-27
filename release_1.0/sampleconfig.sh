#All paths can be absolute or relative
#Path to barcode file 
barcodefile="1000L6_barcodes.txt"

#Path to STAR index with v2.7.6
STARindex="/path/to/mm10_STAR_2.7.6"
#Path to Gene annotation in GTF Format
geneGTFannotation="/path/to/mm10_refGene.gtf"
#Path to TE annotation in BED Format, following the specifications of SpatialTE
TE_bed="mm10_all_from_ucsc.bed"

#Path to Spatial Transcriptomics paired-end FASTQ files
fastq1="spatialtranscriptomics_1.fastq"
fastq2="spatialtranscriptomics__2.fastq"

#Threads to use in STAR and in Samtools
threads=8

#Basename for output directories (no whitespaces)
experimentBasename="experiment_name"
