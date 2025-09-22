#!/bin/bash

#SBATCH --partition=shortq
#SBATCH --qos=shortq
#SBATCH --mem=200G
#SBATCH --job-name pp
#SBATCH -o %x.out
#SBATCH -e %x.err

jupyter nbconvert --to html --execute pp.r.ipynb