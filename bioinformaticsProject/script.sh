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
    
    # create alignments for proteome seqeuence using MUSCLE 
    $MUSCLE -in $PROTEOME -out $TEMPORARY_FILE.fasta -maxiters 1 -diags1 -sv -distance1 kbit20_3

    # build hmm profile for this alignment using HMMBUILD
    $HMMBUILD $TEMPORARY_FILE.fasta.hmm $TEMPORARY_FILE.fasta

    # record proteomeX name in table output on newline
    echo -n "proteome$ORDER" >> $TABLE_OUTPUT_FILE
    
    # check if parsed HSP70 file exists; if so, search in tandem with HSP70 database sequence using HMMSEARCH
    if [ -f $HSP70 ]
    then
        $HMMSEARCH --tblout $SEARCH_OUTPUT_FILE $TEMPORARY_FILE.fasta.hmm $HSP70
    fi

    # count number of HSP70 gene matches
    RESULT="#"
    # remove trailing whitespace from 4th line extracted
    RESULT=$(sed -n "4p" < $SEARCH_OUTPUT_FILE) | xargs
    if [[ $RESULT != "#" ]]
    then
        COUNT=0
        for line in $SEARCH_OUTPUT_FILE
        do
            # remove trailing whitespace from $line
            if [[ $(echo $line | xargs) == "# Program:         hmmsearch" ]]
            then
                break
	    fi
            COUNT=$(echo "$COUNT + 1" | bc)
        done
        COUNT=$(echo "$COUNT - 3" | bc)
        
        # record number of HSP70 matches to table output
        echo -ne "\t$COUNT" >> $TABLE_OUTPUT_FILE
    else
        # record 0 for no match in HSP70
        echo -ne "\t0" >> $TABLE_OUTPUT_FILE
    fi

    # check if parsed mcrA file exists; if so, search in tandem with mcrA database sequence using HMMSEARCH
    if [ -f $MCRA ]
    then
        $HMMSEARCH --tblout $SEARCH_OUTPUT_FILE $TEMPORARY_FILE.fasta.hmm $MCRA
    fi

    # check for any matches with mcrA gene
    RESULT="#"
    RESULT=$(sed -n "4p" < $SEARCH_OUTPUT_FILE) | xargs
    if [[ $RESULT != "#" ]]
    then
        # if match exists, record 1 to table output
        echo -e "\t1" >> $TABLE_OUTPUT_FILE
    else
        # if no match exists, record 0 to table output
        echo -e "\t0" >> $TABLE_OUTPUT_FILE
    fi
    
    # increment proteome number
    NUMBER=$(echo "$NUMBER + 1" | bc)
done

# record candidates in sorted order based on table_output.txt as stdin into candidate.txt
echo "Candidates in best to worst order: " > $CANDIDATE_FILE
echo -e "Proteome\tHSP70\tmcrA" >> $CANDIDATE_FILE
cat $TABLE_OUTPUT_FILE | awk -v FS='\t' 'NR>1{ print $1 " " $2 " " $3 }' | sort -t ' ' -k3,3n -k2,2n | cut -d ' ' -f1 >> $CANDIDATE_FILE
