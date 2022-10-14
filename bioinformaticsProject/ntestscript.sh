#Compiling mcrA ref sequecnes
for file in ~/Private/Biocomputing2022/Bioinformatics_Project/bioinformaticsProject/ref_sequences/mcrAgene_*.fasta
do
        cat $file >> mcrA_compiled.fasta
done

#Using muscle in mcrA ref sequences
~/Private/Biocomputing2022/Tools/muscle -in mcrA_compiled.fasta -out mcrA_genes.afa

#Hhmbuild mcrA
~/Private/Biocomputing2022/Tools/hmmbuild mcrA_gene_profile.txt mcrA_genes.afa
#Remove?
#Hhmsearch mcrA
#mcrACount=$(cat mcrA_gene_search.txt | grep WP_ | wc -l)
#mcrACount=$(cat mcrA_gene_search.txt | grep WP_ | wc -l)
#for seq in ~/Private/Biocomputing2022/Bioinformatics_Project/bioinformaticsProject/proteomes/proteome_*.fasta
#do
#       ~/Private/Biocomputing2022/Tools/hmmsearch --tblout mcrA_gene_search.txt mcrA_gene_profile.txt $seq
#	mcrACount=$(cat mcrA_gene_search.txt | grep WP_ | wc -l)
#done

#Compiling hsp70 ref sequences

for gene in ~/Private/Biocomputing2022/Bioinformatics_Project/bioinformaticsProject/ref_sequences/hsp70gene_*.fasta
do
        cat $gene >> hsp70_compiled.fasta
done

#Using muscle on hsp70 ref sequences
~/Private/Biocomputing2022/Tools/muscle -in hsp70_compiled.fasta -out hsp70_genes.afa

#Hmmr Build hsp70
~/Private/Biocomputing2022/Tools/hmmbuild hsp70_gene_profile.txt hsp70_genes.afa

#Remove?
#Hmmr Search hsp70 with variable
#for proteome in ~/Private/Biocomputing2022/Bioinformatics_Project/bioinformaticsProject/proteomes/proteome_*.fasta
#do
#	~/Private/Biocomputing2022/Tools/hmmsearch --tblout hsp70_gene_search.txt hsp70_gene_profile.txt $proteome
#	cat hsp70_gene_search.txt | grep WP_ | wc -l
#	hsp70count=$(cat hsp70_gene_search.txt | grep WP_ | wc -l)
#done

#Hmmr Search and Table Gen
row=$(0)
echo -e "Proteome #	hsp70	mcrA"
for seq in ~/Private/Biocomputing2022/Bioinformatics_Project/bioinformaticsProject/proteomes/proteome_*.fasta
do
        ~/Private/Biocomputing2022/Tools/hmmsearch -o dump.txt --tblout mcrA_gene_search.txt mcrA_gene_profile.txt $seq
#        cat mcrA_gene_search.txt | grep WP_ |wc -l
	mcrACount=$(cat mcrA_gene_search.txt | grep WP_ | wc -l)

	~/Private/Biocomputing2022/Tools/hmmsearch -o dump.txt --tblout hsp70_gene_search.txt hsp70_gene_profile.txt $seq
#        cat hsp70_gene_search.txt | grep WP_ | wc -l
        hsp70count=$(cat hsp70_gene_search.txt | grep WP_ | wc -l)

	row=$(expr $row + 1)
	echo "Proteome$row $hsp70count $mcrACount"
done

