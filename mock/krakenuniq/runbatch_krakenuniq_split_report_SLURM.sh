#!/bin/bash
# Colin Davenport, Nov 2020
# Split and filter krakenuniq reports

for filename in `ls ./*.report.txt`

        do
                echo "INFO: Filtering to >=20kmer support and splitting file into genus and species: " $filename
                srun head -n 5 $filename > $filename.unclassified.txt
                srun grep genus $filename | awk -F "\t" '$2>=20' > $filename.genus.filt.txt
                srun grep species $filename | awk -F "\t" '$2>=20' > $filename.species.filt.txt


done
