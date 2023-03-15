#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --ntasks-per-core=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=4G
#SBATCH --time=15:00:00
#SBATCH --partition=tesla 
#SBATCH --gres=gpu:1

$HOME/grant_398/scratch/bin/amumax -cache="$HOME/grant_398/scratch/mumax_kernels" $1
