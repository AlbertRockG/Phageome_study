#!/usr/bin/env bash
# -*- coding: utf-8 -*-
# by AlbertRockG

cd ~/Documents/Replic_study || exit

for fastq_1 in **/*R1.fq.gz
do
    mydirname="$(dirname -- "$fastq_1")"
    myfilename="${fastq_1##*/}"
    tmp=${myfilename%%_*}
    fastq_2=${fastq_1/R1/R2}
    echo "Indexing the non redundant viral contigs"
    bowtie2-build "$mydirname"/"$tmp"_nr_viral_contigs_.fasta \
    "$mydirname"/"$tmp"_nr_viral_contigs_.index
    echo "Mapping the reads on the non redundant viral contigs"
    bowtie2 -q -1 "$fastq_1" -2 "$fastq_2" -S "$mydirname"/"$tmp".sam \
        -x "$mydirname"/"$tmp"_nr_viral_contigs_.index --no-unal -p 8
done
