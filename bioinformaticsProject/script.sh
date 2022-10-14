#!/bin/bash
# hjeon
# Biocomputing Midsemester (Bash) Project
TEMPORARY_FILE='current_proteome'
CANDIDATE_FILE='candidate.txt'
SEARCH_OUTPUT_FILE='searchOutput.txt'
TABLE_OUTPUT_FILE='table.txt'
PROTEOMES='./proteomes/*'
REF_SEQUENCES='./ref_sequences/*'
MUSCLE='./tools/muscle'
HMMBUILD='./tools/hmmbuild'
HMMSEARCH='./tools/hmmsearch'
NUMBER=1
ORDER=''
echo -e "Proteome\thsp70\tmcrA" > $TABLE_OUTPUT_FILE

for PROTEOME in $PROTEOMES
do
    # parse proteome number
    if [ $NUMBER -lt 10 ]
    then
        ORDER="0$NUMBER"
    else
        ORDER="$NUMBER"
    fi

    # save names of HSP70 and mcrA files corresponding to this proteome number
    HSP70="./ref_sequences/hsp70gene_$ORDER".fasta
    MCRA="./ref_sequences/mcrAgene_$ORDER".fasta
    
    # record proteomeX name in table output on newline
    echo -n "proteome_$ORDER" >> $TABLE_OUTPUT_FILE
    if [ -f $HSP70 ]
    then
        # create alignments for HSP70 seqeuence using MUSCLE 
        $MUSCLE -in $HSP70 -out $TEMPORARY_FILE.fasta
        # build hmm profile for this alignment using HMMBUILD
        $HMMBUILD $TEMPORARY_FILE.fasta.hmm $TEMPORARY_FILE.fasta
	# search in tandem with HSP70 database sequence using HMMSEARCH
        $HMMSEARCH --tblout $SEARCH_OUTPUT_FILE $TEMPORARY_FILE.fasta.hmm $PROTEOME
    	
	# count number of HSP70 gene matches
	COUNT=$(cat $SEARCH_OUTPUT_FILE | wc -l)
	COUNT=$(echo "$COUNT - 13" | bc)
	    
	# record number of HSP70 matches to table output
	echo -ne "\t$COUNT" >> $TABLE_OUTPUT_FILE
    else
	echo -ne "\t0" >> $TABLE_OUTPUT_FILE
    fi

    # check if parsed mcrA file exists
    if [ -f $MCRA ]
    then
	# create alignments for mcrA seqeuence using MUSCLE
	$MUSCLE -in $MCRA -out $TEMPORARY_FILE.fasta
	# build hmm profile for this alignment using HMMBUILD
	$HMMBUILD $TEMPORARY_FILE.fasta.hmm $TEMPORARY_FILE.fasta
	# search in tandem with mcrA database sequence using HMMSEARCH
        $HMMSEARCH --tblout $SEARCH_OUTPUT_FILE $TEMPORARY_FILE.fasta.hmm $PROTEOME
	COUNT=$(cat $SEARCH_OUTPUT_FILE | wc -l)
	    # if match exists, record 1 to table output
	    if [[ $COUNT != 13 ]]
	    then    
		echo -e "\t1" >> $TABLE_OUTPUT_FILE
	    else
	    	echo -e "\t0" >> $TABLE_OUTPUT_FILE
	    fi
    else
	# if no match exists, record 0 to table output
	echo -e "\t0" >> $TABLE_OUTPUT_FILE
    fi

    # increment proteome number
    NUMBER=$(echo "$NUMBER + 1" | bc)
done

# record candidates in sorted order based on table_output.txt as stdin into candidate.txt
echo "Candidates in best to worst order: " > $CANDIDATE_FILE
cat $TABLE_OUTPUT_FILE | awk -v FS='\t' 'NR>1{ print $1 " " $2 " " $3 }' | sort -t ' '  -k3,3rn -k2,2rn | cut -d ' ' -f1 >> $CANDIDATE_FILE