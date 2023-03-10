#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Oct 29 19:46:37 2021
@author: Albert Rock G
"""
import pandas as pd
import os
from pathlib import Path
import argcomplete
import errno
import sys
import argparse

df8 = pd.DataFrame()

parser = argparse.ArgumentParser(
    description="""
Home-made Python3 script to process and merge the counts files
to construct the species_abondunt.csv file.
"""
)

argcomplete.autocomplete(parser)

required_args = parser.add_argument_group("required arguments")

required_args.add_argument(
    "-o", metavar="PATH TO THE OUTPUT DIRECTORY", required=True,
    help="Please provid an output directory"
)

if len(sys.argv) <= 1:
    parser.print_help(sys.stderr)
    sys.exit(1)
else:
    args = parser.parse_args(sys.argv[1:])
    outdir = args.o
    try:
        os.makedirs(outdir)
    except OSError as e:
        if e.errno != errno.EEXIST:
            raise

os.chdir(args.o)

working_dir = Path()

for path in working_dir.glob("**/*_nr_viral_contigs_.csv"):
    # open the csv file outpots by featureCounts program
    df1 = pd.read_csv(
        path.absolute(), sep="\t", comment='#',
        skiprows=1, skipinitialspace=True
    )
    mydirname = path.parent
    df2 = df1.loc[:, ["Chr", str(mydirname) + "/" + str(mydirname) + ".sam"]]
    df3 = df2.rename(
        columns={"Chr": "Contigs_id", str(mydirname) + "/"
                 + str(mydirname) + ".sam": str(mydirname)}
    )
    df3["Contigs_id"] = df3["Contigs_id"].str.strip()
    # open the csv file output by
    # contids_id_taxid_and_species_extractor.py
    # (Home-made script)
    df4 = pd.read_csv(
        outdir+str(mydirname) + "/"+str(mydirname) +
        "_nr_viral_contigs__taxid.csv", sep="\t",
        names=["Contigs_id", "Taxid", "Species"],
        skipinitialspace=True
    )
    df4["Contigs_id"] = df4["Contigs_id"].str.strip()
    df5 = pd.merge(df4, df3, how="inner", on="Contigs_id")
    df6 = df5.loc[:, ["Species", str(mydirname)]]
    # save the dataframe according to
    df7.to_csv(outdir + str(mydirname) + ".csv", sep="\t")
    if df8.empty:
        df8 = df7
    else:
        df8 = pd.merge(
            df8, df7, right_on="Species", left_on="Species", how="outer"
        )
