#!/bin/bash

#SBATCH --partition=shortq
#SBATCH --qos=shortq
#SBATCH --mem=200G
#SBATCH --cpus-per-task 32
#SBATCH --job-name cellsnp
#SBATCH -o %x_%a.out
#SBATCH -e %x_%a.err

# cellSNP: https://github.com/single-cell-genetics/cellSNP
# cellSNP-lite: https://github.com/single-cell-genetics/cellsnp-lite

# reference https://sourceforge.net/projects/cellsnp/files/SNPlist/
# genome1K.phase3.SNP_AF5e2.chr1toX.hg38.vcf.gz 7.4M SNPs with minor allele frequency (MAF) > 0.05
# genome1K.phase3.SNP_AF5e4.chr1toX.hg38.vcf.gz 36.6M SNPs with minor allele frequency (MAF) > 0.0005

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

############################
### Patient_6 (784, 116) ###
############################

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
### Patient_9 (7) ###
#####################

PATIENT_ID="Patient_9"

arg[8]="${PATIENT_ID}"

######################
### Patient_10 (8) ###
######################

PATIENT_ID="Patient_10"

arg[9]="${PATIENT_ID}"

######################
### Patient_11 (9) ###
######################

PATIENT_ID="Patient_11"

arg[10]="${PATIENT_ID}"

#######################
### Patient_12 (17) ###
#######################

PATIENT_ID="Patient_12"

arg[11]="${PATIENT_ID}"

###########################
###### Run array job ######
###########################

arg_id=${arg[$SLURM_ARRAY_TASK_ID]}
IFS="|" read -r -a arg_id <<< "${arg_id}"

BAM_DIR="/research/peer/fdeckert/FD20250213HSCT/data/genotype/1_merge_bam/"
REGION_VCF="/research/peer/fdeckert/FD20250213HSCT/data/reference/genome1k/genome1K.phase3.SNP_AF5e4.chr1toX.hg38.vcf.gz"
OUT_DIR="/research/peer/fdeckert/FD20250213HSCT/data/genotype/2_cellsnp/"

echo ${arg_id[0]}
echo ${BAM_DIR}
echo ${REGION_VCF}
echo ${OUT_DIR}

### cellsnp-lite mode 1a
cellsnp-lite -s "${BAM_DIR}${arg_id[0]}_merge_bam/out.sorted.bam" -b "${BAM_DIR}${arg_id[0]}_merge_bam/outbcs.tsv.gz" -O "${OUT_DIR}${arg_id[0]}_cellsnp_0" -R ${REGION_VCF} -p 32 --minMAF 0 --minCOUNT 20 --gzip