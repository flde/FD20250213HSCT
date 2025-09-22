#!/bin/bash

#SBATCH --partition=tinyq
#SBATCH --qos=tinyq
#SBATCH --job-name gvhd_class_time_points_main
#SBATCH --mem=200G
#SBATCH --cpus-per-task 8
#SBATCH -o %x.out
#SBATCH -e %x.err

jupyter nbconvert --no-input --to html --execute gvhd_class_time_points_main.r.ipynb