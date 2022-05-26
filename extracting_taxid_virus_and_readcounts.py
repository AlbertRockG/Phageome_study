#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Aug 31 14:31:04 2021

@author: AlbertrockG
"""
import errno
import argcomplete
import os
import sys
import argparse
import csv

taxid_counts = list()
parser = argparse.ArgumentParser(
    description=
    """
Parse two csv files containing readcounts and TaxID and return a file
in which each TaxID corresponds to its counts (reads assignments)
"""
    )

argcomplete.autocomplete(parser)

required_args = parser.add_argument_group('required arguments')
required_args.add_argument(
    '-r', metavar='PATH', required = True,
    help='Input the contigs and the readcount of each virus file'
    )
required_args.add_argument(
    '-t', metavar='PATH', required = True,
    help='Input the contigs-taxid-viruses file'
    )
required_args.add_argument(
    '-o', default=sys.stdout,
        metavar='PATH', required = True, help='Output directory'
        )   
if len(sys.argv)<=1:
    parser.print_help(sys.stderr)
    sys.exit(1)
else:
    args = parser.parse_args(sys.argv[1:])
    base = os.path.basename(args.r)
    name_file = os.path.splitext(base)[0]
    dirname = os.path.dirname(os.path.abspath(__file__))
    outdir = args.o

    try:
        os.makedirs(outdir)
    except OSError as e:
        if e.errno != errno.EEXIST:
            raise

    name = os.path.join(outdir, name_file)


    with open(args.r) as counts:
        csv_reader_1 = list(csv.reader(counts, delimiter = "\t"))
        for line in csv_reader_1:
            with open(args.t) as taxids:
                csv_reader_2 = list(csv.reader(taxids, delimiter = "\t"))
                for l in csv_reader_2 :
                    if line[0].strip() == l[0].strip():
                        new_line = [l[2], line[1]]
                        taxid_counts.append(new_line)
    
    result_file = name +"_viruses_counts.csv"
    with open(result_file, mode='w+') as output_csv:
        csv_writer = csv.writer(output_csv, delimiter='\t')
        for row in taxid_counts:
            csv_writer.writerow(row)