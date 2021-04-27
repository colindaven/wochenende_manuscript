#!/bin/bash

# Last updated: April 2021
# Colin Davenport, Marie Pust

# SLURM parameters
# set partition
#SBATCH -p normal

# set run on x MB node only
#SBATCH --mem 40000

# set run x cpus
#SBATCH --cpus-per-task 12

# set name of job
#SBATCH --job-name=metaphlan3

# Add miniconda3 to PATH
. /mnt/ngsnfs/tools/miniconda3/etc/profile.d/conda.sh


# Activate env on cluster node
conda activate metaphlan >> /dev/null

threads=12
fastq_in=$1
metaphlan_db="/mnt/ngsnfs/tools/metaphlan_db/"
index="mpa_v30_CHOCOPhlAn_201901"

# Run

srun -c $threads metaphlan $fastq_in \
 --input_type fastq \
 --nproc $threads \
 --index $index \
 --bowtie2db $metaphlan_db \
 --bowtie2out ${fastq_in%.fastq}.bowtie2.bz2 \
 --unknown_estimation \
 -o ${fastq_in%.fastq}.profiled_metagenome.txt
