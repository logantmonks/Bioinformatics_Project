#Compiling hsp70 ref sequences

for file in ~/Private/Biocomputing2022/Bioinformatics_Project/bioinformaticsProject/ref_sequences/$hsp70gene_*.fasta
do
        cat $file >> hsp70_compiled.fasta
done

#Using muscle on hsp70 ref sequences
~/Private/Biocomputing2022/Tools/muscle -in hsp70_compiled.fasta -out hsp70_genes.afa
