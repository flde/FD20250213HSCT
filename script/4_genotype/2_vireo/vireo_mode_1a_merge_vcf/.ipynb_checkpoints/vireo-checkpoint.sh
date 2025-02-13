#!/bin/bash

#SBATCH --partition=tinyq
#SBATCH --qos=tinyq
#SBATCH --mem=200G
#SBATCH --cpus-per-task 48
#SBATCH --job-name vireo
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

IN_DIR="/research/peer/fdeckert/FD20220623HSCT/data/object/genotype/cellsnp/cellsnp_mode_1a_merge_vcf/"
OUT_DIR="/research/peer/fdeckert/FD20220623HSCT/data/object/genotype/vireo/vireo_mode_1a_merge_vcf/"

echo ${arg_id[0]}
echo ${IN_DIR}
echo ${OUT_DIR}

# Run on original cellsnp format minMAF 0
mkdir -p "${OUT_DIR}${arg_id[0]}_vireo_cellsnp_0"
vireo -c "${IN_DIR}${arg_id[0]}_cellsnp_0" -N 2 -p 48 -M 100 -o "${OUT_DIR}${arg_id[0]}_vireo_cellsnp_0"

# Run on cellsnp vartrix format minMAF 0 
mkdir -p "${OUT_DIR}${arg_id[0]}_vireo_vartrix_0"
vireo --vartrixData="${IN_DIR}${arg_id[0]}_vartrix_0/alt.mtx","${IN_DIR}${arg_id[0]}_vartrix_0/ref.mtx","${IN_DIR}${arg_id[0]}_vartrix_0/barcodes.tsv" -N 2 -p 48 -M 100 -o "${OUT_DIR}${arg_id[0]}_vireo_vartrix_0"

# Run on cellsnp vartrix format minMAF 0.001
mkdir -p "${OUT_DIR}${arg_id[0]}_vireo_vartrix_0001"
vireo --vartrixData="${IN_DIR}${arg_id[0]}_vartrix_0001/alt.mtx","${IN_DIR}${arg_id[0]}_vartrix_0001/ref.mtx","${IN_DIR}${arg_id[0]}_vartrix_0001/barcodes.tsv" -N 2 -p 48 -M 100 -o "${OUT_DIR}${arg_id[0]}_vireo_vartrix_0001"

# Run on cellsnp vartrix format minMAF 0.005
mkdir -p "${OUT_DIR}${arg_id[0]}_vireo_vartrix_0005"
vireo --vartrixData="${IN_DIR}${arg_id[0]}_vartrix_0005/alt.mtx","${IN_DIR}${arg_id[0]}_vartrix_0005/ref.mtx","${IN_DIR}${arg_id[0]}_vartrix_0005/barcodes.tsv" -N 2 -p 48 -M 100 -o "${OUT_DIR}${arg_id[0]}_vireo_vartrix_0005"

# Run on cellsnp vartrix format minMAF 0.001
mkdir -p "${OUT_DIR}${arg_id[0]}_vireo_vartrix_001"
vireo --vartrixData="${IN_DIR}${arg_id[0]}_vartrix_001/alt.mtx","${IN_DIR}${arg_id[0]}_vartrix_001/ref.mtx","${IN_DIR}${arg_id[0]}_vartrix_001/barcodes.tsv" -N 2 -p 48 -M 100 -o "${OUT_DIR}${arg_id[0]}_vireo_vartrix_001"

# Run on cellsnp vartrix format minMAF 0.005
mkdir -p "${OUT_DIR}${arg_id[0]}_vireo_vartrix_005"
vireo --vartrixData="${IN_DIR}${arg_id[0]}_vartrix_005/alt.mtx","${IN_DIR}${arg_id[0]}_vartrix_005/ref.mtx","${IN_DIR}${arg_id[0]}_vartrix_005/barcodes.tsv" -N 2 -p 48 -M 100 -o "${OUT_DIR}${arg_id[0]}_vireo_vartrix_005"

# Run on cellsnp vartrix format minMAF 0.01
mkdir -p "${OUT_DIR}${arg_id[0]}_vireo_vartrix_01"
vireo --vartrixData="${IN_DIR}${arg_id[0]}_vartrix_01/alt.mtx","${IN_DIR}${arg_id[0]}_vartrix_01/ref.mtx","${IN_DIR}${arg_id[0]}_vartrix_01/barcodes.tsv" -N 2 -p 48 -M 100 -o "${OUT_DIR}${arg_id[0]}_vireo_vartrix_01"

# Run on cellsnp vartrix format minMAF 0.05
mkdir -p "${OUT_DIR}${arg_id[0]}_vireo_vartrix_05"
vireo --vartrixData="${IN_DIR}${arg_id[0]}_vartrix_05/alt.mtx","${IN_DIR}${arg_id[0]}_vartrix_05/ref.mtx","${IN_DIR}${arg_id[0]}_vartrix_05/barcodes.tsv" -N 2 -p 48 -M 100 -o "${OUT_DIR}${arg_id[0]}_vireo_vartrix_05"

# Run on cellsnp vartrix format minMAF 0.1
mkdir -p "${OUT_DIR}${arg_id[0]}_vireo_vartrix_1"
vireo --vartrixData="${IN_DIR}${arg_id[0]}_vartrix_1/alt.mtx","${IN_DIR}${arg_id[0]}_vartrix_1/ref.mtx","${IN_DIR}${arg_id[0]}_vartrix_1/barcodes.tsv" -N 2 -p 48 -M 100 -o "${OUT_DIR}${arg_id[0]}_vireo_vartrix_1"

# Run on cellsnp vartrix format minMAF 0.2
mkdir -p "${OUT_DIR}${arg_id[0]}_vireo_vartrix_2"
vireo --vartrixData="${IN_DIR}${arg_id[0]}_vartrix_2/alt.mtx","${IN_DIR}${arg_id[0]}_vartrix_2/ref.mtx","${IN_DIR}${arg_id[0]}_vartrix_2/barcodes.tsv" -N 2 -p 48 -M 100 -o "${OUT_DIR}${arg_id[0]}_vireo_vartrix_2"