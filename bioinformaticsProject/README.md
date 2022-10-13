Group Members: Patrick Bahk, Austin Chang, Brandon Barnacle

Usage: All you need to do to run the program is to type "./Bash_Project.sh" in the command line.
You should be running the program from the "bioinformaticsProject" folder.
It also also inferred that you have a folder located at the path
~/Private/Biocomputing2022/tools/ that contains the tools that are used for this
project. These tools include muscle, hmmbuild, and hmmsearch.
It is also assummed that the file structure is the same for where the gene files are placed.
The proteomes should be placed in a folder called "proteomes" that is in the 
"bioinformaticsProject" folder. The mcrAgenes and hsp70genes files should be placed in a 
folder called "ref_sequences" in the "bioinformaticsProject" folder.
This program will run for any number of mcrA, hsp70, and proteomes files.

This program creates some intermediate files to complete the program. These files include:
hsp70gene_all.fasta, hsp70gene_hmmbuild.hmm, hsp70search.txt, mcrAgene_all.fasta,
mcrAgene_hmmbuild.hmm, mcrAsearch.txt, muscled_hsp70gene.muscle, and muscled_mcrAgene.muscle.


The final output for the program are put into two files. The first contains the table
with information for all the proteomes. This file is proteome_table.txt. The second
file contains our recommendations to study. This file is Final_Recommendations.txt
