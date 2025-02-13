#!/bin/bash

#SBATCH --partition=tinyq
#SBATCH --qos=tinyq
#SBATCH --mem=200G
#SBATCH --cpus-per-task 16
#SBATCH --job-name grn
#SBATCH -o %x.out
#SBATCH -e %x.err

jupyter nbconvert --to html --execute grn.p.ipynb
