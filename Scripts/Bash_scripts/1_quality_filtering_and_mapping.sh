#!/usr/bin/env bash
# -*- coding: utf-8 -*-
# by Albert Rock G

set -e

input_dir=$1
fastp_out_dir=$2
index_dir=$3
subjunc_out_dir=$4

cd "$input_dir" || exit

for fastq_1 in *R1.fastq.gz; do
    [[ -e "$fastq_1" ]] || break # handle the case of no *R1.fastq.gz files

    FileName=${fastq_1%.*}
    tmp=${FileName%%_*}
    fastq_2=${fastq_1/R1/R2}
 
# run fastp on raw reads after QC check
    fastp \
        --in1 "$input_dir"/"$fastq_1" \
        --in2 "$input_dir"/"$fastq_2" \
        --out1 "$fastp_out_dir"/"$tmp"_R1_fastp.fastq.gz \
        --out2 "$fastp_out_dir"/"$tmp"_R2_fastp.fastq.gz \
        -q 20 \
        -h "$fastp_out_dir"/"$tmp"_fastp.html \
        -l 50 \
        --trim_poly_g \
        --trim_poly_x

# run the mapping on the repaired reads

        subjunc -T 8 -M 5 \
            -r "$fastp_out_dir"/"$tmp"_R1_fastp.fastq.gz \
            -R "$fastp_out_dir"/"$tmp"_R2_fastp.fastq.gz \
            -i "$index_dir"/VectorBase-48_AgambiaePEST_Genome_index \
            -o "$subjunc_out_dir"/"$tmp".bam

done
