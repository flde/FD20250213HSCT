#!/bin/bash

#SBATCH --partition=tinyq
#SBATCH --qos=tinyq
#SBATCH --mem=32G
#SBATCH --job-name celltype_high
#SBATCH --cpus-per-task 8
#SBATCH -o %x.out
#SBATCH -e %x.err

jupyter nbconvert --to html --execute celltype_high.r.ipynb