#!/bin/bash

#SBATCH --partition=tinyq
#SBATCH --qos=tinyq
#SBATCH --job-name lymphocyte_free_vs_dev_time_points
#SBATCH --mem=200G
#SBATCH --cpus-per-task 8
#SBATCH -o %x.out
#SBATCH -e %x.err

jupyter nbconvert --to html --execute lymphocyte_free_vs_dev_time_points.r.ipynb