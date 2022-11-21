#! /bin/bash
#cd "$(dirname "$0")"


echo 'FARIS Fatima (Universite Clermont Auvergne, Mesocentre)'
echo 'Date: Fall Master course 2021'
echo 'Object: Sample case of ATACseq workflow showing job execution and dependency handling.'
echo 'Inputs: paths to scripts qc, trim and bowtie2, picard, macs2'
echo 'Outputs: trimmed fastq files, QC HTML files and BAM files, BED files,.tab files, .png files, (.narrowPeak, .xls, .r files)'

# Handling errors
#set -x # debug mode on
set -o errexit # ensure script will stop in case of ignored error
set -o nounset # force variable initialisation
#set -o verbose

IFS=$'\n\t'


echo "Launching Atac-seq Workflow" 
# first job - no dependencies
# Initial QC of raw data
jid1=$(sbatch --parsable /home/users/student11/atacseq/scripts/atac_qc_init.slurm)
echo "$jid1 : Initial Quality Control"

# Trimming
jid2=$(sbatch --parsable --dependency=afterok:$jid1 /home/users/student11/atacseq/scripts/atac_trim.slurm)
echo "$jid2 : Trimming with Trimmomatic tool"

# Post QC
jid3=$(sbatch --parsable --dependency=afterok:$jid2 /home/users/student11/atacseq/scripts/atac_qc_post.slurm)
echo "$jid3 : Post control_quality"

# Mapping
jid4=$(sbatch --parsable --dependency=afterok:$jid3 /home/users/student11/atacseq/scripts/atac_bowtie2.slurm)
echo "$jid4 : Mapping Using Bowtie2 "

# Removing Duplicates Reads
jid5=$(sbatch --parsable --dependency=afterok:$jid4 /home/users/student11/atacseq/scripts/atac_picard.slurm)
echo "$jid5 : Removing Duplicates Reads Using Picard"

# Data Exploitation
jid6=$(sbatch --parsable --dependency=afterok:$jid5 /home/users/student11/atacseq/scripts/atac_deeptools.slurm)
echo "$jid6 : Data exploration with deeptools"


# Identification of dna accessibility sites
jid7=$(sbatch --parsable --dependency=afterok:$jid6 /home/users/student11/atacseq/scripts/atac_macs2.slurm)
echo "$jid7 : Identification of dna accessibility sites using MACS2"

#  Identification of common and unique accessibility sites
jid8=$(sbatch --parsable --dependency=afterok:$jid7 /home/users/student11/atacseq/scripts/atac_bedtools.slurm)
echo "$jid8 : Identification of common and unique accessibility sites using BedTools"

#  Info on workflow
jid9=$(sbatch --parsable --dependency=afterok:$jid8 /home/users/student11/atacseq/scripts/atac_performance.slurm)
echo "$jid9 : Getting general info from worflow"

echo "Stop job : "`date` >&2
