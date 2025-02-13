#!/bin/bash

#SBATCH --partition=mediumq
#SBATCH --qos=mediumq
#SBATCH --mem=200G
#SBATCH --job-name scvi_int
#SBATCH -o %x.out
#SBATCH -e %x.err

jupyter nbconvert --to html --execute scvi_int.p.ipynb