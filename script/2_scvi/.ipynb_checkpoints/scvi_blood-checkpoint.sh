#!/bin/bash

#SBATCH --partition=mediumq
#SBATCH --qos=mediumq
#SBATCH --mem=200G
#SBATCH --job-name scvi_blood_drmv_l10
#SBATCH -o %x.out
#SBATCH -e %x.err

jupyter nbconvert --to html --execute scvi_blood.p.ipynb --output scvi_blood_drmv_l10.p