#Compiles mcrA ref seqs to a single fasta

for file in $hsp70gene_*.fasta
do
        cat $file >> hsp70_compiled.fasta
done

