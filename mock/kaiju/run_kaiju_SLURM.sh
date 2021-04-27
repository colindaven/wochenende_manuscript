#!/bin/bash
## Supply the FASTQ read input as arg1, bash run_kaiju_SLURM.sh in_R1.fastq

# set partition
#SBATCH -p normal

# set run on x MB node only
#SBATCH --mem 120000

# set run x cpus
#SBATCH --cpus-per-task 24

# set max wallclock time
#SBATCH --time=47:00:00

# set name of job
#SBATCH --job-name=kaiju

# Add miniconda3 to PATH
#. /mnt/ngsnfs/tools/miniconda3/etc/profile.d/conda.sh

# Activate env on cluster node
#conda activate wochenende >> /dev/null

echo "Input file: " $1
fastq=$1

threads=24

#db
db_fmi=/lager2/rcug/seqres/metagenref/kaiju/kaiju_db_nr_euk.fmi
#nodes and names from ncbi taxonomy
nodes=/lager2/rcug/seqres/metagenref/kaiju/nodes.dmp
names=/lager2/rcug/seqres/metagenref/kaiju/names.dmp
#
kaiju_bin=/mnt/ngsnfs/tools/kaiju/src/kaiju
kaiju_tab=/mnt/ngsnfs/tools/kaiju/src/kaiju2table


# Run kaiju
$kaiju_bin -z $threads -t $nodes -f $db_fmi -i $fastq -o $fastq.kaiju.ktxt


# then run helper scripts
$kaiju_tab -t $nodes -n $names -r genus -o $fastq.kaiju_summary1.tsv $fastq.kaiju.ktxt
$kaiju_tab -t $nodes -n $names -r genus -m 1.0 -o $fastq.kaiju_summary1pc.tsv $fastq.kaiju.ktxt

