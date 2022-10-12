#Search alignments in mcrA gene
#Run bash script in Bioinformatics Project directory
cat ref_sequences/mcrAgene_* >> mcrAmuscle.txt
~/Private/Biocomputing2022/Tools/muscle -in mcrAmuscle.txt -out mcrAalign.txt

#Search alignments in hsp gene
cat ref_sequences/hsp70gene_* >> hspmuscle.txt
~/Private/Biocomputing2022/Tools/muscle -in hspmuscle.txt -out hspalign.txt

#Input mcrA alignments into hmmbuild and hmmsearch 
~/Private/Biocomputing2022/Tools/hmmbuild mcrAbuild.txt mcrAalign.txt
for file in mcrAalign.txt
do
~/Private/Biocomputing2022/Tools/hmmsearch --tblout mcrAtable.txt mcrAbuild.txt $file
done

#Input hsp alignments into hmmbuild and hmmsearch
~/Private/Biocomputing2022/Tools/hmmbuild hspbuild.txt hspalign.txt
for file in hspalign.txt
do
~/Private/Biocomputing2022/Tools/hmmsearch --tblout hsptable.txt hspbuild.txt $file
done

