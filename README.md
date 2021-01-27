# SpatialTE

SpatialTE README

## 0. DEPENDENCIES

SpatialTE requires the following tools to be installed:

ST Pipeline v1.7.9 (https://github.com/SpatialTranscriptomicsResearch/st_pipeline)
Samtools v1.11 (http://www.htslib.org/download/)
BEDTools v2.29.2 (https://github.com/arq5x/bedtools2/releases)
R v4 or higher (https://www.r-project.org/)

Also, Python3.8 or higher should be available in your computer.

Once downloaded, make sure to grant SpatialTE execution permissions
```
chmod u+x spatialte_v1.0/*
```

Afterwards, add the SpatialTE directory to your PATH:
```
export PATH=$PATH:/path/to/spatialte
```

## 1. SETTING UP NECESSARY FILES

If you have not run the ST Pipeline before, you need to generate an index with STAR (version 2.7.6 or higher recommended).
For this, I strongly suggest to download the genome FASTA and its corresponding annotation files from UCSC(https://genome.ucsc.edu/).

Additionally, RepeatMasker files (\*rm.out) can also be found at the UCSC webpage. A conversion utility between RepeatMasker out file and SpatialTE input TE annotation is also provided.
It can be run like this:
```
convertRMOut_to_SpatialTEinput.sh RepeatMaskerOutfile NameForNewTEFil

```
If you have your own RepeatMasker file and/or a file corresponding to Transposable Elements obtained from another tool, make sure to adapt it to the following format for SpatialTE:
```
sequenceName	startPosition	endPosition	sequenceName|startPosition|endPosition|TE_Subfamily:TE_Family:TE_Class|strand	score(optional)	.
```

So, column 4, the ID, is a concatenation of the locus of the TE and its identifiers at the Subfamily, Family and Class level. The file should look like this:
```
chr1	3000001	3002128	chr1|3000001|3002128|L1_Mus3:L1:LINE|-	12955	-
chr1	3003153	3003994	chr1|3003153|3003994|L1Md_F:L1:LINE|-	1216	-
chr1	3003994	3004054	chr1|3003994|3004054|L1_Mus3:L1:LINE|-	234	-
chr1	3004041	3004206	chr1|3004041|3004206|L1_Rod:L1:LINE|+	3685	+
```

Finally, you need to setup the configuration file (the following sample configuration file is also provided):
```
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
```

## 2. RUNNING SPATIALTE

Once everything is set up, you can run the SpatialTE script with the configuration file:
```
spatialte_v1.0.sh configuration.sh

