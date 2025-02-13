#!/bin/bash

#SBATCH --partition=shortq
#SBATCH --qos=shortq
#SBATCH --mem=200G
#SBATCH --job-name figure_2
#SBATCH -o %x.out
#SBATCH -e %x.err

jupyter nbconvert --to html --execute figure_2.r.ipynb