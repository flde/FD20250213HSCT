#!/bin/bash

#SBATCH --partition=tinyq
#SBATCH --qos=tinyq
#SBATCH --job-name myeloid
#SBATCH --mem=200G
#SBATCH --cpus-per-task 8
#SBATCH -o %x.out
#SBATCH -e %x.err

jupyter nbconvert --to html --execute myeloid.r.ipynb