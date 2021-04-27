#!/bin/bash

# Run krakenuniq

# Use existing conda env
. /mnt/ngsnfs/tools/miniconda3/etc/profile.d/conda.sh
conda activate krakenuniq

for filename in `ls ./*R1.fastq`

        do
                echo $filename
                sbatch -c 16 run_krakenuniq_SLURM.sh $filename
done
