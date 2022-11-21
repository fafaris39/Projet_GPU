# Introduction of the project
The project consists of re-analyzing the ATAC-seq data produced in the Gomez-Cabrero et al. (2019) publication (__STATegra, a comprehensive multi-omics dataset of B-cell differentiation in mouse__ https://pubmed.ncbi.nlm.nih.gov/31672995/ ).The datasets was collected from ( https://www.ebi.ac.uk/ena ) by *Nadia Goué* with enaDataGet tool https://www.ebi.ac.uk/about/news/service-news/new-tools-download-data-ena.

The purpose of this project is to identify accessible chromatin regions, which are generally transciptionally active genes. For this reason, the analysis was conducted on a murine B3 cell line,This cell line from the mouse model the pre-B1 stage (or Hardy's fraction C'). After the nuclear translocation of the transcription factor Ikaros, those cells progress to the pre-BII stage (or Hardy's fraction D).During the pre-BII stage, B cell progenitors undergo a growth arrest and a differentiation. This B3 cell line was transduced by a retroviral pathway with a vector coding for a fusion protein, *Ikaros-REt2*, which enable to control nuclear levels of Ikaros after exposing to the Tamoxifen drug. After drug treatment, the cultures have been collected at t=0h and t=24h.

# Experimental Design
Cells collected for 0 and 24hours post-treatment with tamoxifen
3 biological replicates of ~50,000 cells

# Raw dataset
```
SRR4785152  50k-Rep1-0h-sample.0h   GSM2367179  0.7G
SRR4785153  50k-Rep2-0h-sample.0h   GSM2367180  0.7G
SRR4785154  50k-Rep3-0h-sample.0h   GSM2367181  0.7G

SRR4785341  50k-24h-R1-sample.24h.2 GSM2367368  0.6G
SRR4785342  50k-24h-R2-sample.24h.2 GSM2367369  0.7G
SRR4785343  50k-24h-R3-sample.24h.2 GSM2367370  0.6G
```
# Tools required for analysis
* FastQC (https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)
* Trimmomatic (https://github.com/usadellab/Trimmomatic)
* Bowtie2 (https://github.com/BenLangmead/bowtie2)
* Picard (https://github.com/broadinstitute/picard)
* DeepTools (https://deeptools.readthedocs.io/en/develop/)
* Macs2 (https://github.com/macs3-project/MACS/wiki/Install-macs2)
* Bedtools (https://bedtools.readthedocs.io/en/latest/)
* IGV (https://github.com/igvteam/igv)
# Workflow
## I. Initial Quality Control (`FastQC`)
The first step is to check the quality of the reads and the presence of the Nextera adapters at the end of those reads. We have assess the reads by executing the `atac_qc_init.slurm` script.

## II. Trimming (`Trimmomatic`)
As with all next generation sequencing data analyses, we checked the quality of the raw RNA-seq files with FastQC.Low quality bases, adapter sequences and short reads were trimmed with __Trimmomatic__.
The Nextera adapter sequences in below, was used by an Illumina sequencing.
```
>PrefixNX/1
AGATGTGTATAAGAGACAG
>PrefixNX/2
AGATGTGTATAAGAGACAG
>Trans1
TCGTCGGCAGCGTCAGATGTGTATAAGAGACAG
>Trans1_rc
CTGTCTCTTATACACATCTGACGCTGCCGACGA
>Trans2
GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAG
>Trans2_rc
CTGTCTCTTATACACATCTCCGAGCCCACGAGAC
```
The trimming can be done by executing the`atac_trim.slurm` script.

## III. Post Trimming Quality Control (`FastQC`)
Recheck the quality of trimmed reads to ensure trimming can be done with the `atac_qc_post.slurm` script.
## IV. Mapping (`Bowtie2`)
Next we map the trimmed reads to tthe mouse reference genome GRCm39. Here, we’ve combined two analysis steps. The first part aligns our trimmed data to the mouse reference genome GRCm39 using __Bowtie2__. The second part converts the output SAM format to BAM, and finally, the BAM files are sorted by coordinates.
This step can be done by executing the `atac_bowtie2.slurm` script.
## V. Remove Duplicates Reads (`Picard`)
Because of the PCR amplification, there might be read duplicates (different reads mapping to exactly the same genomic region) from overamplification of some regions. We will remove them with __Picard MarkDuplicates__. 
This can be performed by executing the `atac_bowtie2.slurm` script.
## VI. Data Exploration (`DeepTools`)
We use the __DeepTools__ to explore data. we will here make:
* PCAplot.  
* Two PlotCorrelation (heatmap,scatterplot) with two differents methods (spearman, pearson).
* PlotCoverage to assess the sequencing depth of each sample.
* bamPEFragmentSize to calculates the fragment sizes for read pairs given a BAM file from paired-end sequencing.

This step was performed by executing the `atac_deeptools.slurm` script.

## VII. Identification of dna accessibility sites (`Macs2`)
To find regions corresponding to potential open chromatin, we want to identify regions where reads have piled up (peaks) greater than the background read coverage. The tool which is used is __macs2__ .
This step can be done by executing the `atac_macs2.slurm`script.

## VIII. Identification of common and unique dna accessibility sites between conditions (`Bedtools`)
Next, we want to identify commons and uniques region between two cell stages. For this reason __bedtools intersect__ tool it used.
This was performed by executing the `atac_bedtools.slurm` script.

## IX. IVisualisation with IGV tool (`IGV`)
We use the __IGV__ tool to visualise peaks between conditions.

## Workflow file : atac_workflow.slurm
* Launching workflow file by executing the `atac_workflow.slurm` script in main directory.
* All output will be found in "$HOME"/results/atacseq.
