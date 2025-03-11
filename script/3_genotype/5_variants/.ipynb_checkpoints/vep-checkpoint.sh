#!/bin/bash

#SBATCH --partition=shortq
#SBATCH --qos=shortq
#SBATCH --mem=200G
#SBATCH --cpus-per-task 8
#SBATCH --job-name vep
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

OUT_DIR="/research/peer/fdeckert/FD20250213HSCT/data/object/genotype/vep/${arg_id[0]}"

echo ${arg_id[0]}
echo ${OUT_DIR}

mkdir -p $OUT_DIR
cd $OUT_DIR

module load HTSlib
module load DBD-mysql

/nobackup/peer/fdeckert/ensembl-vep/vep --cache --dir_cache /nobackup/peer/fdeckert/ensembl-cache/ --force_overwrite --input_file gt_variants.tsv -species homo_sapiens --fork 8