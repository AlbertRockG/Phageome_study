#!/usr/bin/env python
#Rohan Sachdeva: rsachdev@usc.edu
#Usage: cat input.fasta | python fastaToSaf.py
'''
In-house script designed to generate a SAF file type for use with
featureCounts. Reads in a FASTA file and uses the sequence ID
to generate the necessary tab-delimited file. Shared as part of the
ECOGEO Intro Omics Workshop 2016.

Rohan Sachdeva Github - https://github.com/rohansachdeva

Dependencies - Biopython

Alternative usage:
python fastaToSaf.py < INPUT.fasta > OUTPUT.saf
'''

from Bio import SeqIO
import sys

print 'GeneID	Chr	Start	End	Strand'

for record in SeqIO.parse(sys.stdin,'fasta'):
	seqLen = len(record.seq)
	start, stop = 1, seqLen
	geneId, Chr = str(record.id), str(record.id)
	outLine = [geneId, Chr, str(start), str(stop), '+']
	outLine = '\t'.join(outLine)
	print outLine