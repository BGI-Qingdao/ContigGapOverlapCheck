#!/bin/bash

echo "use quast file [ $1 ]"
## check contig info 
awk -f quast_contig_classify_new.awk < $1
## check 2 neib contig info 
cat unique_contig.tsv | awk '{ if(NR%2==0){print $0} }' | sort -k5,5 -k1,1n  >sorted_unique_contig.txt
awk -f overlap_detect.awk <sorted_unique_contig.txt
## print hist
cat overlap_info.txt | awk '{ if(NF>1){ print $18}}' | sort | uniq -c |  sort -nk 2 >overlap_hist.txt
cat gap_info.txt | awk '{ if(NF>1)  {print $18}}' | sort | uniq -c |  sort -nk 2 >gap_hist.txt
cat contain_info.txt | awk '{ if(NF>1) {print $18}}' | sort | uniq -c |  sort -nk 2 >contain_hist.txt
