#Compiles mcrA ref seqs to a single fasta

for file in $mcrA_gene*.fasta
do
	cat $file >> mcrA_compiled.fasta
done

