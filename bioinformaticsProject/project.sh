#Search alignments in mcrA gene
for file in mcrAgene_*
do
cat $file >> mcrAmuscle.txt
done
~/Private/Biocomputing2022/Tools/muscle -in mcrAmuscle.txt -out mcrAalign.txt
 

#Search alignments in hsp gene
for file in hsp70gene_*
do
cat $file >> hspmuscle.txt
done
~/Private/Biocomputing2022/Tools/muscle -in hspmuscle.txt -out hspalign.txt

#Input mcrA alignments into hmmbuild
