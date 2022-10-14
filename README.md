# Bioinformatics_Project - hjeon
## Steps to run project
### 1. pwd to bioinformaticsProject/ directory
### 2. Chmod execution privileges
#### chmod +x script.sh
### 3. Make sure muscle, hmmbuild, and hmmsearch commands are working as expected
### 4. Run script.sh
#### ./script.sh
### 5. There will be two output text files "candidate.txt" and "table.txt" created after the run. "candidate.txt" saves best to worst candidates in order. "table.txt" saves search results for "proteome_xx    hsp70_count     mcrA_presence".
## Errata
### Using the default command in the form of "muscle -in seqs.fa -out seqs.afa" expends significant time and resources. script.sh had to adopt a new format of "muscle -in seqs.fa -out seqs.afa -maxiters 1 -diags -sv -distance1 kbit20_3" instead.
