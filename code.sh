#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --cpus-per-task=32
#SBATCH --ntasks-per-core=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=48G
#SBATCH --time=15:00:00
#SBATCH --partition=standard

ssh -N -R 18080:localhost:18080 zfn2&
$HOME/grant_398/scratch/bin/code-server
