#!/bin/bash

# -*- coding: utf-8 -*-

# by Albertrock


cd-hit-est -i KIS10/KIS10_contigs_viral_contigs.fasta -o KIS10/KIS10_nr_viral_contigs_.fasta -T 8 -M 15000 -c 0.95 -n 10

