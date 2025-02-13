#!/bin/bash

#SBATCH --partition=tinyq
#SBATCH --qos=tinyq
#SBATCH --mem=200G
#SBATCH --job-name merge_vcf
#SBATCH -o %x_%a.out
#SBATCH -e %x_%a.err

# For Slurm job activate conda environment with mergeBams python installed

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

REGION_VCF_MODE2B="/research/peer/fdeckert/FD20220623HSCT/data/object/genotype/cellsnp/cellsnp_mode_2b/"
REGION_VCF_GENOME1K="/research/peer/fdeckert/FD20220623HSCT/data/reference/genome1k/genome1K.phase3.SNP_AF5e4.chr1toX.hg38_sorted_strip.vcf.gz"
REGION_VCF_MERGE="/research/peer/fdeckert/FD20220623HSCT/data/object/genotype/cellsnp/merge_vcf/"

echo ${arg_id[0]}
echo ${REGION_VCF_MODE2B}
echo ${REGION_VCF_GENOME1K}
echo ${REGION_VCF_MERGE}

### Module load 
module load BCFtools

### Create output directory 
mkdir -p "${REGION_VCF_MERGE}${arg_id[0]}_merge_vcf"

### Carry over VCF from mode 2b
cp "${REGION_VCF_MODE2B}${arg_id[0]}_cellsnp/cellSNP.base.vcf.gz" "${REGION_VCF_MERGE}${arg_id[0]}_merge_vcf/cellSNP_tmp_0.base.vcf.gz"

### Create index to update contigs 
bcftools index -t "${REGION_VCF_MERGE}${arg_id[0]}_merge_vcf/cellSNP_tmp_0.base.vcf.gz"

### Create header information about tags
echo "##INFO=<ID=AD,Number=1,Type=Integer,Description="AD">" >> "${REGION_VCF_MERGE}${arg_id[0]}_merge_vcf/header.txt" 
echo "##INFO=<ID=DP,Number=1,Type=Integer,Description="DP">" >> "${REGION_VCF_MERGE}${arg_id[0]}_merge_vcf/header.txt" 
echo "##INFO=<ID=OTH,Number=1,Type=Integer,Description="OTH">" >> "${REGION_VCF_MERGE}${arg_id[0]}_merge_vcf/header.txt" 

### Add info tag
bcftools annotate -h "${REGION_VCF_MERGE}${arg_id[0]}_merge_vcf/header.txt" -O z -o "${REGION_VCF_MERGE}${arg_id[0]}_merge_vcf/cellSNP_tmp_1.base.vcf.gz" "${REGION_VCF_MERGE}${arg_id[0]}_merge_vcf/cellSNP_tmp_0.base.vcf.gz"

### Remove ID and TAGS and index 
bcftools annotate -x ID,INFO/AD,INFO/DP,INFO/OTH -O z -o "${REGION_VCF_MERGE}${arg_id[0]}_merge_vcf/cellSNP_tmp_2.base.vcf.gz" "${REGION_VCF_MERGE}${arg_id[0]}_merge_vcf/cellSNP_tmp_1.base.vcf.gz"
bcftools index -t "${REGION_VCF_MERGE}${arg_id[0]}_merge_vcf/cellSNP_tmp_2.base.vcf.gz"

### Remove tmp files 
rm "${REGION_VCF_MERGE}${arg_id[0]}_merge_vcf/header.txt"
rm "${REGION_VCF_MERGE}${arg_id[0]}_merge_vcf/cellSNP_tmp_0.base.vcf.gz"
rm "${REGION_VCF_MERGE}${arg_id[0]}_merge_vcf/cellSNP_tmp_0.base.vcf.gz.tbi" 
rm "${REGION_VCF_MERGE}${arg_id[0]}_merge_vcf/cellSNP_tmp_1.base.vcf.gz"

### Find overlapping positions
bcftools isec -n=2 -c all ${REGION_VCF_GENOME1K} "${REGION_VCF_MERGE}${arg_id[0]}_merge_vcf/cellSNP_tmp_2.base.vcf.gz" | cut -f 1,2 > "${REGION_VCF_MERGE}${arg_id[0]}_merge_vcf/position.txt"

### Remove overlapping positions from mode 2b vcf
bcftools view -T ^"${REGION_VCF_MERGE}${arg_id[0]}_merge_vcf/position.txt" -O z -o "${REGION_VCF_MERGE}${arg_id[0]}_merge_vcf/cellSNP_tmp_3.base.vcf.gz" "${REGION_VCF_MERGE}${arg_id[0]}_merge_vcf/cellSNP_tmp_2.base.vcf.gz"
bcftools index -t "${REGION_VCF_MERGE}${arg_id[0]}_merge_vcf/cellSNP_tmp_3.base.vcf.gz"

### Concat VCF files 
bcftools concat -a -O z -o "${REGION_VCF_MERGE}${arg_id[0]}_merge_vcf/merge.vcf.gz" ${REGION_VCF_GENOME1K} "${REGION_VCF_MERGE}${arg_id[0]}_merge_vcf/cellSNP_tmp_3.base.vcf.gz"

### Sort and index merged file 
bcftools sort -O z -o "${REGION_VCF_MERGE}${arg_id[0]}_merge_vcf/merge_sort.vcf.gz" "${REGION_VCF_MERGE}${arg_id[0]}_merge_vcf/merge.vcf.gz"
bcftools index -t "${REGION_VCF_MERGE}${arg_id[0]}_merge_vcf/merge_sort.vcf.gz"