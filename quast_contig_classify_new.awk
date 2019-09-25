#!/usr/bin/env awk
#
# @Brief    :
#   classify contig by quast all_alignments_sz.tsv file.
# @Input    :
#   all_alignments_sz.tsv
# @Output   :
#   unique_contig.tsv ; notice that chain-aligned infomation will be merged into 1 aligned.
#   other_contig.tsv
# @Define   :
#   a contig is NOT a unique contig if it not "CONTIG xxx xxx correct" by quast.
#   match information in all_alignments_sz.tsv.
#

BEGIN {
    total_map= 0 ;
    total_contig= 0 ;
    unique_contig = 0 ;
    unique_map=0;
    other_contig=0;
    other_map = 0 ;

    ufile="unique_contig.tsv";
    ofile="other_contig.tsv";

    arrayIndex= 0;
}
{
    if( NR == 1 )
    {
        print $0 >ufile ;
        print $0 >ofile ;
    }
    else if( NF != 8  )
    {
        if ( $1 == "CONTIG" )
        {
            total_map=total_map+1;

            contig_name =  $2;
            contig_len = $3;
            contig_type= $4;
            if( contig_type == "correct" )
            {
                if( arrayIndex == 0 )
                {
                    print array_1[0] >>ufile;
                    print $0 >>ufile;
                    unique_map = unique_map +1 ;
                }
                else
                {
                    unique_map = unique_map + arrayIndex +1 ;
# merge all aligned-chain into 1
                    ref_final_begin=-1 ;
                    ref_final_end = -1 ;
                    contig_0 = -1 ;
                    contig_1 = -1 ;
                    if( contig_begin[0] < contig_end[0] )
                        orient=1;
                    else
                        orient=0;
                    for( i in ref_begin ) 
                    {
                        if ( ref_begin[i] < ref_final_begin || ref_final_begin == -1 )
                        {
                            ref_final_begin = ref_begin[i] ;
                        }
                        if( ref_end[i] > ref_final_end )
                        {
                            ref_final_end = ref_end[i] ;
                        }
                        if( orient == 1 )
                        {
                            if( contig_begin[i] < contig_0 || contig_0 == -1 )
                            {
                                contig_0 = contig_begin[i];
                            }
                            if( contig_end[i] > contig_1 )
                            {
                                contig_1 = contig_end[i];
                            }
                        }
                        else
                        {
                            if( contig_begin[i] >contig_0 )
                            {
                                contig_0 = contig_begin[i] ;
                            }
                            if( contig_end[i] < contig_1 || contig_1 == -1 )
                            {
                                contig_1 = contig_end[i];
                            }
                        }
                    }
                    printf("%d\t%d\t%d\t%d\t%s\t%s\t%s\t\t%s\n",
                            ref_final_begin,
                            ref_final_end,
                            contig_0,
                            contig_1,
                            ref[0],
                            contig[0],
                            ambi[0],
                            best[0]) >>ufile;
                    print $0 >>ufile;
                }
                unique_contig = unique_contig + 1 ;
            }
            else
            {
                for( i in array_1 )
                {
                    print array_1[i] >>ofile;
                    if ( i < arrayIndex ) 
                    {
                        print array_2[i] >>ofile;
                    }
                    other_map = other_map + 1 ;
                }
                print $0 >> ofile;
                other_contig = other_contig + 1 ;
            }
            arrayIndex = 0 ;
            total_contig = total_contig + 1 ;
            delete array_1 ;
            delete array_2 ;
            delete ref_begin ;
            delete ref_end ;
            delete contig_begin ;
            delete contig_end ;
            delete ref ;
            delete contig ;
            delete ambi ;
            delete best ;
        }
        else
        {
# save local details 
            array_2[arrayIndex]=$0;

            total_map = total_map + 1 ;
            arrayIndex = arrayIndex + 1 ;
        }
    }
    else
    {
# save curr contig map information
        array_1[arrayIndex] = $0
# save info details for chain merge.
            ref_begin[arrayIndex]=$1;
            ref_end[arrayIndex]=$2;
            contig_begin[arrayIndex]=$3;
            contig_end[arrayIndex]=$4;
            ref[arrayIndex]=$5;
            contig[arrayIndex]=$6;
            ambi[arrayIndex]=$7;
            best[arrayIndex]=$8;
    }
}
END {

    printf( "Total   contig num is %u \n", total_contig );
    printf( "Total   contig map is %u \n", total_map);
    printf( "Unique  contig num is %u \n", unique_contig);
    printf( "Unique  contig map is %u \n", unique_map);
    printf( "Other   contig num is %u \n", other_contig );
    printf( "Other   contig map is %u \n", other_map);
}
