
#usage: $bash Test.sh $1 $2

#$1= gene 1 $2= gene 2 (in our case, hsp70 and McrA)

#assume script is run in ______ dirrectory

#first you need to combine the refrence sequences into one file


cd ref_sequences
cat $1*.fasta > $1_combined.fasta
cat $2*.fasta > $2_combined.fasta

cd ..
mkdir $1
mkdir $2

cd ref_sequences

mv $1_combined.fasta ../$1
mv $2_combined.fasta ../$2

cd ..

cd $1
~/Private/Biocomputing2022/tools/muscle -in $1_combined.fasta -out $1_alligned.afa
cd ..

cd $2
~/Private/Biocomputing2022/tools/muscle -in $2_combined.fasta -out $2_alligned.afa
cd ..

cd $1
~/Private/Biocomputing2022/tools/hmmbuild gene1HMMmodel.afa $1_alligned.afa
cd ..

cd $2
~/Private/Biocomputing2022/tools/hmmbuild gene2HMMmodel.afa $2_alligned.afa
cd ..
