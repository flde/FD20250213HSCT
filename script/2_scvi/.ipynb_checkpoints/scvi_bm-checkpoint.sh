#!/bin/bash

#SBATCH --partition=mediumq
#SBATCH --qos=mediumq
#SBATCH --mem=200G
#SBATCH --job-name scvi_bm_drmv_l10
#SBATCH -o %x.out
#SBATCH -e %x.err

jupyter nbconvert --to html --execute scvi_bm.p.ipynb --output scvi_bm_drmv_l10.p