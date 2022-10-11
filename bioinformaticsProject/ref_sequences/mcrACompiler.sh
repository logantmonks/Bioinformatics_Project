#Compiles mcrA ref seqs to a single fasta

for file in $mcrA*
do
	cat $file >> mcrAgene_compiled.fasta
done

