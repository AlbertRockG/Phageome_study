#!/bin/bash

# -*- coding: utf-8 -*-

# by Albertrock



cat KIS10/KIS10_nr_viral_contigs_.csv | grep 'NODE' | cut -f 1,7 > KIS10/KIS10_nr_viral_contigs_counts.csv
