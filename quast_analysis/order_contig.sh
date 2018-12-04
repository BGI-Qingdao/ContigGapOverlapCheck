#!/bin/bash

echo "use quast file [ $1 ]"
awk -f quast_contig_classify.awk < $1
cat unique_contig.tsv | awk '{ if(NR%2==0){print $0} }' | sort -nk 1 >sorted_unique_contig.txt


