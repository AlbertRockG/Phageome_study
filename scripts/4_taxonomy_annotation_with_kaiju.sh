#!/bin/bash
# -*- coding: utf-8 -*-
# by Albert Rock G

input_dir=$1 # Parent directory of the metaspades output directory
output_dir=$2 
kaiju_location_dir=$3
kaijudb_dir=$4

for fasta in "$input_dir"/**/*_contigs.fasta
do
    myfilename="${fasta##*/}"
    tmp=${myfilename%%_*}

    if [ "${#myfilename}" -le 19 ]
    then
        kaiju -t "$kaijudb_dir"/nodes.dmp \
            -f "$kaijudb_dir"kaiju_db_viruses.fmi \
            -i "$fasta" \
            -a greedy -z 8 -E 0.001 > "$output_dir"/"$tmp"_0.001_kaijuvirusesdb.out


        # To add the viruses names according to taxonomy identification
        cd "$kaiju_location_dir" || exit

        ./kaiju-addTaxonNames -t "$kaijudb_dir"kaijudb/nodes.dmp \
            -n "$kaijudb_dir"names.dmp \
            -i "$output_dir"/"$tmp"_0.001_kaijuvirusesdb.out \
            -o "$output_dir"/"$tmp"_0.001_kaijuvirusesdb-names.out
       fi
done
