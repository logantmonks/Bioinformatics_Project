# Completes the tasks for Project 1
# Usage: bash Hanna_Nate.sh when in folder bioinformaticsProject, results are in ref_sequences folder
cd ~/Private/Biocomputing/Bioinformatics_Project/Bioinformatics_Project/bioinformaticsProject/ref_sequences
for i in {01..22}
do
cat hsp70gene_$i.fasta >> hsp70gene.refs
done

for i in {01..18}
do
cat mcrAgene_$i.fasta >> mcrAgene.refs
done

# Align using muscle
~/Private/Biocomputing/Tools/muscle -in hsp70gene.refs -out hsp70gene.muscle
~/Private/Biocomputing/Tools/muscle -in mcrAgene.refs -out mcrAgene.muscle

# Build HMM profile
~/Private/Biocomputing/Tools/hmmbuild hsp70gene.hmmbuild hsp70gene.muscle
~/Private/Biocomputing/Tools/hmmbuild mcrAgene.hmmbuild mcrAgene.muscle

# HMM search mcrA
for i in {01..50}
do
~/Private/Biocomputing/Tools/hmmsearch --tblout mcrAgene$i.searched mcrAgene.hmmbuild ../proteomes/proteome_$i.fasta
done

# Creating a text file for mcrAgene 0 or 1
for i in {01..50}
do
grep -H 'coenzyme' mcrAgene$i.searched >> mcrAgene_table.txt
grep -H -L -E 'coenzyme' mcrAgene$i.searched | sed -E 's/$/\t0/g' >> mcrAgene_table.txt
done
cat mcrAgene_table.txt | cut -d ' ' -f1 | sed -E "s/:WP_[0-9]{9}.1/\t1/g" | sed -E "s/mcrAgene/proteome /g" | sed -E "s/.searched/ /g" | sort | uniq > mcrAgene_table2.txt

# HMM search hsp

cd ref_sequences
for i in {01..50}
do
~/Private/Biocomputing/Tools/hmmsearch --tblout hsp70gene$i.searched hsp70gene.hmmbuild ../proteomes/proteome_$i.fasta
done

# Creating a text file for the number of hsps in each proteome
for i in {01..50}
do
cat hsp70gene$i.searched | grep -E -H -o -i "WP_[0-9]{9}.1" >> hsp70grep$i.txt
done

for i in {01..50}
do
wc -l hsp70grep$i.txt >> hsp70table.txt
done

# Combine two files into one file with two columns, ordered by best to use to worst to use (find in ref_sequences folder in results.txt)
paste mcrAgene_table2.txt hsp70table.txt | sed -E 's/hsp70grep[0-9]*.txt/ /g' | sort -n -r -k2,2 -k3,3 -t$'\t' > results.txt

# Print recommendations in descending order of which would be best to use
cd ref_sequences
cat results.txt
