#!/bin/bash

# Velocyto run for spliced/unspliced loom files from 10x data
# conda activate velocyto.0.17.17
# sbatch --array=0-26 velocyto.sh

#SBATCH --partition=shortq
#SBATCH --qos=shortq
#SBATCH --mem=200G
#SBATCH --job-name=velocyto
#SBATCH --cpus-per-task=16
#SBATCH -o %x_%a.out
#SBATCH -e %x_%a.err

module load SAMtools

cd /research/peer/fdeckert/FD20250213HSCT/

ref_gtf="/nobackup/peer/fdeckert/cellranger/GRCh38-2020-A/GRCh38/genes/genes.gtf"
out_dir="/research/peer/fdeckert/FD20250213HSCT/data/object/velocyto"

mkdir -p "$out_dir"

sample_dirs=(

    /research/lab_stary/sequencing_projects/hsct/COUNT/S_7631_baseline_transcriptome
    /research/lab_stary/sequencing_projects/hsct/COUNT/S_7632_day0_transcriptome
    /research/lab_stary/sequencing_projects/hsct/COUNT/S_7633_day14_transcriptome
    /research/lab_stary/sequencing_projects/hsct/COUNT/S_7641_baseline_transcriptome
    /research/lab_stary/sequencing_projects/hsct/COUNT/S_7642_day0_transcriptome
    /research/lab_stary/sequencing_projects/hsct/COUNT/S_7661_baseline_transcriptome
    /research/lab_stary/sequencing_projects/hsct/COUNT/S_7662_day0_transcriptome
    /research/lab_stary/sequencing_projects/hsct/COUNT/S_7663_day14_transcriptome
    /research/lab_stary/sequencing_projects/hsct/COUNT/S_7664_day100_transcriptome
    /research/lab_stary/sequencing_projects/hsct/COUNT/S_7681_baseline_transcriptome
    /research/lab_stary/sequencing_projects/hsct/COUNT/S_7682_day0_transcriptome
    /research/lab_stary/sequencing_projects/hsct/COUNT/S_7683_day14_transcriptome
    /research/lab_stary/sequencing_projects/hsct/COUNT/S_7684_day100_transcriptome
    /research/lab_stary/sequencing_projects/hsct/COUNT/HSCT_7831_transcriptome
    /research/lab_stary/sequencing_projects/hsct/COUNT/HSCT_7833_transcriptome
    /research/lab_stary/sequencing_projects/hsct/COUNT/HSCT_7834_transcriptome
    /research/lab_stary/sequencing_projects/hsct/COUNT/HSCT_7841_transcriptome
    /research/lab_stary/sequencing_projects/hsct/COUNT/HSCT_7843_transcriptome
    /research/lab_stary/sequencing_projects/hsct/COUNT/HSCT_7851_transcriptome
    /research/lab_stary/sequencing_projects/hsct/COUNT/HSCT_7853_transcriptome
    /research/lab_stary/sequencing_projects/hsct/COUNT/HSCT_7854_transcriptome
    /research/lab_stary/sequencing_projects/acute_gvhd/COUNT/CoR_GvD_04_transcriptome
    /research/lab_stary/sequencing_projects/acute_gvhd/COUNT/CoR_GVD_07_transcriptome
    /research/lab_stary/sequencing_projects/acute_gvhd/COUNT/CoR_GVD_08_transcriptome
    /research/lab_stary/sequencing_projects/acute_gvhd/COUNT/CoR_GVD_09_transcriptome
    /research/lab_stary/sequencing_projects/acute_gvhd/COUNT/CoR_GvD_13_GvD117_transcriptome
    /research/lab_stary/sequencing_projects/acute_gvhd/COUNT/GvD_116_784_transcriptome
    
)

sample_dir="${sample_dirs[$SLURM_ARRAY_TASK_ID]}"
sample_name="$(basename "$sample_dir")"

barcode_tsv="${sample_dir}/filtered_feature_bc_matrix/barcodes.tsv.gz"
barcode_bam="${sample_dir}/possorted_genome_bam.bam"

sample_out_dir="${out_dir}/${sample_name}"
mkdir -p "$sample_out_dir"

cp "$barcode_bam" "${sample_out_dir}/possorted_genome_bam.bam"
cp "${barcode_bam}.bai" "${sample_out_dir}/possorted_genome_bam.bam.bai"

bam_file="${sample_out_dir}/possorted_genome_bam.bam"

velocyto run \
    -l "Permissive10X" \
    -@ "$SLURM_CPUS_PER_TASK" \
    --samtools-memory 100 \
    -b "$barcode_tsv" \
    -o "$sample_out_dir" \
    -e "velocyto" \
    "$bam_file" \
    "$ref_gtf"