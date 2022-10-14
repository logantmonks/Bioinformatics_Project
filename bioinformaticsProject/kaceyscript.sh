#navigate to proper folder containing ref sequences

cd ~/Private/Biocomputing2022/Bioinformatics_Project/bioinformaticsProject/ref_sequences



#compile reference sequences of the same gene into a file for each mcrA and hsp70 for multiple alignment

cat hsp70gene_*.fasta >> refhsp70.fasta
cat mcrAgene_*.fasta >> refmcrA.fasta



#Use muscle tool to align the sequences, creating two new aligned files

~/Private/Biocomputing2022/tools/muscle -in refhsp70.fasta -out refhsp70.afa
~/Private/Biocomputing2022/tools/muscle -in refmcrA.fasta -out refmcrA.afa



#Use hmmbuild tool to create two profiles to search for each gene in  our proteomes

~/Private/Biocomputing2022/tools/hmmbuild hsp70profile.hmm refhsp70.afa
~/Private/Biocomputing2022/tools/hmmbuild mcrAprofile.hmm refmcrA.afa



#This loop conducts the aforementioned search for both the mcrA and hsp70 genes for each of the 50 proteomes.
#Each search yields a table containing the matches, creating 2 tables for each proteome
#A list of proteomes is created
#For each table, only lines corresponding to a match are counted, and a list of number of matches is created for each gene, order by proteome number

for n in {01..50}
do
~/Private/Biocomputing2022/tools/hmmsearch --tblout mcrA_proteome_$n.txt  mcrAprofile.hmm ../proteomes/proteome_$n.fasta
~/Private/Biocomputing2022/tools/hmmsearch --tblout hsp70_proteome_$n.txt  hsp70profile.hmm ../proteomes/proteome_$n.fasta
echo proteome_$n >>proteome.txt
cat mcrA_proteome_$n.txt | grep -v '#' | wc -l >>mcrA.txt
cat hsp70_proteome_$n.txt | grep -v '#' | wc -l >>hsp70.txt
done



#The three lists are combined to create a table of proteomes, their mcrA matches, and their hsp70 matches

paste proteome.txt mcrA.txt hsp70.txt > kaceyunsorted.txt



#A table is created with appropriate headers, sorting the matches numerically for convenience.
#Best matches are near the top

echo proteome   mcraA   hsp70;cat kaceyunsorted.txt | sort -t"  " -k2,2nr -k3,3nr



#A text file is created listing candidates that have at least one match of both genes

cd ..
cat ref_sequences/kaceyunsorted.txt | grep -v ' 0' |cut -d"     " -f1 >kaceycandidates.txt



#The files created throughout this analysis are removed except for the file of candidates, as it was requested by the instructions of the project
#This makes it easier to run again

cd ref_sequences
rm *.txt ref*.afa ref*.fasta mcrAprofile.hmm hsp70profile.hmm

