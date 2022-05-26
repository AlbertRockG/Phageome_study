#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# by Albertrock G
"""
Created on Tue Aug 31 14:31:04 2021

@author: AlbertrockG
"""
import errno
import argcomplete
import os
import sys
import argparse

parser = argparse.ArgumentParser(
    description=
    """
Extract the contigs, the taxid and virus name from the
output of kaiju-addnames
"""
    )

argcomplete.autocomplete(parser)

required_args = parser.add_argument_group('required arguments')
required_args.add_argument(
    '-r', metavar='PATH', required = True,
    help='Input the output file of kaiju-addnames with the extension .out'
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

    print ("greping...")
    res = os.system ("grep 'C' " + args.r + " | cut -f2,3,4 >" +name+"_taxid_virusnames.csv" )
    if res != 0:
        print ("grep failed")
        exit(1)
