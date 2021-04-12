# barplots for Wochenende paper

setwd('/ngsssd1/rcug/wochenende_manuscript')

library("dplyr")
library("ggplot2")
library("tidyr")
library("stringr")

# control dataframe

control_df <- data.frame (chr_name  = c("Pseudomonas aeruginosa","Salmonella enterica","Escherichia coli",
                                      "Lactobacillus fermentum","Enterococcus faecalis","Staphylococcus aureus",
                                      "Listeria monocytogenes","Bacillus subtilis", "Cryptococcus neoformans",
                                      "Saccharomyces cerevisiae"),
                      control = c(12,12,12,12,12,12,12,12,2,2)
)



### Centrifuge ###

# import data
centrifuge_blank <- read.csv(file = '2020_036107_mock/centrifuge/mock_blank_S59_R1.fastq.report.s.csv', sep = "\t")
centrifuge_mockI <- read.csv(file = '2020_036107_mock/centrifuge/mock_I_S57_R1.fastq.report.s.csv', sep = "\t")
centrifuge_mockII <- read.csv(file = '2020_036107_mock/centrifuge/mock_II_S58_R1.fastq.report.s.csv', sep = "\t")

# merge all samples together
centrifuge_all <-  merge(centrifuge_blank, merge(centrifuge_mockI, centrifuge_mockII, by = c("name", "taxRank") , all = TRUE), by = c("name", "taxRank"), all = TRUE)

# select the right column, filter for species, rename column, replaces Na with 0 
centrifuge_all <- centrifuge_all %>% select(name, taxRank, numUniqueReads, numUniqueReads.x, numUniqueReads.y)
centrifuge_all <- filter(centrifuge_all, taxRank == "species")
colnames(centrifuge_all) <- c("chr_name", "taxRank", "numUniqueReads_blank", "numUniqueReads_I", "numUniqueReads_II")
centrifuge_all[is.na(centrifuge_all)] <- 0

# get the sums for each samples for the unique Readcount
sum_centrifuge_blank <- sum(as.numeric(centrifuge_all$numUniqueReads_blank))
sum_centrifuge_I <- sum(as.numeric(centrifuge_all$numUniqueReads_I))
sum_centrifuge_II <- sum(as.numeric(centrifuge_all$numUniqueReads_II))

# make the percentage
normalised_centrifuge <- centrifuge_all %>% 
  mutate(centrifuge_blank = as.numeric(numUniqueReads_blank) / sum_centrifuge_blank * 100) %>% 
  mutate(centrifuge_I = as.numeric(numUniqueReads_I) / sum_centrifuge_I  * 100) %>%
  mutate(centrifuge_II = as.numeric(numUniqueReads_II) / sum_centrifuge_II * 100)

# select the needed columns 
centrifuge_filt <- normalised_centrifuge %>% select(chr_name, centrifuge_blank, centrifuge_I, centrifuge_II)

# wanted chr names
chr_names <- c("Pseudomonas aeruginosa","Salmonella enterica","Escherichia coli",
               "Lactobacillus fermentum","Enterococcus faecalis","Staphylococcus aureus",
               "Listeria monocytogenes","Bacillus subtilis", "Cryptococcus neoformans",
               "Saccharomyces cerevisiae")

# filter for the wanted chromosomes and merge with control
centrifuge_filt <- filter(centrifuge_filt, chr_name %in% chr_names)
centrifuge_filt <- merge(centrifuge_filt, control_df, by = "chr_name", all = TRUE)

# convert to long format
centrifuge_long <- gather(centrifuge_filt, sample, percentage, 2:5, factor_key=TRUE)

# plot everything
# aes(x=chr_name, y=percentage, fill=sample)) +  # for "chromosomes"
ggplot(centrifuge_long, aes(x=sample, y=percentage, fill=chr_name)) + 
  geom_bar(stat="identity", position=position_dodge()) +
  ggtitle("Centrifuge")



### Kaiju ###

# import data
kaiju_blank <- read.csv(file = '2020_036107_mock/kaiju/mock_blank_S59_R1.fastq.kaiju_summary1.tsv', sep = "\t")
kaiju_mockI <- read.csv(file = '2020_036107_mock/kaiju/mock_I_S57_R1.fastq.kaiju_summary1.tsv', sep = "\t")
kaiju_mockII <- read.csv(file = '2020_036107_mock/kaiju/mock_II_S58_R1.fastq.kaiju_summary1.tsv', sep = "\t")

# merge all samples, selcet the wanted columns and change the names
kaiju_all <-  merge(kaiju_blank, merge(kaiju_mockI, kaiju_mockII, by = "taxon_name" , all = TRUE), by = "taxon_name", all = TRUE)
kaiju_all <- kaiju_all %>% select(taxon_name, percent, percent.x, percent.y)
colnames(kaiju_all) <- c("chr_name", "kaiju_blank", "kaiju_I", "kaiju_II")

# chromosomes wanted
chr_names <- c("Pseudomonas","Salmonella","Escherichia",
               "Lactobacillus","Enterococcus","Staphylococcus",
               "Listeria","Bacillus", "Cryptococcus",
               "Saccharomyces")

# filter for wanted chromosomes
kaiju_filt <- filter(kaiju_all, chr_name %in% chr_names)

# convert to long format
kaiju_long <- gather(kaiju_filt, sample, percentage, 2:4, factor_key=TRUE)
# plot everything
# aes(x=chr_name, y=percentage, fill=sample)) +  # for "chromosomes"
ggplot(kaiju_long, aes(x=sample, y=percentage, fill=chr_name)) + 
  geom_bar(stat="identity", position=position_dodge()) +
  ggtitle("Kaiju")



### Kraken ###

# import data
kraken_blank <- read.csv(file = '2020_036107_mock/krakenuniq/mock_blank_S59_R1.fastq.report.txt.species.filt.txt', sep = "\t", header=FALSE)
kraken_mockI <- read.csv(file = '2020_036107_mock/krakenuniq/mock_I_S57_R1.fastq.report.txt.species.filt.txt', sep = "\t", header=FALSE)
kraken_mockII <- read.csv(file = '2020_036107_mock/krakenuniq/mock_II_S58_R1.fastq.report.txt.species.filt.txt', sep = "\t", header=FALSE)

# merge all samples, select wanted columns and rename them 
kraken_all <-  merge(kraken_blank, merge(kraken_mockI, kraken_mockII, by = "V9" , all = TRUE), by = "V9", all = TRUE)
kraken_all <- kraken_all %>% select(V9, V1, V1.x, V1.y)
colnames(kraken_all) <- c("chr_name", "kraken_blank", "kraken_I", "kraken_II")

# delete all leading whitespaces in the chr_name column
kraken_all <- kraken_all %>% 
  mutate(chr_name = str_trim(chr_name, side = "left"))

# chromosomes wanted
chr_names <- c("Pseudomonas aeruginosa","Salmonella enterica","Escherichia coli",
                 "Lactobacillus fermentum","Enterococcus faecalis","Staphylococcus aureus",
                 "Listeria monocytogenes","Bacillus subtilis", "Cryptococcus neoformans",
                 "Saccharomyces cerevisiae")

# filter for wanted chromosomes and add control
kraken_filt <- filter(kraken_all, chr_name %in% chr_names)
kraken_filt <- merge(kraken_filt, control_df, by = "chr_name", all = TRUE)

# convert to long format
kraken_long <- gather(kraken_filt, sample, percentage, 2:5, factor_key=TRUE)
# plot everything
# aes(x=chr_name, y=percentage, fill=sample)) +  # for "chromosomes"
ggplot(kraken_long, aes(x=sample, y=percentage, fill=chr_name)) + 
  geom_bar(stat="identity", position=position_dodge()) +
  ggtitle("Krakenuniq")



### Metaphlan ###

# chr_names were shortened per hand in bash
# import data, select wanted columns and rename them 
metaphlan <- read.csv(file = '2020_036107_mock/metaphlan/mock_merged_abundance_table_sp_header.txt', sep = "\t")
metaphlan <- select(metaphlan, -NCBI_tax_id)
colnames(metaphlan) <- c("chr_name", "metaphlan_I", "metaphlan_II", "metaphlan_blank")

# wanted chromosomes
chr_names <- c("Pseudomonas_aeruginosa","Salmonella_enterica","Escherichia_coli",
                 "Lactobacillus_fermentum","Enterococcus_faecalis","Staphylococcus_aureus",
                 "Listeria_monocytogenes","Bacillus_subtilis", "Cryptococcus_neoformans",
                 "Saccharomyces_cerevisiae")

# filter for wanted chromosomes, replace all "_" with whitespace, add control, reorder dataframe
metaphlan_filt <- filter(metaphlan, chr_name %in% chr_names)
metaphlan_filt <- metaphlan_filt %>% 
  mutate(chr_name = str_replace(chr_name, "_", " "))
metaphlan_filt <- merge(metaphlan_filt, control_df, by = "chr_name", all = TRUE)
col_order <- c("chr_name", "metaphlan_blank", "metaphlan_I", "metaphlan_II", "control")
metaphlan_filt <- metaphlan_filt[, col_order]

# convert to long format
metaphlan_long <- gather(metaphlan_filt, sample, percentage, 2:5, factor_key=TRUE)
# plot everything
# aes(x=chr_name, y=percentage, fill=sample)) +  # for "chromosomes"
ggplot(metaphlan_long, aes(x=sample, y=percentage, fill=chr_name)) + 
  geom_bar(stat="identity", position=position_dodge()) +
  ggtitle("Metaphlan")



### Wochenende/Haybaler ###

# import data

haybaler_csv_1 <- read.csv(file = '2020_036107_mock/2021_02_ref/reporting/haybaler_output/RPMM_haybaler.csv', sep = "\t")
haybaler_csv_2 <- read.csv(file = 'metagen_mock_loman/reporting/haybaler_output/RPMM_haybaler.csv', sep = "\t")

# get RMPP sums for each sample

sum_blank <- sum(haybaler_csv_1$mock_blank_S59_R1)
sum_I <- sum(haybaler_csv_1$mock_I_S57_R1)
sum_II <- sum(haybaler_csv_1$mock_II_S58_R1)
sum_loman <- sum(haybaler_csv_2$Zymo.GridION.EVEN.BB.SN_R1)

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

# shorten chromosome names

shorten_chr <- c("Pseudomonas_aeruginosa","Salmonella_enterica","Escherichia_coli",
                 "Lactobacillus_fermentum","Enterococcus_faecalis","Staphylococcus_aureus",
                 "Listeria_monocytogenes","Bacillus_subtilis", "Cryptococcus_neoformans",
                 "Saccharomyces_cerevisiae")

# merge both csv 

csv_all <-  merge(haybaler_csv_1, haybaler_csv_2, by = "species", all = TRUE)

# df with only Saccharomyces_cerevisiae and only Cryptococcus_neoformans

csv_cryptococcus <- csv_all %>% 
  filter(str_detect(species, "Cryptococcus_neoformans"))

csv_saccharomyces <- csv_all %>% 
  filter(str_detect(species, "Saccharomyces_cerevisiae"))

# sum of all Saccharomyces_cerevisiae and Cryptococcus_neoformans strains for each sample

sum_cryptococcus_I <- sum(csv_cryptococcus$mock_I_S57_R1)
sum_cryptococcus_II <- sum(csv_cryptococcus$mock_II_S58_R1)
sum_cryptococcus_blank <- sum(csv_cryptococcus$mock_blank_S59_R1)
sum_cryptococcus_loman <-  0  # sum(csv_cryptococcus$Zymo.GridION.EVEN.BB.SN_R1) would be NA

sum_saccharomycess_I <- sum(csv_saccharomyces$mock_I_S57_R1)
sum_saccharomycess_II <- sum(csv_saccharomyces$mock_II_S58_R1)
sum_saccharomycess_blank <- sum(csv_saccharomyces$mock_blank_S59_R1)
sum_saccharomycess_loman <- 0  # sum(csv_saccharomyces$Zymo.GridION.EVEN.BB.SN_R1) would be NA


# make a row for Cryptococcus and Saccharomyces to add later to the final df 

cryptococcus <- c("Cryptococcus_neoformans", sum_cryptococcus_blank, sum_cryptococcus_II, sum_cryptococcus_I, sum_cryptococcus_loman)
saccharomycess <- c("Saccharomyces_cerevisiae", sum_saccharomycess_blank, sum_saccharomycess_II, sum_saccharomycess_I, sum_saccharomycess_loman)

# get the right rows (just the organisms in the mock community)

filt_csv <- filter(csv_all, species %in% orga)

# deselect unwanted columns

filt_csv_less <- select(filt_csv, -chr_length.x, -gc_ref.x, -chr_length.y, -gc_ref.y)

# add both yeasts columns

filt_csv_less <- rbind(filt_csv_less, cryptococcus, saccharomycess)

# normalize the data and add control

normalised_csv <- filt_csv_less %>% 
  # mutate(norm_blank = mock_blank_S59_R1 / sum_blank * 100) %>% error division by zero
  mutate(Wochenende_blank = as.numeric(mock_blank_S59_R1) * 0) %>% 
  mutate(Wochenende_I = as.numeric(mock_I_S57_R1) / sum_I  * 100) %>%
  mutate(Wochenende_II = as.numeric(mock_II_S58_R1) / sum_II * 100) %>% 
  mutate(Wochenende_Nanopore_Loman = as.numeric(Zymo.GridION.EVEN.BB.SN_R1) / sum_loman * 100)
normalised_csv["control"] <- c(12,12,12,12,12,12,12,12,2,2)

# 
normalised_csv_ordered <- setNames(data.frame(matrix(ncol = 11, nrow = 0)), colnames(normalised_csv))
for (organism in orga){
  normalised_csv_ordered <- rbind(normalised_csv_ordered, filter(normalised_csv, str_detect(species, organism)))
}

# add shortened names

normalised_csv_ordered["chr_name"] <- shorten_chr

# just the data we need

normalised_csv_less <- normalised_csv_ordered[ ,-1:-5]

# replace every "_" with whitespace

normalised_csv_less <- normalised_csv_less %>% 
  mutate(chr_name = str_replace(chr_name, "_", " "))

# chr_name as factor (makes sure that the groupes in the barchart are ordere correct)

normalised_csv_less$chr_name <- factor(normalised_csv_less$chr_name, levels = normalised_csv_less$chr_name)

# convert to long format

data_long <- gather(normalised_csv_less, sample, percentage, 1:5, factor_key=TRUE)

# plot everything
# aes(x=chr_name, y=percentage, fill=sample)) +  # for "chromosomes"
ggplot(data_long, aes(x=sample, y=percentage, fill=chr_name)) + 
  geom_bar(stat="identity", position=position_dodge()) +
  ggtitle("Wochenende")


### all Tools in one plot ###
# all = wochenende, centrifuge, metaphlan, krakenuniq (no kaiju)

# merge all to one df 
all <- merge(normalised_csv_less, centrifuge_filt, by = c("chr_name", "control"))
all <- merge(all, metaphlan_filt, by = c("chr_name", "control"))
all <- merge(all, kraken_filt, by = c("chr_name", "control"))

# convert to long format

all_long <- gather(all, sample, percentage, 2:15, factor_key=TRUE)

# plot everything
# aes(x=chr_name, y=percentage, fill=sample)) +  # for "chromosomes"
ggplot(all_long, aes(x=sample, y=percentage, fill=chr_name)) + 
  geom_bar(stat="identity", position=position_dodge()) +
  ggtitle("All Tools")
             
