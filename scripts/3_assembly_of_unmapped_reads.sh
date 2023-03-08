#!/bin/bash
# -*- coding: utf-8 -*-
# by Albert Rock G

set -e

input_dir=$1
output_dir=$2
memory=$3

cd "$input_dir" || exit

for fastq_1 in *R1.fq.gz
do
    FileName=${fastq_1%.*}
    tmp=${FileName%%_*}
    fastq_2=${fastq_1/R1/R2}

    metaspades --memory "$memory" \
        -1 "$input_dir"/"$fastq_1" \
        -2 "$input_dir"/"$fastq_2" \
        -o "$output_dir"/"$tmp"/ -t 8
done
