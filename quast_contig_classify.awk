#!/usr/bin/env awk
#
# @Brief    :
#   classify contig by quast all_alignments_sz.tsv file.
# @Input    :
#   all_alignments_sz.tsv
# @Output   :
#   unique_contig.tsv
#   other_contig.tsv
# @Define   :
#   a contig is NOT a unique contig if it has MORE THAN 1
#   match information in all_alignments_sz.tsv.
#

BEGIN {
    total_map= 0 ;
    total_contig= 0 ;
    unique_contig = 0 ;
    other_contig=0;
    other_map = 0 ;
    prev_contig="NONE"
    ufile="unique_contig.tsv";
    ofile="other_contig.tsv";
    arrayIndex= 0;
}
{
    if( NR == 1 )
    {
        print $0 >ufile
        print $0 >ofile
    }
    else if( NF != 8  )
    {
        array_2[arrayIndex]=$0;
        arrayIndex = arrayIndex + 1 ;
        total_map = total_map + 1 ;
    }
    else
    {
        curr_contig = $6 ;
        if ( curr_contig != prev_contig )
        {
            # print prev contig map information
            if( arrayIndex == 1 )
            {
                print array_1[0] >>ufile;
                print array_2[0] >>ufile;
                unique_contig = unique_contig + 1 ;
            }
            else if ( arrayIndex > 1 )
            {
                for( i in array_1 )
                {
                    print array_1[i] >>ofile;
                    print array_2[i] >>ofile;
                    other_map = other_map + 1 ;
                }
                other_contig = other_contig + 1 ;
            }
            else {
                if ( prev_contig != "NONE" )
                {
                    print "ERROR"
                }
            }
            arrayIndex = 0 ;
            prev_contig = curr_contig ;
            total_contig = total_contig + 1 ;
            delete array_1 ;
            delete array_2 ;
        }
        # save curr contig map information
        array_1[arrayIndex] = $0
    }
}
END {
    # print prev contig map information
    if( arrayIndex == 1 )
    {
        print array_1[0] >>ufile;
        print array_2[0] >>ufile;
        unique_contig = unique_contig + 1 ;
    }
    else if ( arrayIndex > 1 )
    {
        for( i in array_1 )
        {
            print array_1[i] >>ofile;
            print array_2[i] >>ofile;
            other_map = other_map + 1 ;
        }
        other_contig = other_contig + 1 ;
    }
    else { ; }

    printf( "Total contig num is %u \n", total_contig );
    printf( "Total contig map is %u \n", total_map);
    printf( "Unique contig num is %u \n", unique_contig);
    printf( "Other contig num is %u \n", other_contig );
    printf( "Other contig map is %u \n", other_map);
}
