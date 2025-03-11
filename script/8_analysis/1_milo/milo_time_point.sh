#!/bin/bash

#SBATCH --partition=tinyq
#SBATCH --qos=tinyq
#SBATCH --mem=200G
#SBATCH --cpus-per-task 8
#SBATCH --job-name milo_time_point
#SBATCH -o %x.out
#SBATCH -e %x.err

jupyter nbconvert --to html --execute milo_time_point.r.ipynb