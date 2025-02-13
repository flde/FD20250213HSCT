#!/bin/bash

#SBATCH --partition=tinyq
#SBATCH --qos=tinyq
#SBATCH --mem=200G
#SBATCH --cpus-per-task 2
#SBATCH --job-name lymphocyte_dea
#SBATCH -o %x.out
#SBATCH -e %x.err

jupyter nbconvert --to html --execute lymphocyte_dea.r.ipynb --no-input