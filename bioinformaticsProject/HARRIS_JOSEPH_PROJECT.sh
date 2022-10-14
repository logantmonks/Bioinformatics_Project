
#usage: $bash Test.sh $1 $2

#$1= gene 1 $2= gene 2 (in our case, hsp70 and McrA)

#assume script is run in ______ dirrectory

#first you need to combine the refrence sequences into one file per desired gene

cd ref_sequences
cat $1*.fasta > $1_combined.fasta
cat $2*.fasta > $2_combined.fasta

#then create a dir to store the intermediary files for each gene in

cd ..
mkdir $1
mkdir $2

cd ref_sequences

#move the combined files into their respective dir

mv $1_combined.fasta ../$1
mv $2_combined.fasta ../$2

#return back to _____ dir

cd ..

#First enter the gene dir so that created files will be in appropriate place
#Then run muscle on the combined.fasta files to allign them
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

#currently in bioinformatics dir
#HHM models are built, need to search proteomes for genes now
#use hhmsearch to search for desired genes in each proteome
#Run a for-loop to create an output

cd proteomes

for proteome in *.fasta
do
~/Private/Biocomputing2022/tools/hmmsearch --tblout "$proteome"_"$1".txt ../$1/gene1HMMmodel.fasta $proteome
done

for proteome in *.fasta
do
~/Private/Biocomputing2022/tools/hmmsearch --tblout "$proteome"_"$2".txt ../$2/gene2HMMmodel.fasta $proteome
done

#now all count files will appear in the proteomes dir. Need to move to respective dirs, first need to make dirs
cd ..
mkdir $1counts
mkdir $2counts

#need to move all count files to their respective dirs

cd proteomes
mv *$1.txt ../$1counts
mv *$2.txt ../$2counts

#all count files are in correct dir
#use for loop to grep search for any line that does not start with "#" then count lines to know how many copies
#search in .fasta.txt to remove the extra file extentions

cd ..

echo "proteome $1" > tablematch$1.txt

cd $1counts
for proteome in *.txt
do
var1=`cat $proteome | grep -v "#" | wc -l`
echo "$proteome, $var1" >> ../tablematch$1.txt
done

cd ..

echo "proteome $2" > tablematch$2.txt

cd $2counts
for proteome in *.txt
do
var2=`cat $proteome | grep -v "#" | wc -l`
echo "$proteome, $var2" >> ../tablematch$2.txt
done

cd ..

cat tablematch$2.txt | cut -d " " -f 2 | paste -d " " tablematch$1.txt - | sed "s/.fasta_hsp70.txt,/ /" > FINALTABLE.txt

cat FINALTABLE.txt | sed "/0/d" | sort -k2 -r > CANDIDATES.txt

# now need to make table

echo "WOOOOOOHOOOOOOO IT WORKED"
echo "File Created: FINALTABLE.txt a table with each proteome and the number of copies of each desired gene"
echo "File Created: CANDIDATES.txt a file with all potential candidates ranked by the prevelence of the genes"
