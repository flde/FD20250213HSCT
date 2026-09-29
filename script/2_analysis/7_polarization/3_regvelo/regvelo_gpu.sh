#!/bin/bash

#SBATCH --partition=gpu
#SBATCH --qos=gpu
#SBATCH --gres=gpu:h100hgx:4
#SBATCH --mem=200G
#SBATCH --cpus-per-task 8
#SBATCH --time=1:00:00
#SBATCH --job-name regvelo
#SBATCH -o %x.out
#SBATCH -e %x.err

jupyter nbconvert --to html --execute regvelo.p.ipynb --output regvelo.p