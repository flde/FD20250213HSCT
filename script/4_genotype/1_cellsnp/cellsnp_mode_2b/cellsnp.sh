#!/bin/bash

#SBATCH --partition=shortq
#SBATCH --qos=shortq
#SBATCH --mem=200G
#SBATCH --cpus-per-task 48
#SBATCH --job-name cellsnp
#SBATCH -o %x_%a.out
#SBATCH -e %x_%a.err

# For Slurm job activate conda environment with mergeBams python installed

# cellSNP: https://github.com/single-cell-genetics/cellSNP
# cellSNP-lite: https://github.com/single-cell-genetics/cellsnp-lite

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

BAM_DIR="/research/peer/fdeckert/FD20220623HSCT/data/object/genotype/cellsnp/merge_bam/"
OUT_DIR="/research/peer/fdeckert/FD20220623HSCT/data/object/genotype/cellsnp/cellsnp_mode_2b/"

echo ${arg_id[0]}
echo ${BAM_DIR}
echo ${OUT_DIR}

### cellsnp-lite mode 2b
cellsnp-lite -s "${BAM_DIR}${arg_id[0]}_merge_bam/out.sorted.bam" -I ${arg_id[0]} -O "${OUT_DIR}${arg_id[0]}_cellsnp" -p 48 --minMAF 0.05 --minCOUNT 100 --cellTAG None --UMItag None --gzip