#!/bin/bash

#SBATCH --partition=shortq
#SBATCH --qos=shortq
#SBATCH --job-name tx_progression
#SBATCH --mem=200G
#SBATCH -o %x.out
#SBATCH -e %x.err

jupyter nbconvert --to html --execute tx_progression.r.ipynb