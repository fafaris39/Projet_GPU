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
#Tools required for analysis
* FastQC (https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)
* DeepTools (https://deeptools.readthedocs.io/en/develop/)
* samtools (http://www.htslib.org/)
* bedtools (https://bedtools.readthedocs.io/en/latest/)
