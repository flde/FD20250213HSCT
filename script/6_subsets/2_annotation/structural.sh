#!/bin/bash

#SBATCH --partition=tinyq
#SBATCH --qos=tinyq
#SBATCH --mem=200G
#SBATCH --cpus-per-task 48
#SBATCH --job-name structural
#SBATCH -o %x.out
#SBATCH -e %x.err

jupyter nbconvert --to html --execute structural.p.ipynb