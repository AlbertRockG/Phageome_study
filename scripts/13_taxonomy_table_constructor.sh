#!/bin/env bash 
# -*- coding: utf-8 -*-
#########################################################################
# Created on Tue Aug 31 14:31:04 2021                                   #
# @author: AlbertRockG                                                  # 
#                                                                       #
# Take species abundance table and builds taxonomic table               #
# Usage: 13_taxonomy_table_constructor.sh COMPIL.csv Taxonomy_finals.csv#
#########################################################################

set -e

input_file=$1
output_file=$2

cut -f1 < "$input_file" | taxonkit name2taxid \
        | sort -n | taxonki lineage | taxonkit reformat -r \
        'Unassigned' -f '{p}\t{c}\t{o}\t{f}\t{g}\t{s}'\
        | cut -f 1,3-10 > "$output_file"
