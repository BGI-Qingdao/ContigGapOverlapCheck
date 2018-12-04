#!/bin/bash

echo "use quast file [ $1 ]"
## check contig info 
awk -f quast_contig_classify.awk < $1
## check 2 neib contig info 
cat unique_contig.tsv | awk '{ if(NR%2==0){print $0} }' | sort -k 5 -kn 1  >sorted_unique_contig.txt
awk -f overlap_detect.awk <sorted_unique_contig.txt
## print hist
cat overlap_info.txt | awk '{print $18}' | sort | uniq -c |  sort -nk 2 >overlap_hist.txt
cat gap_info.txt | awk '{print $18}' | sort | uniq -c |  sort -nk 2 >gap_hist.txt
cat contain_info.txt | awk '{print $18}' | sort | uniq -c |  sort -nk 2 >contain_hist.txt