#!/bin/bash
# -*- coding: utf-8 -*-
# by Albert Rock G

set -e 

input_dir=$1
output_dir=$2

cd "$input_dir" || exit

for my_bam in *.bam; do
    [[ -e "$my_bam" ]] || break # handle the case of no *.bam files
    FileName=${my_bam%.*}
    tmp=${FileName%%_*}

    samtools view -b -@ 8 -f12 "$input_dir"/"$my_bam"| samtools sort -n | samtools fastq -c 6 -1 "$output_dir"/"$tmp".R1.fq.gz -2 "$output_dir"/"$tmp".R2.fq.gz -0 /dev/null -s /dev/null -n

done
