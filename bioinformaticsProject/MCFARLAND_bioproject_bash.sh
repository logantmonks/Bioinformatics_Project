#!/bin/sh


# ssh tmcfarl2@crcfe01.crc.nd.edu

# useful commands for tool help
# ~/Private/Biocomputing2022/tools/hmmbuild -h
# ~/Private/Biocomputing2022/tools/hmmsearch -h
# ~/Private/Biocomputing2022/tools/muscle -h

# shortens path names :), change path as necessary to fit your directories
projectFolder=~/Private/Biocomputing2022/Bioinformatics_Project/bioinformaticsProject

# set critical threshold for hsp70 gene matches
hsp70threshold=2

# uncomment lines below to wipe directories before script runs
rm ${projectFolder}/setup/*
rm ${projectFolder}/processed/*
rm ${projectFolder}/ref_sequences/hsp70gene_all.fasta
rm ${projectFolder}/ref_sequences/mcrAgene_all.fasta

# run 
# # " mkdir ${projectFolder}/processed " 
# and 
# " mkdir ${projectFolder}/setup " 
# without quotes if you never have before

# combine hsp70gene_* files
for file in ${projectFolder}/ref_sequences/hsp70gene_*;
do
cat $file >> ${projectFolder}/ref_sequences/hsp70gene_all.fasta
done

# combine mcrAgene_* files
for file in ${projectFolder}/ref_sequences/mcrAgene_*;
do
cat $file >> ${projectFolder}/ref_sequences/mcrAgene_all.fasta
done


# align combined files for hmmer build. new aligned files in ${projectFolder}/
~/Private/Biocomputing2022/tools/muscle -in ${projectFolder}/ref_sequences/hsp70gene_all.fasta -out ${projectFolder}/setup/aligned_hsp70gene_all.fasta
~/Private/Biocomputing2022/tools/muscle -in ${projectFolder}/ref_sequences/mcrAgene_all.fasta -out ${projectFolder}/setup/aligned_mcrAgene_all.fasta

# hmmer builds, build files in ${projectFolder}/
~/Private/Biocomputing2022/tools/hmmbuild ${projectFolder}/setup/hmm_hsp70gene_all.fasta ${projectFolder}/setup/aligned_hsp70gene_all.fasta
~/Private/Biocomputing2022/tools/hmmbuild ${projectFolder}/setup/hmm_mcrAgene_all.fasta ${projectFolder}/setup/aligned_mcrAgene_all.fasta

# put temp files in place, act as variables for hmmer
#touch ${projectFolder}/setup/tempMatchhsp70gene.out
#touch ${projectFolder}/setup/tempMatchmcrAgene.out

echo "proteome_file,mcrA_match,hsp70_matches" >> ${projectFolder}/processed/summary.csv

# for loop cycles through all proteome files in /proteome
for file in ${projectFolder}/proteomes/proteome_*;
do
# run hmmer searches for both genes. temp files hold tests until loop cycles back through
~/Private/Biocomputing2022/tools/hmmsearch --tblout ${projectFolder}/setup/tempMatchmcrAgene.out ${projectFolder}/setup/hmm_mcrAgene_all.fasta $file
~/Private/Biocomputing2022/tools/hmmsearch --tblout ${projectFolder}/setup/tempMatchhsp70gene.out ${projectFolder}/setup/hmm_hsp70gene_all.fasta $file
# all hmmsearch outputs are appended to file allSearches.out
cat ${projectFolder}/setup/tempMatchmcrAgene.out >> ${projectFolder}/processed/allSearches.out
cat ${projectFolder}/setup/tempMatchhsp70gene.out >> ${projectFolder}/processed/allSearches.out
# number of lines containing capital letters in hmmsearch "target name" field used as proxy for number of matches found for hsp70gene
Nmatches=$(cut -d " " -f 1 ${projectFolder}/setup/tempMatchhsp70gene.out | grep -c -E [A-Z].+)
# searches "target name" field in hmmsearch output for capital letters, proxy for a mcrA gene match. If a match exists, mcrAtest = true. If else, then mcrAtest = false. Filename being searched by hmmsearch, $mcrAtest, and number of matches $Nmatches are then printed to summary.csv, a table of all results.
if [ $(head -n 4 ${projectFolder}/setup/tempMatchmcrAgene.out | tail -n 1 | cut -d " " -f 1 | grep -E [A-Z].+) ]
then
mcrAtest=true
echo "$(basename ${file}),$mcrAtest,$Nmatches" >> ${projectFolder}/processed/summary.csv
else
mcrAtest=false
echo "$(basename ${file}),$mcrAtest,$Nmatches" >> ${projectFolder}/processed/summary.csv
fi
done

# filter out mcrA matches and hsp70gene matches above $hsp70threshold, set above. Printed out to candidate_proteomes.txt in /processed and copies to the ${projectFolder}
cat ${projectFolder}/processed/summary.csv | grep true | grep -E ",[${hsp70threshold}-9]|,[1-9][0-9]+" | cut -d "," -f 1 | sed 's/.fasta//' > ${projectFolder}/processed/candidate_proteomes.txt
cp ${projectFolder}/processed/candidate_proteomes.txt ${projectFolder}/candidate_proteomes.txt
