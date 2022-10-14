# Usage: bash project.sh mcrArefseq hsprefseq (ex. for this file system bash project.sh ref_sequences/mcrA ref_sequences/hsp) 
# Run script in Bioinformatics Project directory

# Search alignments in mcrA gene
cat $1* > mcrAmuscle.fasta
~/Private/Biocomputing2022/Tools/muscle -in mcrAmuscle.fasta -out mcrAalign.fasta

# Search alignments in hsp gene
cat $2* > hspmuscle.fasta
~/Private/Biocomputing2022/Tools/muscle -in hspmuscle.fasta -out hspalign.fasta

# Build HMM profile from mcrA alignments 
~/Private/Biocomputing2022/Tools/hmmbuild mcrAbuild.txt mcrAalign.fasta

# Build HMM profile from hsp alignments
~/Private/Biocomputing2022/Tools/hmmbuild hspbuild.txt hspalign.fasta

# Create table header
echo Proteome	mcrA	Hsp>finalTable.txt

# Search each proteome for mcrA and hsp genes
for file in proteomes/proteome*
do
~/Private/Biocomputing2022/Tools/hmmsearch --tblout mcrAresult.txt mcrAbuild.txt $file  
~/Private/Biocomputing2022/Tools/hmmsearch --tblout hspresult.txt hspbuild.txt $file
# Shorten proteome label
protLabel=$(echo "$file" | sed 's/.fasta//' | sed 's/proteomes\///')
# Count number of mcrA genes
nummcrAgenes=$(cat mcrAresult.txt | grep -vc "#")
# Count number of hsp genes
numHspGenes=$(cat hspresult.txt | grep -vc "#")
# Add counts to table
echo $protLabel,$nummcrAgenes,$numHspGenes>>finalTable.txt
done

echo "pH Resistant Candidates in Descending Order:" > pHResistantCandidates.txt
# Limit table to proteomes containing 1 mcrA gene, Sort table in descending order by number of hsp genes, Return proteomes to new text file

cat finalTable.txt | grep -v ",0," | sort -r -t , -k 3 | grep -v ",0" | cut -d, -f 1 >> pHResistantCandidates.txt



