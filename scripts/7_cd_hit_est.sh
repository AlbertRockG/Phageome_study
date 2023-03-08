#!/bin/bash
# -*- coding: utf-8 -*-
# by Albert Rock G

set -e

input_dir=$1 # Parent dir viral contigs directories
output_dir=$2 # May be input_dir or not (up to you)

cd "$input_dir" || exit

for viral_fasta in "$input_dir"/**/*viral_contigs.fasta
do
    myfilename="${viral_fasta##*/}"
    tmp=${myfilename%%_*}
    mkdir -p "$output_dir"/"$tmp"

    cd-hit-est -i "$viral_fasta" \
        -o "$output_dir"/"$tmp"/"$tmp"_nr_viral_contigs_.fasta \
        -T 8 -M 15000 -c 0.95 -n 10
done
