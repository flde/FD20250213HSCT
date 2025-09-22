#!/bin/bash

#SBATCH --partition=tinyq
#SBATCH --qos=tinyq
#SBATCH --mem=200G
#SBATCH --cpus-per-task 8
#SBATCH --job-name paga
#SBATCH -o %x.out
#SBATCH -e %x.err

jupyter nbconvert --to html --execute paga.p.ipynb