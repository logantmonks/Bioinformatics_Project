#Usage: bash FinalAnswer.sh in bioinformaticsProject directory
#Relevant Directory Layout: ~/Private/Biocomputing2022/Bioinformatics_Project/bioinformaticsProject
#	              	    ~/Private/Biocomputing2022/Tools/
#----------------------------------------------------------------------------------------------------------------------------------------------------------
#mcrA Section
#Compiling mcrA ref sequecnes : Puts all of the mcrA ref sequences into one fasta file for alignment
for file in ~/Private/Biocomputing2022/Bioinformatics_Project/bioinformaticsProject/ref_sequences/mcrAgene_*.fasta
do
        cat $file >> mcrA_compiled.fasta
done

#Using muscle in mcrA ref sequences
~/Private/Biocomputing2022/Tools/muscle -in mcrA_compiled.fasta -out mcrA_genes.afa

#Hhmbuild mcrA
~/Private/Biocomputing2022/Tools/hmmbuild mcrA_gene_profile.txt mcrA_genes.afa

#----------------------------------------------------------------------------------------------------------------------------------------------------------
#hsp70 Section
#Compiling hsp70 ref sequences: Puts all of the hsp70 sequences in one fasta file for alignment
for gene in ~/Private/Biocomputing2022/Bioinformatics_Project/bioinformaticsProject/ref_sequences/hsp70gene_*.fasta
do
        cat $gene >> hsp70_compiled.fasta
done

#Using muscle on hsp70 ref sequences
~/Private/Biocomputing2022/Tools/muscle -in hsp70_compiled.fasta -out hsp70_genes.afa

#Hmmr Build hsp70
~/Private/Biocomputing2022/Tools/hmmbuild hsp70_gene_profile.txt hsp70_genes.afa

#----------------------------------------------------------------------------------------------------------------------------------------------------------
#Hmmr Search and Table Gen: runs hmmsearch, uses the hmm models generated above for hsp70 and mcrA against each of the proteomes. Output is a table in a csv style format, also saves a copy as a text file. Dump.txt is where the usual std out from hmm search is redirected.
echo -e "Proteome#,hsp70,mcrA" > Results_Table.txt
for seq in ~/Private/Biocomputing2022/Bioinformatics_Project/bioinformaticsProject/proteomes/proteome_*.fasta
do
        ~/Private/Biocomputing2022/Tools/hmmsearch -o dump.txt --tblout mcrA_gene_search.txt mcrA_gene_profile.txt $seq
        mcrACount=$(cat mcrA_gene_search.txt | grep WP_ | wc -l)

        ~/Private/Biocomputing2022/Tools/hmmsearch -o dump.txt --tblout hsp70_gene_search.txt hsp70_gene_profile.txt $seq
        hsp70count=$(cat hsp70_gene_search.txt | grep WP_ | wc -l)

        row=$(expr $row + 1)
        echo "Proteome$row,$hsp70count,$mcrACount" >> Results_Table.txt
done
cat Results_Table.txt
#----------------------------------------------------------------------------------------------------------------------------------------------------------
#Makes the list of proteomes containing mcrA genes and sorts them by the number of hsp70 proteins.
#List Gen
tail -50 Results_Table.txt | grep -w -v 0 | sort -t, -k 2 -n -r > CandidateList.txt
