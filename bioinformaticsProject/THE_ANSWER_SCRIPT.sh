#Compiles mcrA ref seqs to a single fasta
for file in ~/Private/Biocomputing2022/Bioinformatics_Project/bioinformaticsProject/ref_sequences/$mcrA_gene*.fasta
do
	cat $file >> mcrA_compiled.fasta
done

#Makes the Muscl Alignment
~/Private/Biocomputing2022/Tools/muscle -in mcrA_compiled.fasta -out mcrA_genes.afa

#Hmmr Build
~/Private/Biocomputing2022/Tools/hmmbuild mcrA_gene_profie.hmmfile mcrA_genes.afa
