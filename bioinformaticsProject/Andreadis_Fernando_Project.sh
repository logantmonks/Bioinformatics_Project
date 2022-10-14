#bioinformatics_project 
#Catherine Andreadis, Shehani Fernando 

#Directory for all output files to be funneled into , this exists in the bioinformaticsProject directory 
mkdir methane_final

#merge all the mcrA ref sequences into one file  - necessary to run muscle 
for file in ~/Private/Biocomputing2022/Bioinformatics_Project/bioinformaticsProject/ref_sequences/m*.fasta 
do 
cat $file >> ~/Private/Biocomputing2022/Bioinformatics_Project/bioinformaticsProject/methane_final/mcrA_combined.txt 
done 

#merge all the hsp ref sequences into one file 
for file in  ~/Private/Biocomputing2022/Bioinformatics_Project/bioinformaticsProject/ref_sequences/h*.fasta
do 
cat $file >> ~/Private/Biocomputing2022/Bioinformatics_Project/bioinformaticsProject/methane_final/hsp_combined.txt 
done 

#align the mcrA ref_sequences 
~/Private/Biocomputing2022/tools/muscle -in ~/Private/Biocomputing2022/Bioinformatics_Project/bioinformaticsProject/methane_final/mcrA_combined.txt -out ~/Private/Biocomputing2022/Bioinformatics_Project/bioinformaticsProject/methane_final/mcrAaligned.txt

#align the hsp ref_sequences 
~/Private/Biocomputing2022/tools/muscle -in ~/Private/Biocomputing2022/Bioinformatics_Project/bioinformaticsProject/methane_final/hsp_combined.txt -out ~/Private/Biocomputing2022/Bioinformatics_Project/bioinformaticsProject/methane_final/hspaligned.txt
 
#use hmmbuild to create an HMM profile 
~/Private/Biocomputing2022/tools/hmmbuild ~/Private/Biocomputing2022/Bioinformatics_Project/bioinformaticsProject/methane_final/mcrAgene.hmm ~/Private/Biocomputing2022/Bioinformatics_Project/bioinformaticsProject/methane_final/mcrAaligned.txt

~/Private/Biocomputing2022/tools/hmmbuild ~/Private/Biocomputing2022/Bioinformatics_Project/bioinformaticsProject/methane_final/hspgene.hmm ~/Private/Biocomputing2022/Bioinformatics_Project/bioinformaticsProject/methane_final/hspaligned.txt

#hmmsearch for the proteomes to search for genes of interest (mcrA and hsp) 
cd ~/Private/Biocomputing2022/Bioinformatics_Project/bioinformaticsProject/proteomes 
for file in *.fasta
do 
~/Private/Biocomputing2022/tools/hmmsearch -E "1" --tblout  ~/Private/Biocomputing2022/Bioinformatics_Project/bioinformaticsProject/methane_final/$file.mcrAfinal ~/Private/Biocomputing2022/Bioinformatics_Project/bioinformaticsProject/methane_final/mcrAgene.hmm $file 
done 

for file in *.fasta
do 
~/Private/Biocomputing2022/tools/hmmsearch -E "1" --tblout  ~/Private/Biocomputing2022/Bioinformatics_Project/bioinformaticsProject/methane_final/$file.hspfinal ~/Private/Biocomputing2022/Bioinformatics_Project/bioinformaticsProject/methane_final/hspgene.hmm $file  
done 

#generate csv of all proteome hits for mcrA genes and hsp genes - the best candidate microogransims are recoreded in a file called methane_samples.txt 
echo "name,mcrA_match,hsp_match" > ~/Private/Biocomputing2022/Bioinformatics_Project/bioinformaticsProject/methane.csv
cd ~/Private/Biocomputing2022/Bioinformatics_Project/bioinformaticsProject/proteomes
for file in *.fasta 
do 
name=$(echo $file)
mcrA_match=$(grep -v "#"  ~/Private/Biocomputing2022/Bioinformatics_Project/bioinformaticsProject/methane_final/$file.mcrAfinal | wc -l)
hsp_match=$(grep -v "#"  ~/Private/Biocomputing2022/Bioinformatics_Project/bioinformaticsProject/methane_final/$file.hspfinal | wc -l)
echo "$name,$mcrA_match,$hsp_match" >> ~/Private/Biocomputing2022/Bioinformatics_Project/bioinformaticsProject/methane.csv
done 

sed -i 's/.fasta//g' ~/Private/Biocomputing2022/Bioinformatics_Project/bioinformaticsProject/methane.csv

###Notes
#This script was run from the bioinformaticsProject directory 
#We chose an E value of 1 as we believed it would give a good overview of the data, result in high quality reads, but also is conservative enough with a relatively small sample size, which is
# what we're working with. 
