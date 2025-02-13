#!/bin/bash

#SBATCH --partition=tinyq
#SBATCH --qos=tinyq
#SBATCH --mem=200G
#SBATCH --cpus-per-task 48
#SBATCH --job-name lymphocyte
#SBATCH -o %x.out
#SBATCH -e %x.err

jupyter nbconvert --to html --execute lymphocyte.p.ipynb