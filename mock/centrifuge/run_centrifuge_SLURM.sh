#!/bin/bash
## Supply the FASTA input as arg1, sbatch run_centrifuge_SLURM.sh in.fastq.gz

# set partition
#SBATCH -p normal

# set run on big mem nodes
#SBATCH --mem 200000

# set run on bigmem node only
#SBATCH --cpus-per-task 24




# set max wallclock time
#SBATCH --time=47:00:00

# set name of job
#SBATCH --job-name=centrifuge

# mail alert at start, end and abortion of execution
#SBATCH --mail-type=ALL

# send mail to this address
#SBATCH --mail-user=davenport.colin@mh-hannover.de


echo "Input file: " $1
fastq=$1

# Add miniconda3 to PATH
. /mnt/ngsnfs/tools/miniconda3/etc/profile.d/conda.sh

# Activate env on cluster node
conda activate centrifuge

# DBs from https://benlangmead.github.io/aws-indexes/centrifuge

#centdb=/lager2/rcug/seqres/metagenref/centrifuge/p_compressed+h+v
centdb=/lager2/rcug/seqres/metagenref/centrifuge/nt

# Run script
centrifuge -x $centdb -p 24 -U $fastq -S $fastq.reads.txt --report-file $fastq.report.csv

# sorted descending in col6 for within experiment clarity. Include header
head -n 1 $fastq.report.csv >>  $fastq.report.s.csv
sort -t$'\t' -k6 -nr $fastq.report.csv >> $fastq.report.s.csv


