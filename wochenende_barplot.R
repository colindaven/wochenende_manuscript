# barplots for Wochenende paper

# set this to your directory
setwd('/working2/rcug_lw/sophias_projekte/wochenende_manuscript/mock')
# path for the output csv 
output <- "/working2/rcug_lw/sophias_projekte/wochenende_manuscript/all_tools.csv"

library("dplyr")
library("ggplot2")
library("tidyr")
library("stringr")
library("viridis")
library("ggsci")
library(grid)


### Centrifuge ###

# import data
centrifuge_mock <- read.csv(file = 'centrifuge/SRR11207337_metagenome_mock_dna_R1.fastq.report.s.csv', sep = "\t")

# select the right column, filter for species, rename column, replaces Na with 0 
centrifuge_mock <- centrifuge_mock %>% select(name, taxRank, numUniqueReads)
centrifuge_mock <- filter(centrifuge_mock, taxRank == "species")
colnames(centrifuge_mock) <- c("chr_name", "taxRank", "numUniqueReads")
centrifuge_mock[is.na(centrifuge_mock)] <- 0

# get the sum for the unique Readcount
sum_centrifuge <- sum(as.numeric(centrifuge_mock$numUniqueReads))

# make the numReads percentage
normalised_centrifuge <- centrifuge_mock %>% 
  mutate(centrifuge = as.numeric(numUniqueReads) / sum_centrifuge  * 100)

# select the needed columns 
centrifuge_filt <- normalised_centrifuge %>% select(chr_name, centrifuge)

# wanted chr names
chr_names <- c("Pseudomonas aeruginosa","Salmonella enterica","Escherichia coli",
               "Lactobacillus fermentum","Enterococcus faecalis","Staphylococcus aureus",
               "Listeria monocytogenes","Bacillus subtilis", "Cryptococcus neoformans",
               "Saccharomyces cerevisiae")

# filter for the wanted chromosomes and merge with control
centrifuge_filt <- filter(centrifuge_filt, chr_name %in% chr_names)

# shorten chr_names
centrifuge_filt <- centrifuge_filt %>% 
  mutate(chr_name = str_replace(chr_name, "[a-z]* ", ". "))



### Kraken ###

# import data
kraken_mock <- read.csv(file = 'krakenuniq/SRR11207337_metagenome_mock_dna_R1.fastq.report.txt.species.filt.txt', sep = "\t", header=FALSE)

# select wanted columns and rename them 
kraken_mock <- kraken_mock %>% select(V9, V1)
colnames(kraken_mock) <- c("chr_name", "kraken")

# delete all leading whitespaces in the chr_name column
kraken_mock <- kraken_mock %>% 
  mutate(chr_name = str_trim(chr_name, side = "left"))

# chromosomes wanted
chr_names <- c("Pseudomonas aeruginosa","Salmonella enterica","Escherichia coli",
                 "Lactobacillus fermentum","Enterococcus faecalis","Staphylococcus aureus",
                 "Listeria monocytogenes","Bacillus subtilis", "Cryptococcus neoformans",
                 "Saccharomyces cerevisiae")

# filter for wanted chromosomes and add control
kraken_filt <- filter(kraken_mock, chr_name %in% chr_names)

# shorten chr_names
kraken_filt <- kraken_filt %>% 
  mutate(chr_name = str_replace(chr_name, "[a-z]* ", ". "))



### Metaphlan ###

# chr_names where shortened per hand in bash
# import data, select wanted columns and rename them 
metaphlan <- read.csv(file = 'metaphlan/SRR11207337_metagenome_mock_dna_R1.profiled_metagenome_species.txt', sep = "\t")
metaphlan <- select(metaphlan, -NCBI_tax_id, -additional_species)
colnames(metaphlan) <- c("chr_name", "metaphlan")

# wanted chromosomes
chr_names <- c("Pseudomonas_aeruginosa_group","Salmonella_enterica","Escherichia_coli",
                 "Lactobacillus_fermentum","Enterococcus_faecalis","Staphylococcus_aureus",
                 "Listeria_monocytogenes","Bacillus_subtilis", "Cryptococcus_neoformans",
                 "Saccharomyces_cerevisiae")

# filter for wanted chromosomes, replace all "_" with whitespace, add control, reorder dataframe
metaphlan_filt <- filter(metaphlan, chr_name %in% chr_names)
metaphlan_filt <- metaphlan_filt %>% 
  mutate(chr_name = str_replace(chr_name, "_", " ")) %>% 
  mutate(chr_name = str_replace(chr_name, "_group", ""))
# metaphlan_filt <- merge(metaphlan_filt, control_df, by = "chr_name", all = TRUE)
col_order <- c("chr_name", "metaphlan")  # , "control"
metaphlan_filt <- metaphlan_filt[, col_order]

# shorten chr_names
metaphlan_filt <- metaphlan_filt %>% 
  mutate(chr_name = str_replace(chr_name, "[a-z]* ", ". "))



### Wochenende/Haybaler ###

# import data

wochenende_mock <- read.csv(file = 'wochenende/reporting/haybaler/haybaler_output/RPMM_haybaler.csv', sep = "\t")

# get RMPP sums for the sample

sum_wochenende <- sum(wochenende_mock$SRR11207337_metagenome_mock_dna_R1)

#organisms for the barplot
orga <- c("1_AE004091_2_Pseudomonas_aeruginosa_PAO1__complete_genome_BAC",
          "1_AE006468_2_Salmonella_enterica_subsp__enterica_serovar_Typhimurium_str__LT2__complete_genome_BAC",
          "1_U00096_3_Escherichia_coli_str__K_12_substr__MG1655__complete_genome_BAC",
          "1_AP008937_1_Lactobacillus_fermentum_IFO_3956_DNA__complete_genome_BAC",
          "1_AE016830_1_Enterococcus_faecalis_V583_chromosome__complete_genome_BAC",
          "1_AJ938182_1_Staphylococcus_aureus_RF122_complete_genome_BAC",
          "1_AE017262_2_Listeria_monocytogenes_str__4b_F2365__complete_genome_BAC",
          "1_AL009126_3_Bacillus_subtilis_subsp__subtilis_str__168_complete_genome_BAC",
          "Cryptococcus_neoformans",
          "Saccharomyces_cerevisiae"
          )

# shortened chromosome names

shorten_chr <- c("Pseudomonas_aeruginosa","Salmonella_enterica","Escherichia_coli",
                 "Lactobacillus_fermentum","Enterococcus_faecalis","Staphylococcus_aureus",
                 "Listeria_monocytogenes","Bacillus_subtilis", "Cryptococcus_neoformans",
                 "Saccharomyces_cerevisiae")

# df with only Saccharomyces_cerevisiae and only Cryptococcus_neoformans

df_cryptococcus <- wochenende_mock %>% 
  filter(str_detect(species, "Cryptococcus_neoformans"))

df_saccharomyces <- wochenende_mock %>% 
  filter(str_detect(species, "Saccharomyces_cerevisiae"))

# median of all Saccharomyces_cerevisiae and Cryptococcus_neoformans strains for each sample

median_cryptococcus <- median(df_cryptococcus$SRR11207337_metagenome_mock_dna_R1)
median_saccharomycess <- median(df_saccharomyces$SRR11207337_metagenome_mock_dna_R1)

# make a row for Cryptococcus and Saccharomyces to add later to the final df 

cryptococcus <- c("Cryptococcus_neoformans", median_cryptococcus)
saccharomycess <- c("Saccharomyces_cerevisiae", median_saccharomycess)

# get the right rows (just the organisms in the mock community)

wochenende_filt <- filter(wochenende_mock, species %in% orga)

# deselect unwanted columns

wochenende_filt <- select(wochenende_filt, -chr_length, -gc_ref)

# add both yeasts columns

wochenende_filt <- rbind(wochenende_filt, cryptococcus, saccharomycess)

# normalize the data, make it percentage

wochenende_filt <- wochenende_filt %>% 
  mutate(Wochenende = as.numeric(SRR11207337_metagenome_mock_dna_R1) / sum_wochenende  * 100)

wochenende_filt <- wochenende_filt
for (organism in orga){
  wochenende_filt <- rbind(wochenende_filt, filter(wochenende_filt, str_detect(species, organism))) 
}

# add shortened names

wochenende_filt["chr_name"] <- shorten_chr

# just the data we need

wochenende_filt <- wochenende_filt[ ,-1:-2]
wochenende_filt <- wochenende_filt %>% slice(1:10)

# replace every "_" with whitespace

wochenende_filt <- wochenende_filt %>% 
  mutate(chr_name = str_replace(chr_name, "_", " ")) %>% 
  mutate(chr_name = str_replace(chr_name, "[a-z]* ", ". "))

# chr_name as factor (makes sure that the groups in the barchart are ordered correct)
wochenende_filt$chr_name <- factor(wochenende_filt$chr_name, levels = wochenende_filt$chr_name)



### all Tools in one plot ###
# all = wochenende, centrifuge, metaphlan, krakenuniq

# merge all to one df 
all <- merge(wochenende_filt, centrifuge_filt, by = c("chr_name"), all=TRUE)
all <- merge(all, metaphlan_filt, by = c("chr_name"), all=TRUE)
all <- merge(all, kraken_filt, by = c("chr_name"), all=TRUE)
all_needed <- select(all,chr_name, Wochenende, centrifuge, metaphlan, kraken)
all_needed[is.na(all_needed)] <- 0
colnames(all_needed) <- c("chr_name", "Wochenende", "Centrifuge", "Metaphlan", "KrakenUniq")
write.csv(all_needed, output, row.names = FALSE)

# convert to long format

all_long <- gather(select(all_needed,chr_name, Wochenende, Centrifuge, Metaphlan, KrakenUniq), sample, percentage, 2:5, factor_key=TRUE)

grouped_pallete <- c("#3399FF", "#0066CC", "#3399CC", "#99FF00", "#33FF00", "#FF66CC", "#FF33CC", "#FF6600", "#FF3300")
grouped_pallete_2 <- c("#009966", "#339966", "#66CC99", "#CCFF33", "#CCFF99", "#FF9900", "#FFCC33", "#CC3333", "#FF3333")

# plot everything
  ggplot(all_long, aes(x=chr_name, y=percentage, fill=sample)) + 
  geom_bar(stat="identity", position=position_dodge()) +
  ggtitle("All Tools") + 
  geom_segment(aes(x = 0, y = 12, xend = 7.5, yend = 12), color="red")  +
  geom_segment(aes(x = 0, y = 13.8, xend = 7.5, yend = 13.8), linetype="dashed")  + 
  geom_segment(aes(x = 0, y = 10.2, xend = 7.5, yend = 10.2), linetype="dashed")  + 
  geom_segment(aes(x = 7.5, y = 2, xend = 11, yend = 2), color="red")  + 
  geom_segment(aes(x = 7.5, y = 2.3, xend = 11, yend = 2.3), linetype="dashed")  +  
  geom_segment(aes(x = 7.5, y = 1.7, xend = 11, yend = 1.7), linetype="dashed")  +  
  theme_light() +
  # scale_fill_manual(values=grouped_pallete)
  # scale_fill_manual(values=grouped_pallete_2)
  # scale_fill_brewer(palette="Set1")
  scale_fill_brewer(palette="Set3")
  # scale_fill_brewer(palette="Spectral")
  # scale_fill_viridis(discrete = TRUE, option = "D")
  # scale_fill_viridis(discrete = TRUE, option = "C")
