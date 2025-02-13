#!/bin/bash

#SBATCH --partition=tinyq
#SBATCH --qos=tinyq
#SBATCH --mem=200G
#SBATCH --cpus-per-task 8
#SBATCH --job-name variants
#SBATCH -o %x_%a.out
#SBATCH -e %x_%a.err

# vireo: https://vireosnp.readthedocs.io/en/latest/manual.html
# conda activate environment with vireo installed before running 

#######################
### Patient_1 (763) ###
#######################

PATIENT_ID="Patient_1"

arg[0]="${PATIENT_ID}"

#######################
### Patient_2 (764) ###
#######################

PATIENT_ID="Patient_2"

arg[1]="${PATIENT_ID}"

#######################
### Patient_3 (766) ###
#######################

PATIENT_ID="Patient_3"

arg[2]="${PATIENT_ID}"

#######################
### Patient_4 (768) ###
#######################

PATIENT_ID="Patient_4"

arg[3]="${PATIENT_ID}"

#######################
### Patient_5 (783) ###
#######################

PATIENT_ID="Patient_5"

arg[4]="${PATIENT_ID}"

#######################
### Patient_6 (784) ###
#######################

PATIENT_ID="Patient_6"

arg[5]="${PATIENT_ID}"

#######################
### Patient_7 (785) ###
#######################

PATIENT_ID="Patient_7"

arg[6]="${PATIENT_ID}"

#####################
### Patient_8 (4) ###
#####################

PATIENT_ID="Patient_8"

arg[7]="${PATIENT_ID}"

#####################
### Patient_9 (5) ###
#####################

PATIENT_ID="Patient_9"

arg[8]="${PATIENT_ID}"

######################
### Patient_10 (7) ###
######################

PATIENT_ID="Patient_10"

arg[9]="${PATIENT_ID}"

######################
### Patient_11 (8) ###
######################

PATIENT_ID="Patient_11"

arg[10]="${PATIENT_ID}"

###########################
###### Run array job ######
###########################

arg_id=${arg[$SLURM_ARRAY_TASK_ID]}
IFS="|" read -r -a arg_id <<< "${arg_id}"

IN_DIR="/research/peer/fdeckert/FD20220623HSCT/data/object/genotype/vireo/vireo_mode_1a_genome1k/"
OUT_DIR="/research/peer/fdeckert/FD20220623HSCT/data/object/genotype/variants/vireo_mode_1a_genome1k/"

echo ${arg_id[0]}
echo ${IN_DIR}
echo ${OUT_DIR}

mkdir -p "${OUT_DIR}${arg_id[0]}_vireo_cellsnp_0"
GTbarcode -i "${IN_DIR}${arg_id[0]}_vireo_cellsnp_0/GT_donors.vireo.vcf.gz" -o "${OUT_DIR}${arg_id[0]}_vireo_cellsnp_0/variants.tsv" --randSeed 42