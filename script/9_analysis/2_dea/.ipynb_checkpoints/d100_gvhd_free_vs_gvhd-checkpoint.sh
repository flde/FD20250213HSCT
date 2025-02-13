#!/bin/bash

#SBATCH --partition=shortq
#SBATCH --qos=shortq
#SBATCH --job-name d100_gvhd_free_vs_gvhd
#SBATCH --mem=200G
#SBATCH --cpus-per-task 8
#SBATCH -o %x.out
#SBATCH -e %x.err

jupyter nbconvert --no-input --to html --execute d100_gvhd_free_vs_gvhd.r.ipynb