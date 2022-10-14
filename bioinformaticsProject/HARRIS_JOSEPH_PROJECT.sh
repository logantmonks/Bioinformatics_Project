# HARRIS_JOSEPH_PROJECT.sh is a script designed to allign refrence genomes with a desired gene,
# model those genomes, and then use that model to search proteomes for desired genes.
# The script will output a table with each proteome and the number of matches the proteome has for each gene.
# The script will also output a list of the best candidate proteomes ranked by the prevelence of the deisred genes.

# usage: $bash HARRIS_JOSEPH_PROJECT.sh $1 $2
# $1= desired gene 1 (more prevelent)
# $2= desired gene 2
# in our case, $1 and $2 would be "hsp70" and "mcrA" respectively
# This is done make the script more flexible and applicable to different genes

#assume script is run in "bioinformaticsProject" directory



#first you need to combine the refrence sequences into one file per desired gene

cd ref_sequences
cat $1*.fasta > $1_combined.fasta
cat $2*.fasta > $2_combined.fasta

#then create a directory to store the intermediary files for each gene, within the main directory

cd ..
mkdir $1
mkdir $2

cd ref_sequences

#move the combined files into their respective directories

mv $1_combined.fasta ../$1
mv $2_combined.fasta ../$2


cd ..

#First enter the gene directory so that created files will be in appropriate place
#Then run muscle on the combined.fasta files to allign the files
#Return stdout to new alligned.fasta file
#Then run hmmbuild to create an HMMmodel for each gene

cd $1
~/Private/Biocomputing2022/tools/muscle -in $1_combined.fasta -out $1_alligned.fasta
~/Private/Biocomputing2022/tools/hmmbuild gene1HMMmodel.fasta $1_alligned.fasta
cd ..

cd $2
~/Private/Biocomputing2022/tools/muscle -in $2_combined.fasta -out $2_alligned.fasta
~/Private/Biocomputing2022/tools/hmmbuild gene2HMMmodel.fasta $2_alligned.fasta
cd ..

#currently in bioinformatics directory
#HHM models are built, now search proteomes for genes
#use hhmsearch to search for desired genes in each proteome
#Run a for-loop to create an output file for each proteome
#Each output file will be a table showing the number of copies of the gene in the proteome

cd proteomes

for proteome in *.fasta
do
~/Private/Biocomputing2022/tools/hmmsearch --tblout "$proteome"_"$1".txt ../$1/gene1HMMmodel.fasta $proteome
done

for proteome in *.fasta
do
~/Private/Biocomputing2022/tools/hmmsearch --tblout "$proteome"_"$2".txt ../$2/gene2HMMmodel.fasta $proteome
done

#now all count files will appear in the proteomes directory
#First make directories to store these files
#Then move these files to their respective directories
cd ..
mkdir $1counts
mkdir $2counts

#Moving files to their respecitve directories

cd proteomes
mv *$1.txt ../$1counts
mv *$2.txt ../$2counts

#First create a file to store the table data in for this gene
cd ..

echo "proteome $1" > tablematch$1.txt

#Use a for-loop to echo the name of the proteome and the gene count within the file
#Place this data into the recently created table file

cd $1counts
for proteome in *.txt
do
var1=`cat $proteome | grep -v "#" | wc -l`
echo "$proteome, $var1" >> ../tablematch$1.txt
done

#Reapeat above steps for gene 2

cd ..

echo "proteome $2" > tablematch$2.txt

cd $2counts
for proteome in *.txt
do
var2=`cat $proteome | grep -v "#" | wc -l`
echo "$proteome, $var2" >> ../tablematch$2.txt
done

cd ..

#Combine the two table files by taking the second row (the gene matches) of one file and pasting it into the other file
#This creates a table with three rows in proteome gene-1-match gene-2-match order
#Remove the excess file extensions to leave proteome names as original
#Pipe this final table to a new file

cat tablematch$2.txt | cut -d " " -f 2 | paste -d " " tablematch$1.txt - | sed "s/.fasta_hsp70.txt,/ /" > FINALTABLE.txt

#Read information from the final table
#Get rid of all lines that contain "0", because these cannot be canidates
#Sort the file by frequency of genes
#Pipe this data into a new file

cat FINALTABLE.txt | sed "/0/d" | sort -k2 -r > CANDIDATES.txt

#Celebrate because you finished the midterm project at the buzzer

echo "WOOOOOOHOOOOOOO IT WORKED"

#Lines to state the two files created in the terminal once the script is run

echo "File Created: FINALTABLE.txt a table with each proteome and the number of copies of each desired gene"
echo "File Created: CANDIDATES.txt a file with all potential candidates ranked by the prevelence of the genes"
