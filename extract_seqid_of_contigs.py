#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Sep 18 10:11:05 2021

@author: Albert Rock G
"""

import argcomplete
import errno
import os
import sys
import argparse
import csv
from Bio import SeqIO

my_viruses = list()

parser = argparse.ArgumentParser(
        description =
        """
Command line application just retrieve seq.id of each representative contigs
obtained after running the cd-hit-est software   

"""
)

argcomplete.autocomplete(parser)

required_args = parser.add_argument_group("required arguments")

required_args.add_argument(
        "-j", metavar="PATH TO CONTIGS FASTA FILE", required = True, 
        help = "Please input the contigs fasta file"
)

required_args.add_argument(
        "-o", metavar="PATH TO THE OUTPUT DIRECTORY", required = True, 
        help = "Please provid an output directory"
)

if len(sys.argv)<=1:
    parser.print_help(sys.stderr)
    sys.exit(1)
else:
    args = parser.parse_args(sys.argv[1:])
    base = os.path.basename(args.j)
    name_file = os.path.splitext(base)[0]
    dirname = os.path.dirname(os.path.abspath(__file__))
    outdir = args.o

    try:
        os.makedirs(outdir)
    except OSError as e:
        if e.errno != errno.EEXIST:
            raise

    
    name = os.path.join(outdir, name_file)
    with open(args.j) as fasta_file:
        for record in SeqIO.parse(fasta_file, "fasta"):
            my_record = record.description.split("|")
            my_viruses.append(my_record)


mycsv_file = name +"_taxid.csv"
with open(mycsv_file, mode = "w+") as my_csv:
    csv_writer = csv.writer(my_csv, delimiter = "\t")
    for row in my_viruses:
        csv_writer.writerow(row)
        
