#Compiling mcrA ref sequecnes
for file in ~/Private/Biocomputing2022/Bioinformatics_Project/bioinformaticsProject/ref_sequences/mcrAgene_*.fasta
do
        cat $file >> mcrA_compiled.fasta
done

#Using muscle in mcrA ref sequences
~/Private/Biocomputing2022/Tools/muscle -in mcrA_compiled.fasta -out mcrA_genes.afa

#Hhmbuild mcrA
~/Private/Biocomputing2022/Tools/hmmbuild mcrA_gene_profile.txt mcrA_genes.afa

#Hhmsearch mcrA
mcrACount=$(cat mcrA_gene_search.txt | grep WP_ | wc -l)
#for seq in ~/Private/Biocomputing2022/Bioinformatics_Project/bioinformaticsProject/proteomes/proteome_*.fasta
#do
#       ~/Private/Biocomputing2022/Tools/hmmsearch --tblout mcrA_gene_search.txt mcrA_gene_profile.txt ./proteomes/$seq
#	cat mcrA_gene_search.txt | grep WP_ | wc -l



#Compiling hsp70 ref sequences

for file in ~/Private/Biocomputing2022/Bioinformatics_Project/bioinformaticsProject/ref_sequences/hsp70gene_*.fasta
do
        cat $file >> hsp70_compiled.fasta
done

#Using muscle on hsp70 ref sequences
~/Private/Biocomputing2022/Tools/muscle -in hsp70_compiled.fasta -out hsp70_genes.afa

#Hmmr Build hsp70
~/Private/Biocomputing2022/Tools/hmmbuild hsp70_gene_profile.txt hsp70_genes.afa

#Hmmr Search hsp70 with variable
hsp70count=$(cat hsp70_gene_search.txt | grep WP_ | wc -l)
#for file in ~/Private/Biocomputing2022/Bioinformatics_Project/bioinformaticsProject/proteomes/proteome_*.fasta
#do
#	~/Private/Biocomputing2022/Tools/hmmsearch --tblout hsp70_gene_search.txt hsp70_gene_profile.txt ./proteomes/$file
#	cat hsp70_gene_search.txt | grep WP_ | wc -l

~/Private/Biocomputing2022/Tools/hmmsearch --tblout hsp70_gene_search.txt hsp70_gene_profile.txt ./proteomes/proteome_01.fasta
