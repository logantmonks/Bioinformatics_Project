#!/bin/bash

# Step 1, combine all dna files
cat ref_sequences/mcrAgene_* > mcrAgene_all.fasta
cat ref_sequences/hsp70gene_* > hsp70gene_all.fasta

# Step 2, use muscle to align dna
~/Private/Biocomputing2022/tools/muscle -in mcrAgene_all.fasta -out muscled_mcrAgene.muscle
~/Private/Biocomputing2022/tools/muscle -in hsp70gene_all.fasta -out muscled_hsp70gene.muscle

# Step 3, build hmm images
~/Private/Biocomputing2022/tools/hmmbuild mcrAgene_hmmbuild.hmm muscled_mcrAgene.muscle
~/Private/Biocomputing2022/tools/hmmbuild hsp70gene_hmmbuild.hmm muscled_hsp70gene.muscle

# Step 4, loop through proteome directory, find mcrA or hsp70, put in table
# creating the file for the table
echo -e "proteome_name\tmcrAgene_count\thsp70gene_count" > proteome_table.txt
for i in proteomes/proteome_*.fasta
do
	# This part of the loop finds the # of each gene found in the proteome
	~/Private/Biocomputing2022/tools/hmmsearch --tblout mcrAsearch.txt mcrAgene_hmmbuild.hmm $i
	~/Private/Biocomputing2022/tools/hmmsearch --tblout hsp70search.txt hsp70gene_hmmbuild.hmm $i
	# This part of the code gets the mcrA count, hsp70 count, and proteome name so we can output it in a format we like
	mcrAcount=$(cat mcrAsearch.txt | grep -E "muscled_mcrAgene" | wc -l)
	hsp70count=$(cat hsp70search.txt | grep -E "muscled_hsp70gene" | wc -l)
	prot=$(echo "$i" | grep -o -E "proteome_[0-9]{2}")
	echo -e "$prot\t\t$mcrAcount\t\t$hsp70count" >> proteome_table.txt
done

# Step 5, recommend which proteomes to study
echo "These are the names of the candidate pH-resistant methanogens based on our results." > Final_Recommendations.txt
echo -e "\nproteome_name\tmcrAgene_count\thsp70gene_count" >> Final_Recommendations.txt
# here we are getting all the proteomes that have at least one mcrA and at least one hsp70
cat proteome_table.txt | grep -v "count" | grep -v -E "\s0\s" | grep -v -E "\s0$" >> Final_Recommendations.txt

# End the script by outputting the final table results
echo -e "\nFinal output table"
cat proteome_table.txt

#cat proteome_table.txt | grep -v "count" | grep -v -E "\s0\s" | grep -v -E "\s0$" | awk -F '\t\t' '{print $1}' >> Final_Recommendations.txt


