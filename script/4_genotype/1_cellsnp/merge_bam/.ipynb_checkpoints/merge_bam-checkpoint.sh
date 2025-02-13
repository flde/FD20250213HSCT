#!/bin/bash

#SBATCH --partition=shortq
#SBATCH --qos=shortq
#SBATCH --mem=200G
#SBATCH --cpus-per-task 48
#SBATCH --job-name merge_bam
#SBATCH -o %x_%a.out
#SBATCH -e %x_%a.err

# For Slurm job activate conda environment with mergeBams python installed

#######################
### Patient_1 (763) ###
#######################

BAM_1="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/S_7631_baseline_transcriptome/possorted_genome_bam.bam"
BAM_2="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/S_7632_day0_transcriptome/possorted_genome_bam.bam"
BAM_3="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/S_7633_day14_transcriptome/possorted_genome_bam.bam"
BAM="${BAM_1},${BAM_2},${BAM_3}"

BARCODES_1="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/S_7631_baseline_transcriptome/filtered_feature_bc_matrix/barcodes.tsv.gz"
BARCODES_2="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/S_7632_day0_transcriptome/filtered_feature_bc_matrix/barcodes.tsv.gz"
BARCODES_3="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/S_7633_day14_transcriptome/filtered_feature_bc_matrix/barcodes.tsv.gz"
BARCODES="${BARCODES_1},${BARCODES_2},${BARCODES_3}"

PATIENT_ID="Patient_1"
SAMPLE_ID="Patient_1_Baseline,Patient_1_Tx,Patient_1_D14"

arg[0]="${BAM}|${BARCODES}|${PATIENT_ID}|${SAMPLE_ID}"

#######################
### Patient_2 (764) ###
#######################

BAM_1="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/S_7641_baseline_transcriptome/possorted_genome_bam.bam"
BAM_2="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/S_7642_day0_transcriptome/possorted_genome_bam.bam"
BAM="${BAM_1},${BAM_2}"

BARCODES_1="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/S_7641_baseline_transcriptome/filtered_feature_bc_matrix/barcodes.tsv.gz"
BARCODES_2="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/S_7642_day0_transcriptome/filtered_feature_bc_matrix/barcodes.tsv.gz"
BARCODES="${BARCODES_1},${BARCODES_2}"

PATIENT_ID="Patient_2"
SAMPLE_ID="Patient_2_Baseline,Patient_2_Tx"

arg[1]="${BAM}|${BARCODES}|${PATIENT_ID}|${SAMPLE_ID}"

#######################
### Patient_3 (766) ###
#######################

BAM_1="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/S_7661_baseline_transcriptome/possorted_genome_bam.bam"
BAM_2="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/S_7662_day0_transcriptome/possorted_genome_bam.bam"
BAM_3="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/S_7663_day14_transcriptome/possorted_genome_bam.bam"
BAM_4="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/S_7664_day100_transcriptome/possorted_genome_bam.bam"
BAM="${BAM_1},${BAM_2},${BAM_3},${BAM_4}"

BARCODES_1="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/S_7661_baseline_transcriptome/filtered_feature_bc_matrix/barcodes.tsv.gz"
BARCODES_2="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/S_7662_day0_transcriptome/filtered_feature_bc_matrix/barcodes.tsv.gz"
BARCODES_3="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/S_7663_day14_transcriptome/filtered_feature_bc_matrix/barcodes.tsv.gz"
BARCODES_4="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/S_7664_day100_transcriptome/filtered_feature_bc_matrix/barcodes.tsv.gz"
BARCODES="${BARCODES_1},${BARCODES_2},${BARCODES_3},${BARCODES_4}"

PATIENT_ID="Patient_3"
SAMPLE_ID="Patient_3_Baseline,Patient_3_Tx,Patient_3_D14,Patient_3_D100"

arg[2]="${BAM}|${BARCODES}|${PATIENT_ID}|${SAMPLE_ID}"

#######################
### Patient_4 (768) ###
#######################

BAM_1="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/S_7681_baseline_transcriptome/possorted_genome_bam.bam"
BAM_2="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/S_7682_day0_transcriptome/possorted_genome_bam.bam"
BAM_3="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/S_7683_day14_transcriptome/possorted_genome_bam.bam"
BAM_4="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/S_7684_day100_transcriptome/possorted_genome_bam.bam"
BAM="${BAM_1},${BAM_2},${BAM_3},${BAM_4}"

BARCODES_1="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/S_7681_baseline_transcriptome/filtered_feature_bc_matrix/barcodes.tsv.gz"
BARCODES_2="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/S_7682_day0_transcriptome/filtered_feature_bc_matrix/barcodes.tsv.gz"
BARCODES_3="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/S_7683_day14_transcriptome/filtered_feature_bc_matrix/barcodes.tsv.gz"
BARCODES_4="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/S_7684_day100_transcriptome/filtered_feature_bc_matrix/barcodes.tsv.gz"
BARCODES="${BARCODES_1},${BARCODES_2},${BARCODES_3},${BARCODES_4}"

PATIENT_ID="Patient_4"
SAMPLE_ID="Patient_4_Baseline,Patient_4_Tx,Patient_4_D14,Patient_4_D100"

arg[3]="${BAM}|${BARCODES}|${PATIENT_ID}|${SAMPLE_ID}"

#######################
### Patient_5 (783) ###
#######################

BAM_1="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/HSCT_7831_transcriptome/possorted_genome_bam.bam"
BAM_2="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/HSCT_7833_transcriptome/possorted_genome_bam.bam"
BAM_3="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/HSCT_7834_transcriptome/possorted_genome_bam.bam"
BAM="${BAM_1},${BAM_2},${BAM_3}"

BARCODES_1="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/HSCT_7831_transcriptome/filtered_feature_bc_matrix/barcodes.tsv.gz"
BARCODES_2="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/HSCT_7833_transcriptome/filtered_feature_bc_matrix/barcodes.tsv.gz"
BARCODES_3="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/HSCT_7834_transcriptome/filtered_feature_bc_matrix/barcodes.tsv.gz"
BARCODES="${BARCODES_1},${BARCODES_2},${BARCODES_3}"

PATIENT_ID="Patient_5"
SAMPLE_ID="Patient_5_Baseline,Patient_5_D14,Patient_5_D100"

arg[4]="${BAM}|${BARCODES}|${PATIENT_ID}|${SAMPLE_ID}"

#######################
### Patient_6 (784) ###
#######################

BAM_1="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/HSCT_7841_transcriptome/possorted_genome_bam.bam"
BAM_2="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/HSCT_7843_transcriptome/possorted_genome_bam.bam"
BAM_3="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/GvD_116_784_transcriptome/possorted_genome_bam.bam"
BAM="${BAM_1},${BAM_2},${BAM_3}"

BARCODES_1="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/HSCT_7841_transcriptome/filtered_feature_bc_matrix/barcodes.tsv.gz"
BARCODES_2="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/HSCT_7843_transcriptome/filtered_feature_bc_matrix/barcodes.tsv.gz"
BARCODES_3="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/GvD_116_784_transcriptome/filtered_feature_bc_matrix/barcodes.tsv.gz"
BARCODES="${BARCODES_1},${BARCODES_2},${BARCODES_3}"

PATIENT_ID="Patient_6"
SAMPLE_ID="Patient_6_Baseline,Patient_6_D14,Patient_6_GVHD"

arg[5]="${BAM}|${BARCODES}|${PATIENT_ID}|${SAMPLE_ID}"

#######################
### Patient_7 (785) ###
#######################

BAM_1="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/HSCT_7851_transcriptome/possorted_genome_bam.bam"
BAM_2="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/HSCT_7853_transcriptome/possorted_genome_bam.bam"
BAM_3="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/HSCT_7854_transcriptome/possorted_genome_bam.bam"
BAM="${BAM_1},${BAM_2},${BAM_3}"

BARCODES_1="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/HSCT_7851_transcriptome/filtered_feature_bc_matrix/barcodes.tsv.gz"
BARCODES_2="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/HSCT_7853_transcriptome/filtered_feature_bc_matrix/barcodes.tsv.gz"
BARCODES_3="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/HSCT_7854_transcriptome/filtered_feature_bc_matrix/barcodes.tsv.gz"
BARCODES="${BARCODES_1},${BARCODES_2},${BARCODES_3}"

PATIENT_ID="Patient_7"
SAMPLE_ID="Patient_7_Baseline,Patient_7_D14,Patient_7_D100"

arg[6]="${BAM}|${BARCODES}|${PATIENT_ID}|${SAMPLE_ID}"

#####################
### Patient_8 (4) ###
#####################

BAM_1="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/CoR_GvD_04_transcriptome/possorted_genome_bam.bam"
BAM="${BAM_1}"

BARCODES_1="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/CoR_GvD_04_transcriptome/filtered_feature_bc_matrix/barcodes.tsv.gz"
BARCODES="${BARCODES_1}"

PATIENT_ID="Patient_8"
SAMPLE_ID="Patient_8_GVHD"

arg[7]="${BAM}|${BARCODES}|${PATIENT_ID}|${SAMPLE_ID}"

#####################
### Patient_9 (5) ###
#####################

BAM_1="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/CoR_GvD_05_transcriptome/possorted_genome_bam.bam"
BAM="${BAM_1}"

BARCODES_1="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/CoR_GvD_05_transcriptome/filtered_feature_bc_matrix/barcodes.tsv.gz"
BARCODES="${BARCODES_1}"

PATIENT_ID="Patient_9"
SAMPLE_ID="Patient_9_GVHD"

arg[8]="${BAM}|${BARCODES}|${PATIENT_ID}|${SAMPLE_ID}"

######################
### Patient_10 (7) ###
######################

BAM_1="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/CoR_GVD_07_transcriptome/possorted_genome_bam.bam"
BAM="${BAM_1}"

BARCODES_1="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/CoR_GVD_07_transcriptome/filtered_feature_bc_matrix/barcodes.tsv.gz"
BARCODES="${BARCODES_1}"

PATIENT_ID="Patient_10"
SAMPLE_ID="Patient_10_GVHD"

arg[9]="${BAM}|${BARCODES}|${PATIENT_ID}|${SAMPLE_ID}"

######################
### Patient_11 (8) ###
######################

BAM_1="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/CoR_GVD_08_transcriptome/possorted_genome_bam.bam"
BAM="${BAM_1}"

BARCODES_1="/nobackup/lab_bsf/projects/BSA_0738_Stary_amalgamation/OUT/COUNT/CoR_GVD_08_transcriptome/filtered_feature_bc_matrix/barcodes.tsv.gz"
BARCODES="${BARCODES_1}"

PATIENT_ID="Patient_11"
SAMPLE_ID="Patient_11_GVHD"

arg[10]="${BAM}|${BARCODES}|${PATIENT_ID}|${SAMPLE_ID}"

###########################
###### Run array job ######
###########################

arg_id=${arg[$SLURM_ARRAY_TASK_ID]}
IFS="|" read -r -a arg_id <<< "${arg_id}"

OUT_DIR="/research/peer/fdeckert/FD20220623HSCT/data/object/genotype/cellsnp/merge_bam/"

echo ${arg_id[0]}
echo ${arg_id[1]}
echo ${arg_id[2]}
echo ${arg_id[3]}
echo ${OUT_DIR}

### mergeBams
mkdir -p "${OUT_DIR}${arg_id[2]}_merge_bam"
mergeBams -i ${arg_id[0]} -b ${arg_id[1]} -l ${arg_id[3]} -o "${OUT_DIR}${arg_id[2]}_merge_bam"

### sort merged bam 
module load SAMtools
samtools sort -@ 48 "${OUT_DIR}${arg_id[2]}_merge_bam/out.bam" -o "${OUT_DIR}${arg_id[2]}_merge_bam/out.sorted.bam"
samtools index -@ 48 "${OUT_DIR}${arg_id[2]}_merge_bam/out.sorted.bam"