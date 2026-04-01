#!/bin/bash

#SBATCH --partition=tinyq
#SBATCH --qos=tinyq
#SBATCH --mem=200G
#SBATCH --cpus-per-task 8
#SBATCH --job-name get_cell_df
#SBATCH -o %x.out
#SBATCH -e %x.err

jupyter nbconvert --to html --execute get_cell_df.p.ipynb --output get_cell_df.p