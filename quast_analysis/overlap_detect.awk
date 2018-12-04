#!/usr/bin/env awk
BEGIN {
    prev_ref=""
    prev_contig="NONE";
    prev_start=0;
    prev_end=0;
    prev_line=""

    gap_file="gap_info.txt"
    overlap_file="overlap_info.txt"
    contain_file="contain_info.txt"

    gap_num = 0;
    overlap_num = 0;
    contain_num = 0;
    total_num = 0 ;
    ref_num=0;
}
{
    curr_ref=$5
    curr_start=$1
    curr_end=$2
    curr_line=$0;
    if( curr_ref != prev_ref )
    {
        # restart a new ref
        prev_ref =curr_ref;
        prev_start=curr_start;
        prev_end=curr_end;

        prev_contig=$6;
        prev_line=curr_line;
        ref_num = ref_num + 1;
    }
    else 
    {
        total_num = total_num + 1;
        if( curr_start > prev_end )
        {
            # gap here 
            printf("%s\t--\t%s\t%d\n",prev_line,curr_line , prev_end - curr_start + 1) >>gap_file
            prev_ref =curr_ref;
            prev_start=curr_start;
            prev_end=curr_end;

            prev_contig=$6;
            prev_line=curr_line;

            gap_num = gap_num + 1;
        }
        else if ( curr_start >= prev_start && curr_end > prev_end && curr_start <= prev_end )
        {
            # overlap here
            printf("%s\t--\t%s\t%d\n",prev_line,curr_line , prev_end - curr_start +1 ) >>overlap_file
            prev_ref =curr_ref;
            prev_start=curr_start;
            prev_end=curr_end;

            prev_contig=$6;
            prev_line=curr_line;

            overlap_num = overlap_num + 1;
        }
        else
        {
            printf("%s\t--\t%s\t%d\n",prev_line,curr_line , curr_end-curr_start+1) >>contain_file
            contain_num = contain_num + 1 ;
            # contain here
        }
    }
}
END {
    printf(" Ref        num %d \n",ref_num);
    printf(" Total      num %d \n",total_num);
    printf(" Gap        num %d \n",gap_num);
    printf(" Overlap    num %d \n",overlap_num);
    printf(" Contain    num %d \n",contain_num);
}
