#!/bin/bash

#SBATCH --partition=shortq
#SBATCH --qos=shortq
#SBATCH --mem=200G
#SBATCH --cpus-per-task 32
#SBATCH --job-name lymphocyte_pt
#SBATCH -o %x.out
#SBATCH -e %x.err

jupyter nbconvert --to html --execute lymphocyte_pt.p.ipynb 