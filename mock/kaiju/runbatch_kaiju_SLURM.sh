#!/bin/bash
## Colin Davenport, Jan 2021
# Run kaiju metagenome analyzer

for i in $(ls *R1.fastq)

        do
	sbatch -c 24 run_kaiju_SLURM.sh $i


done
