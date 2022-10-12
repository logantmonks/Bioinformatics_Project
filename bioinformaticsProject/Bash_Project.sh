#!/bin/bash

# Step 1, combine all dna files
cat ref_sequences/mcrAgene_* > mcrAgene_all.fasta
cat ref_sequences/hsp70* > hsp70gene_all.fasta

# Step 2, use muscle to align dna
~/Private/Biocomputing2022/tools/muscle -in mcrAgene_all.fasta -out muscled_mcrAgene.muscle
~/Private/Biocomputing2022/tools/muscle -in hsp70gene_all.fasta -out muscled_hsp70gene.muscle

# Step 3, build hmm images
~/Private/Biocomputing2022/tools/hmmbuild mcrAgene_hmmbuild.hmm muscled_mcrAgene.muscle
~/Private/Biocomputing2022/tools/hmmbuild hsp70gene_hmmbuild.hmm muscled_hsp70gene.muscle

# Step 4, loop through proteome directory, find mcrA or hsp70, put in table
echo -e "proteome_name\tmcrAgene count\thsp70gene count" > proteome_table.txt
for i in proteomes/proteome_*.fasta
do
	~/Private/Biocomputing2022/tools/hmmsearch --tblout mcrAsearch.txt mcrAgene_hmmbuild.hmm $i
	~/Private/Biocomputing2022/tools/hmmsearch --tblout hsp70search.txt hsp70gene_hmmbuild.hmm $i
	mcrAcount=$(cat mcrAsearch.txt | grep -E "muscled_mcrAgene" | wc -l)
	hsp70count=$(cat hsp70search.txt | grep -E "muscled_hsp70gene" | wc -l)
	prot=$(echo "$i" | grep -o "proteome_[0-9]{2}")
	echo -e "$prot\t$mcrAcount\t$hsp70count" >> proteome_table.txt
done
