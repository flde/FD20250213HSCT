#!/bin/bash

#SBATCH --partition=tinyq
#SBATCH --qos=tinyq
#SBATCH --job-name figure
#SBATCH --mem=200G
#SBATCH -o %x.out
#SBATCH -e %x.err

jupyter nbconvert --to html --execute figure.p.ipynb