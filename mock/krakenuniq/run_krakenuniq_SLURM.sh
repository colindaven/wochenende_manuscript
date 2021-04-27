#!/bin/bash

# set partition
#SBATCH -p normal

# set run on bigmem node only
#SBATCH --mem 402000

# set run on 16 cores
#SBATCH --cpus-per-task 16

# set max wallclock time
#SBATCH --time=47:00:00

# set name of job
#SBATCH --job-name=runKrakUniq

#Add miniconda3 to PATH
. /mnt/ngsnfs/tools/miniconda3/etc/profile.d/conda.sh

#activate env on cluster
conda activate krakenuniq

#db path. Uncomment the one you want to use
#Standard DB
db=/lager2/rcug/seqres/metagenref/krakenuniq/db

echo "Input file: " $1
fastq=$1
	krakenuniq --db $db --preload
	krakenuniq --db $db --threads 16 --report-file $fastq.report.txt $fastq --unclassified-out $fastq.unclassified.txt --classified-out $fastq.classified.txt --output $fastq.output.txt
