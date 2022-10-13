#Usage: Search each genome for the genes of interest and should produce a summary table collating the results of all searches
 
#Step 1: Get all proteome files/sequences into one file

#hsp reference sequence
for file in hsp70gene_*.fasta
do
cat $file >> all_hsp70genes.txt
done

#mcrA gene reference sequence
for file in mcrAgene_*.fasta 
do 
cat $file >> all_mcrAgenes.txt
done

#move these files to proteomes directory so hmmer and muscle can work 
mv all_hsp70genes.txt ../proteomes 
mv all_mcrAgenes.txt

#Step 2: Use muscle to align proteome sequences in order to find reference sequence markers

#hsp reference sequence
~/Private/Biocomputing2022/tools/muscle -in all_hsp70genes.txt -out hsp70gene_alignment

#mcrA gene reference sequence
~/Private/Biocomputing2022/tools/muscle -in all_mcrAgenes.txt -out mcrAgene_alignment

#Step 3: Use the output of muscle as the input of hmmbuild

#hsp reference sequence
 ~/Private/Biocomputing2022/tools/hmmbuild hsp70buildresults hsp70gene_alignment

#mcrA gene reference sequence
~/Private/Biocomputing2022/tools/hmmbuild mcrAbuildresults mcrAgene_alignment

#Step 4: align each individual proteome using the reference sequences to determine presence of hsp70 and mcrA
#this for loop aligns each proteome with the reference sequences and outputs the file as a table. The table is sorted by presence of mcrA gene, not by proteome count.

for file in proteome_*.fasta 
do 
~/Private/Biocomputing2022/tools/hmmsearch --tblout $file.mcrA  mcrAbuildresults $file 
~/Private/Biocomputing2022/tools/hmmsearch --tblout $file.hsp  hsp70buildresults $file
mcrA=$(cat $file.mcrA | grep -v "#" | wc -l)
hsp=$(cat $file.hsp | grep -v "#" | wc -l)
echo "proteome mcrA_presence hsp70_presence"
echo "$file $mcrA $hsp">>results.txt
cat results.txt| sort -t " " -k2 -n -r
done

#Step 5: creation of txt file of just methanogens from resultant table
cat results.txt | grep "[1,2] [1-9]"| cut -d " " -f 1 > methanogens.txt
echo "Methanogens"
cat methanogens.txt

#removal of resultant files so the code can be executed again without double counting proteomes.
rm results.txt
rm *.fasta.mcrA
rm *.fasta.hsp
