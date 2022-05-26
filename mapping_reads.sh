#!/bin/bash

# -*- coding: utf-8 -*-

# by Albertrock


bowtie2 -q -1 KIS10/KIS10_R1.fq.gz -2 KIS10/KIS10_R2.fq.gz -S KIS10/KIS10.sam -x KIS10/KIS10_nr_viral_contigs_.index --no-unal -p 8

