#!/bin/bash
#SBATCH --time=0:40:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=12G
#SBATCH --cpus-per-task=6   # Nb of threads we want to run on
#SBATCH -o atacseq/log/slurmjob-%A-%a
#SBATCH --job-name=Peak_calling
#SBATCH --partition=short
#SBATCH --array=0-5

# Program configuration
__author__='Fatima FARIS'
__email__='Fatima.FARIS@etu.uca.fr'
__credits__=['Fatima FARIS']
__license__='GPL3'
__maintainer__='Fatima FARIS'
__status__='Development'
__version__='0.0.1'

echo 'Peak calling to identify oepn chromatin regions with MACS2' 

# Handling errors
#set -x # debug mode on
set -o errexit # ensure script will stop in case of ignored error
set -o nounset # force variable initialisation
#set -o verbose
#set -euo pipefail
module purge
module load gcc/4.8.4 python/2.7.9 numpy/1.9.2 cython/0.25.2 MACS2/2.1.2



echo "Set up directories ..." >&2
#Set up the temporary directory and output directory
OUTPUT="$HOME"/atacseq/results/macs2
mkdir -p "$OUTPUT"


#Set up data directory
#Set up data directory
DATA_DIR="$HOME"/atacseq/results/picard

mkdir -p "$OUTPUT"

echo "Start on $SLURMD_NODENAME: "`date` >&2
tab=($(ls "$DATA_DIR"/*/*mapped*.bam))
SHORTNAME=($(basename "${tab[$SLURM_ARRAY_TASK_ID]}" .bam))

#Run the program
echo "Identification of DNA access sites with MACS2" >&2
#Args -t <file> : Path to the input BAM files.
#Args -n <character> : Name of the output files.
#Args --outdir <file> : Path to the ouput files
#Arg --keep-dup <all> : will tell MACS not to perform duplicate removal because Picard it used befor. 
macs2 callpeak -t ${tab[$SLURM_ARRAY_TASK_ID]}  \
        -f BAM \
        --keep-dup all \
        -n "$SHORTNAME" \
        --outdir "$OUTPUT"


echo "Stop job : "`date` >&2

