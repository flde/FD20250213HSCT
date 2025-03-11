#!/bin/bash

#SBATCH --partition=gpu
#SBATCH --qos=gpu
#SBATCH --gres=gpu:l4_gpu:1
#SBATCH --mem=200G
#SBATCH --cpus-per-task 2
#SBATCH --time=1:00:00
#SBATCH --job-name annotation
#SBATCH -o %x.out
#SBATCH -e %x.err

jupyter nbconvert --to html --execute annotation.p.ipynb --output annotation.p

