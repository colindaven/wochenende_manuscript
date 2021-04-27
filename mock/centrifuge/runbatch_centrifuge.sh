#!/bin/bash
## Colin, Oct 2018

for i in `ls *.fastq`
        do
	sbatch run_centrifuge_SLURM.sh $i
done



