#!/bin/bash
## run Rscript on a server with R, eg hpc04,5,6, hpc-rc08, etc

# Prepare data for R heatmaps
# exclude GC, ref length, any host chr etc (all distort heatmaps)
# Sophia Poertner, Colin Davenport, 2020-2021


prepare_files () {
  echo "INFO: Preparing files for R heatmap creation"
  for infile in `ls *haybaler.csv`
        do
        echo "Running on " $infile

        #exclude mouse, human, mito
        grep -v "^chr" $infile | grep -v "^1_1_1" > $infile.filt.csv

        # using tab delimiters, cut a max of 200 columns out excluding cols 2-3. Also restrict to number_of_taxa lines
        cut -f1,4-200 $infile.filt.csv | head -n $1 > $infile.filt2.csv

        # remove _complete_genome from labels
        sed "s/_complete_genome//g" $infile.filt2.csv > $infile.filt.heatmap.csv

        # shorten TODO names to 20 chars? awk ?
        #$infile.filt.heatmap.csv > $infile.filt.heatmap.csv
  done
}


create_heatmaps () {
  echo "INFO: Starting batch heatmap creation"

# check for rscript, exit if unavailable
rscript_bin="/usr/bin/Rscript"
if [[ ! -f $rscript_bin ]]
        then
        echo "INFO: Rscript binary not found, aborting. Could not find this, is R installed? " $rscript_bin
        exit
fi
echo "INFO: Using rscript binary: " $rscript_bin

# create heatmaps for each heatmap.csv file
for heatmapcsv in `ls *.heatmap.csv`
        do
        echo "INFO: Creating heatmap for file: $heatmapcsv"
        # run local
        $rscript_bin create_heatmap.R $heatmapcsv
done
}

# Create heatmaps with 50 taxa
if [ ! -d "top_50_taxa" ]
        then
	mkdir top_50_taxa
fi
# Run bash function for 50 taxa
prepare_files 50
create_heatmaps
mv *heatmap*.html *heatmap*.pdf top_50_taxa

# Create heatmaps with all taxa
if [ ! -d "all_taxa" ]
	then
	mkdir all_taxa
fi
# Run bash function for all taxa
prepare_files 10000000 # number of taxa is set so high its like all taxa, no sample should have more taxa
create_heatmaps
mv *heatmap*.html *heatmap*.pdf all_taxa

echo "INFO: Script completed"
