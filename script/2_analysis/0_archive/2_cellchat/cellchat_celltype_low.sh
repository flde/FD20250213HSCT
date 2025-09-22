#!/bin/bash

#SBATCH --partition=tinyq
#SBATCH --qos=tinyq
#SBATCH --mem=200G
#SBATCH --job-name cellchat_celltype_low
#SBATCH -o %x.out
#SBATCH -e %x.err

jupyter nbconvert --to html --execute cellchat_celltype_low.r.ipynb