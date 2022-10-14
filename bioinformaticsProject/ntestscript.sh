
#Compiling hsp70 ref sequences

for file in ~/Private/Biocomputing2022/Bioinformatics_Project/bioinformaticsProject/ref_sequences/hsp70gene_*.fasta
do
        cat $file >> hsp70_compiled.fasta
done

#Using muscle on hsp70 ref sequences
~/Private/Biocomputing2022/Tools/muscle -in hsp70_compiled.fasta -out hsp70_genes.afa

#Hmmr Build hsp70
~/Private/Biocomputing2022/Tools/hmmbuild hsp70_gene_profile.hmmfile hsp70_genes.afa

#Hmmr Search hsp70
#for file in ~/Private/Biocomputing2022/Bioinformatics_Project/bioinformaticsProject/proteomes/$proteome_*.fasta
#do
#	~/Private/Biocomputing2022/Tools/hmmsearch --tblout hsp70_gene_search.txt hsp70_gene_profile.hmmfile ./proteomes/$file
#	cat hsp70_gene_search.txt | grep "WP_"-c |

~/Private/Biocomputing2022/Tools/hmmsearch --tblout hsp70_gene_search.txt hsp70_gene_profile.hmmfile ./proteomes/proteome_01.fasta
