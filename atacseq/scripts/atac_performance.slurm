#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH -o log/slurmjob-%A-%a
#SBATCH --job-name=Sacct
#SBATCH --partition=short

sacct --format=jobid,elapsed,ncpus,AllocCPUS,CPUTime,TotalCPU,ReqMem,ntasks,state,User > "$HOME"/atacseq/results/performance_workflow.txt
