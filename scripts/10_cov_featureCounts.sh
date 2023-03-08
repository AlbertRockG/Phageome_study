#!/bin/bash
# -*- coding: utf-8 -*-
# by Albert Rock G

cd ~/Documents/Replic_study || exit

for sam_file in **/*.sam
do
    mydirname="$(dirname -- "$sam_file")"
    myfilename="$(basename -- "$sam_file")"
    tmp=${myfilename%.*}

    featureCounts -p -F SAF \
        -a "$mydirname"/"$tmp"_nr_viral_contigs_.saf \
        -o "$mydirname"/"$tmp"_nr_viral_contigs_.csv \
        "$mydirname"/"$tmp".sam
done
