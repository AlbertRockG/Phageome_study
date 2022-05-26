#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Oct 30 15:07:49 2021
@author: Albert Rock G
"""
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
Home-made script to construct the taxonomy table
necessary for the phyloseq package in R
"""
    )

argcomplete.autocomplete(parser)

required_args = parser.add_argument_group('required arguments')
required_args.add_argument(
    '-r', metavar='PATH', required = True,
    help='Input the species abundance table file'
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

    res = os.system ("cat" +args.r+ " | cut \
                     -f1 | taxonkit name2taxid | sort -n | taxonkit \
                     lineage | taxonkit reformat \
                     -r 'Unassigned' -f '{p}\t{c}\t{o}\t{f}\t{g}\t{s}'| cut \
                     -f 1,3-10 > "+outdir+"Taxonomy_finals.csv")
    if res != 0:
        print("Taxonkit failed...")
        exit(1)