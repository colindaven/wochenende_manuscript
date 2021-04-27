#!/bin/bash
set -eo pipefail
# Colin Davenport, April 2020
# Collect and filter kraken results
# Run multiqc report
# Collect mapping stats from flagstat
# Run filter: Keep all lines in the Kraken report where column 2 (reads aligned)
# is greater than X (here probably 500). 

rm -f *.01mm.bam.txt *.01mm.dup.calmd.bam.txt *.mq30.bam.txt


# Add miniconda3 to PATH
. /mnt/ngsnfs/tools/miniconda3/etc/profile.d/conda.sh

# Activate env on cluster node
conda activate wochenende >> /dev/null


# Run multiqc
multiqc -f .


echo "INFO:  Filtering Kraken-uniq files"
## Filter:
# Sorted descending in column 2 for within experiment clarity
for i in `find . -name "*report.txt"`
        do
	awk -F "\t" '$2>=500' $i > $i.filt.txt
done


echo "INFO:  Script completed"
