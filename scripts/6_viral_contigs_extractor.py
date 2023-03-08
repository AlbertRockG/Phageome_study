#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Aug 23 16:22:13 2021

@author: AlberTrock
"""
import argcomplete
import errno
import os
import sys
import argparse
import csv
from Bio import SeqIO

desired_contigs = list()
parser = argparse.ArgumentParser(
        description="""
This app extracts the contigs that hit a virus taxon.
It takes two input files:
    - A tsv file obtained after ""grep "C" kaiju_output.out""
    - Metaspades output fasta file (contigs.fasta)

And produces a fasta file with corresponding contigs.
"""
)

argcomplete.autocomplete(parser)

required_args = parser.add_argument_group("required arguments")

required_args.add_argument(
        "-i", metavar="PATH TO TSV FILE", required=True,
        help="Please input the tsv file"
)

required_args.add_argument(
        "-j", metavar="PATH TO CONTIGS FASTA FILE", required=True,
        help="Please input the contigs fasta file"
)

required_args.add_argument(
        "-o", metavar="PATH TO THE OUTPUT DIRECTORY", required=True,
        help="Please provid an output directory"
)

if len(sys.argv) <= 1:
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
            seq_identifier = record.id.strip()
            with open(args.i) as tsv_file:
                my_tsv = csv.reader(tsv_file, delimiter="\t")
                for virus in my_tsv:
                    if seq_identifier == virus[0].strip():
                        record.id = " | ".join(virus[0:])
                        record.description = ""
                        desired_contigs.append(record)

    my_fasta_file = name + "_viral_contigs.fasta"

    # Writing the viral contigs fasta file

    SeqIO.write(desired_contigs, my_fasta_file, "fasta")
