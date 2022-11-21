#!/bin/bash
#SBATCH --time=0:40:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=12G
#SBATCH --cpus-per-task=6   # Nb of threads we want to run on
#SBATCH -o atacseq/log/slurmjob-%A-%a
#SBATCH --job-name=bedtools
#SBATCH --partition=short
#SBATCH --array=0-2

 Program configuration
__author__='Fatima FARIS'
__email__='Fatima.FARIS@etu.uca.fr'
__credits__=['Fatima FARIS']
__license__='GPL3'
__maintainer__='Fatima FARIS'
__status__='Development'
__version__='0.0.1'


echo "Identification les sites d'accessibilité"

# Handling errors
#set -x # debug mode on
set -o errexit # ensure script will stop in case of ignored error
set -o nounset # force variable initialisation
#set -o verbose
#set -euo pipefail
module purge
module load gcc/4.8.4 bedtools/2.27.1

echo "Set up directories ..." >&2

OUTPUT="$HOME"/atacseq/results/bedTools
mkdir -p "$OUTPUT"

#Set up data directory
DATA_DIR="$HOME"/atacseq/results/macs2

echo "Collect BAM files from macs2..." >&2
tab_24h=($(ls "$DATA_DIR"/*24h*_mapped_*.narrowPeak))
echo "tab_24h = " >&2
printf '%s\n' "${tab_24h[@]}" >&2


tab_0h=($(ls "$DATA_DIR"/*0h*_mapped_*.narrowPeak))
echo "tab_0h = " >&2
printf '%s\n' "${tab_0h[@]}" >&2

# Current filename
SHORTNAME=$(basename "${tab_24h[$SLURM_ARRAY_TASK_ID]}" .bed )

echo "merge all files from each confition, we will compare peak between two condition 0h and 24h..." >&2
cat "${tab_0h[@]}" > "$OUTPUT"/ss_50k_0h_trim_mapped_sorted_q2_nodup_merged_peaks.narrowPeak
cat "${tab_24h[@]}" > "$OUTPUT"/ss_50k_24h_trim_mapped_sorted_q2_nodup_merged_peaks.narrowPeak

echo "Sorting start and end chromosom position of merged files" >&2
sort -k1,1 -k2,2n "$OUTPUT"/ss_50k_0h_trim_mapped_sorted_q2_nodup_merged_peaks.narrowPeak > "$OUTPUT"/ss_50k_0h_trim_mapped_sorted_merged_sorted_peaks.bed
sort -k1,1 -k2,2n "$OUTPUT"/ss_50k_24h_trim_mapped_sorted_q2_nodup_merged_peaks.narrowPeak >"$OUTPUT"/ss_50k_24h_trim_mapped_sorted_merged_sorted_peaks.bed



#Run the program
# intersect the peaks from two conditions.
#Args -a <file> : Path to the input BED file 
#Args  -f -r <number> : Requiring reciprocal minimal overlap fraction between conditions
#Args -v : Reporting the absence of any overlapping features
echo "Identification of common DNA open sites with bedtools intersect" >&2
bedtools intersect -a "$OUTPUT"/ss_50k_24h_trim_mapped_sorted_merged_sorted_peaks.bed \
                   -b "$OUTPUT"/ss_50k_0h_trim_mapped_sorted_merged_sorted_peaks.bed \
                   -f 0.50 -r > "$OUTPUT"/ss_50ktrim_mapped_sorted_merged_sorted_both.bed

bedtools intersect -a "$OUTPUT"/ss_50k_0h_trim_mapped_sorted_merged_sorted_peaks.bed \
                   -b "$OUTPUT"/ss_50k_24h_trim_mapped_sorted_merged_sorted_peaks.bed \
                   -f 0.50 -r -v > "$OUTPUT"/ss_50ktrim_mapped_sorted_merged_sorted_0H_Unique.bed

bedtools intersect -a "$OUTPUT"/ss_50k_24h_trim_mapped_sorted_merged_sorted_peaks.bed \
                   -b "$OUTPUT"/ss_50k_0h_trim_mapped_sorted_merged_sorted_peaks.bed \
                   -f 0.50 -r -v > "$OUTPUT"/ss_50ktrim_mapped_sorted_merged_sorted_24H_Unique.bed

echo "Stop job : "`date` >&2

