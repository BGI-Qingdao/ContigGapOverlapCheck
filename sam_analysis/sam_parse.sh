awk '{if(NF >10 && $1 != $3 ) { print $0 } }' 
