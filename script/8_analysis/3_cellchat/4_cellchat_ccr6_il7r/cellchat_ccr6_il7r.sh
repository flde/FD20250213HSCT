#!/bin/bash

#SBATCH --partition=shortq
#SBATCH --qos=shortq
#SBATCH --mem=200G
#SBATCH --job-name cellchat_ccr6_il7r
#SBATCH -o %x.out
#SBATCH -e %x.err

jupyter nbconvert --to html --execute cellchat_ccr6_il7r.r.ipynb