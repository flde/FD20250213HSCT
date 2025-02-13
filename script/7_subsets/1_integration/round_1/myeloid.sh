#!/bin/bash

#SBATCH --partition=shortq
#SBATCH --qos=shortq
#SBATCH --mem=200G
#SBATCH --cpus-per-task 48
#SBATCH --job-name myeloid
#SBATCH -o %x.out
#SBATCH -e %x.err

jupyter nbconvert --to html --execute myeloid.p.ipynb