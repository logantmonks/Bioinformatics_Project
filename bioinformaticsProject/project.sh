#first one needs to combine the reference gene sequences into one file (one separate for mcrA and hsp70)
echo "Create combined files for hsp70gene and mcrAgene"
echo "Note user is currently in bioinformaticsProject directory"
cd ref_sequences
cat hsp70gene*.fasta >> allhsp70gene.fasta
cat mcrAgene*.fasta >> allmcrAgene.fasta

#one needs to align and prepare an HMM search profile for both the combined lists
echo " "
echo "Building HMM profiles for both the combined lists"
echo "Assume musccle and hmmbuild are in the tools folder and the combined sequences are in the reference folders"
~/Private/Biocomputing2022/tools/muscle -in allhsp70gene.fasta -out alignedhsp70.fasta
~/Private/Biocomputing2022/tools/muscle -in allmcrAgene.fasta -out alignedmcrAgene.fasta
~/Private/Biocomputing2022/tools/hmmbuild hmmsearchHSP70.fasta alignedhsp70.fasta
~/Private/Biocomputing2022/tools/hmmbuild hmmsearchmcrA.fasta alignedmcrAgene.fasta

#create a table with desired headers
cd ..
cd proteomes
echo "Proteome, Hsp70gene Count, mcrAgene Count" > TableSummary.txt

#place data of counts of the genes into the table
echo " "
echo "Create a tabular output of matches"
for file in proteome*.fasta
do
~/Private/Biocomputing2022/tools/hmmsearch --tblout tablehsp70.txt ~/Private/Biocomputing2022/Bioinformatics_Project/bioinformaticsProject/ref_sequences/hmmsearchHSP70.fasta $file
varHSP=$(cat tablehsp70.txt | grep WP_ | wc -l)
~/Private/Biocomputing2022/tools/hmmsearch --tblout tablemcrA.txt ~/Private/Biocomputing2022/Bioinformatics_Project/bioinformaticsProject/ref_sequences/hmmsearchmcrA.fasta $file
varmcrA=$(cat tablemcrA.txt | grep WP_ | wc -l)
echo "$file, $varHSP, $varmcrA" >> TableSummary.txt
done

#now we want to provide a text file with our recommendations of proteomes
#we will start by listing all of the proteomes with one gene of each hsp70 and mcrA in one file
# note that TableSummary.txt as well as the following files will all be in the proteomes directory
cat TableSummary.txt | tail -n+2 | grep -v ", 0" | sort -n -r -k 2 | cut -d, -f 1 > UsableProteomes.txt

#finally we will give our top 4 proteome picks due to the highest amount of hsp70 genes
cat TableSummary.txt | tail -n+2 | grep -v ", 0" | sort -n -r -k 2 | head -n 4 | cut -d, -f 1 > Best4Proteome.txt


