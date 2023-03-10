# Loading required packages for analysis
library(ggthemes)
library(cowplot)
library(zinbwave)
library(tidyverse)
library(phyloseq)
library(ggpubr)
library(DESeq2)
library(microbiome)
library(wesanderson)
# Setting working directory
setwd("~/Documents/Replic_study/my_counts/modified/")
# Global statistics analysis
## Reading global_stats file
global_data <-
  readxl::read_excel(
    "~/Documents/Replic_study/my_counts/modified/global_stats.xlsx",
    sheet = 4
  )
str(global_data)
View(global_data)
## Composition in viral and non viral sequences
global_data2 <- pivot_longer(
  global_data,
  cols = 3:4,
  names_to = "Type_of_reads",
  values_to = "Percentage_of_reads"
) %>%
  select(samples,
         `Type_of_reads`,
         `Percentage_of_reads`
  ) %>%
  as.data.frame()
str(global_data2)
View(global_data2)
## Box plot to compare composition in mapped reads and unmapped reads
global_data2 %>%
  ggplot(
    data = .,
    aes(x = samples,
        y = `Percentage_of_reads`,
        fill = `Type_of_reads`)
  ) +
  geom_bar(stat = "identity",
           position = "dodge",
           width = 0.5) +
  scale_y_continuous(
    labels = function(x) paste(x * 100, "%")
  ) +
  scale_fill_manual("Type_of_reads", 
                    values = c(
                      "mapped_reads" = "orange",
                      "unmapped_reads" = "black"
                        )
                    ) +
  theme_classic() + theme(text = element_text(size = 20))
###########################################################################
####
global_data3 <- pivot_longer(
  global_data,
  cols = 5:6,
  names_to = "Type_of_unmapped_reads",
  values_to =
    "Percentage_of_unmapped_reads"
) %>%
  select(
    samples,
    `Type_of_unmapped_reads`,
    `Percentage_of_unmapped_reads`
  ) %>%
  as.data.frame()
str(global_data3)
View(global_data3)
## Box plot to compare composition in viral reads and non viral reads
global_data3 %>%
  ggplot(
    data = .,
    aes(
      x = samples ,
      y = `Percentage_of_unmapped_reads`,
      fill = `Type_of_unmapped_reads`
      )
  ) +
  geom_bar(
    stat = "identity",
    position = "dodge",
    width = 0.5
    ) +
  scale_y_continuous(
    labels = function(x)
      paste(x * 100, "%")
  ) +
  theme_classic() +
  theme(
    text = element_text(size = 20),
    legend.position = "bottom"
    ) +
  scale_fill_manual(
    "Unmapped_reads :",
    values = c(
      "Virals" = "black",
      "Non virals" = "#999999"
        )
  ) +
  ylab("Percentage of unmapped reads")

## CONSTRUCTION DE BOÎTES À MOUSTÂCHES POUR COMPARER LES COMPOSITIONS EN
## SÉQUENCES LUES PHAGIQUES ET SÉQUENCES LUES POUR VIRUS D'EUCARYOTE PAR
## SITE DE COLLECTE

str(global_data)
global_data5 <-
  pivot_longer(
    global_data,
    cols = 7:8,
    names_to = "Type_of_viruses",
    values_to = "Percentage_of_viral_reads"
  ) %>%
  select(samples,
         `Type_of_viruses`,
         `Percentage_of_viral_reads`) %>%
  as.data.frame()
summary(global_data)
global_data5 %>%
  ggplot(
    data = .,
    aes(x = samples,
        y = `Percentage_of_viral_reads`,
        fill = `Type_of_viruses`)
  ) +
  geom_bar(stat = "identity",
           position = "dodge",
           width = 0.5) +
  scale_y_continuous(
    labels = function(x)
      paste(x * 100, "%")
  ) +
  theme_classic() +
  theme(text = element_text(size = 20),
        legend.position = "bottom") +
  scale_fill_manual(
    "Type_of_viruses :",
    values = c(
      "Bacteriophages" = "deeppink3",
      "Eukaryotic viruses" = "deepskyblue3"
    )
  ) +
  ylab("Percentage of viral reads")
# Exploratory analysis of viral community data using Phyloseq package
## Reading abundance table
otu_mat <-
  read.csv("species_abundance.csv",
           sep = "\t",
           row.names = 1)
head(otu_mat)
## Reading taxonomy table
tax_mat <- read.csv("Taxonomy_.csv", sep = "\t", row.names = 1)
head(tax_mat)
## Reading experimental metadata
my_samples <-
  read.csv("My_samples_meta_data.csv",
           sep = "\t",
           row.names =
             1)
str(my_samples)
my_samples$replicates <- row.names(my_samples)
## building phyloseq object
otu_mat <- as.matrix(otu_mat)
tax_mat <- as.matrix(tax_mat)
OTU = otu_table(otu_mat, taxa_are_rows = TRUE)
TAX = tax_table(tax_mat)
samples = sample_data(my_samples)
pseq <- phyloseq(OTU, TAX, samples)
sample_names(pseq)
pseq
sample_names(pseq)
rank_names(pseq)
sample_variables(pseq)

## CONSTRUCTION DE L'OBJECT PHYLOSEQ SPECIFIQUE AUX PHAGES
pseq_phage <- subset_taxa(pseq,
                          Embranchement %in% c("Uroviricota",
                                               "Phixviricota"))
pseq_phage
## VERIFICATION DE LA PROFONDEUR
plot_bar(pseq_phage) + theme_classic() +
  theme(axis.text.x = element_text(
    angle = 45,
    vjust = 1,
    hjust = 1
  )) +
  theme(text = element_text(size = 15)) +
  labs(x = "", y = "")
## APPLICATION DE LA MÉTHODE DE RARÉFACTION POUR HARMONISER LA PROFONDEUR
(pseq_phage <-
    rarefy_even_depth(pseq_phage, rngseed = 711, replace =
                        FALSE))
pseq_phage
## REVERIFICATION DE LA PROFONDEUR
plot_bar(pseq_phage) + theme_classic() +
  theme(axis.text.x = element_text(
    angle = 45,
    vjust = 1,
    hjust = 1
  )) +
  theme(text = element_text(size = 15)) +
  labs(x = "", y = "")
## CONSTRUCTION DU DIAGRAMME EN BÂTONS
### ORDRE
plot_bar(pseq_phage, x = "Echantillons.1", fill = "Ordre") +
  labs(x = "Echantillons", y = "Abondance relative\n") +
  coord_flip() +
  theme_linedraw() +
  theme(axis.text.x = element_text(
    angle = 45,
    vjust = 1,
    hjust = 1
  )) +
  theme(text = element_text(size = 15), legend.position = "bottom")
phyloseq::psmelt(pseq_phage) %>%
  ggplot(data = ., aes_string(x = "Echantillons.1", y = "Abundance")) +
  geom_bar(
    aes(fill = Ordre),
    stat = "identity",
    position = "dodge",
    color = "black",
    size = 0.75,
    width = 0.5
  ) +
  theme_classic() +
  theme(axis.text.x = element_text(
    angle = 45,
    vjust = 1,
    hjust = 1
  )) +
  theme(text = element_text(size = 15)) +
  labs(x = "Echantillons", y = "Abondance relative\n")
### TEST STATISTIQUE SUR LES ORDRES
pseq_phage_cp %>% phyloseq::tax_glom(., "Ordre") %>%
  phyloseq::psmelt() %>%
  select(Sample, Echantillons.1, Expositions, OTU, Ordre, Abundance) %>%
  as.data.frame() -> order_test_petit
order_test_petit
with(order_test_petit, interaction(Echantillons.1, Ordre)) -> order_test_petit$ORDER_ECHANT
order_test_petit %>% group_by(ORDER_ECHANT) %>%
  select(ORDER_ECHANT, Abundance) %>% as.data.frame() ->
  order_test_petit_v2
str(order_test_petit_v2)
factor(order_test_petit_v2$ORDER_ECHANT) ->
  order_test_petit_v2$ORDER_ECHANT
order_test_petit_v2
ORDER_PETIT = pairwise.t.test(
  order_test_petit_v2$Abundance,
  order_test_petit_v2$ORDER_ECHANT,
  pool.sd = F,
  p.adjust.method = "none",
  alternative = "two.sided"
)
ORDER_PETIT[["p.value"]]
anova.petit = aov(Abundance ~ ORDER_ECHANT, data = order_test_petit_v2)
summary(anova.petit)
ordering = TukeyHSD(anova.petit, "ORDER_ECHANT")
### FAMILLE
plot_bar(pseq_phage, x = "Echantillons.1", fill = "Famille") +
  labs(x = "Echantillons", y = "Abondance relative\n") +
  theme_classic() +
  theme(axis.text.x = element_text(
    angle = 45,
    vjust = 1,
    hjust = 1
  )) +
  theme(text = element_text(size = 15)) + coord_flip()
phyloseq::psmelt(pseq_phage) %>%
  ggplot(data = ., aes_string(x = "Echantillons.1", y = "Abundance")) +
  geom_bar(
    aes(fill = Famille),
    stat = "identity",
    position = "dodge",
    color = "black",
    size = 0.75,
    width = 0.5
  ) +
  theme_classic() +
  theme(axis.text.x = element_text(
    angle = 45,
    vjust = 1,
    hjust = 1
  )) +
  theme(text = element_text(size = 15), legend.position = "bottom") +
  labs(x = "Echantillons", y = "Abondance relative\n")
### DES FAMILLES DE PHAGES ABONDANTES (> 200)
pseq_phage %>%
  microbiome::transform(., "identity") -> pseq_phage_id
phyloseq::psmelt(pseq_phage_id) %>%
  filter(., Abundance > 200) %>%
  ggplot(data = ., aes_string(x = "Echantillons.1", y = "Abundance")) +
  geom_bar(
    aes(fill = Famille),
    stat = "identity",
    position = position_dodge(width = 0.9, preserve = "single"),
    color = "black",
    size = 1,
    width = 0.9
  ) +
  theme_classic() +
  theme(axis.text.x = element_text(
    angle = 45,
    vjust = 1,
    hjust = 1
  )) +
  theme(text = element_text(size = 15)) +
  labs(x = "Echantillons", y = "Abondance\n")
### BOXPLOT(DIAGRAMME EN boîte DE MOUSTACHE)
pseq_phage_id %>% phyloseq::tax_glom(., "Famille") %>%
  phyloseq::psmelt() %>% dplyr::select(OTU, Echantillons.1,
                                       Famille, Abundance) %>%
  ggplot(.,
         aes(
           x = Echantillons.1,
           y = Abundance,
           col = Famille,
           fill = Famille
         )) +
  geom_boxplot() +
  labs(x = "Echantillons", y = "Abondance des Familles") +
  theme_classic() +
  theme(text = element_text(size = 15))
### TEST STATISTIQUE SUR LES FAMILLES
pseq_phage_id %>% phyloseq::tax_glom(., "Famille") %>%
  phyloseq::psmelt() %>%
  select(Sample, Echantillons.1, OTU, Famille, Abundance) %>%
  as.data.frame() -> fam_test


with(fam_test, interaction(Famille, Echantillons.1)) -> fam_test$FAM_ECHANT
fam_test %>% group_by(FAM_ECHANT) %>%
  select(FAM_ECHANT, Abundance) %>% as.data.frame() -> fam_test2
str(fam_test2)
factor(fam_test2$FAM_ECHANT) -> fam_test2$FAM_ECHANT
fam_test2
pairwise.t.test(
  fam_test_v2$Abundance,
  fam_test_v2$ORDER_ECHANT,
  pool.sd = F,
  p.adjust.method = "none",
  alternative = "greater"
)
myaov_result = aov(Abundance ~ FAM_ECHANT, data = fam_test2)
summary(myaov_result)
TukeyHSD(myaov_result, "FAM_ECHANT", p.adjust.methods = "none")
## ALPHA AND BETA DIVERSITÉ
otu_mat <- as.matrix(otu_mat)
tax_mat <- as.matrix(tax_mat)
OTU = otu_table(otu_mat, taxa_are_rows = TRUE)
TAX = tax_table(tax_mat)
samples = sample_data(my_samples)
pseq <- phyloseq(OTU, TAX, samples)
### TRANSFORMATION LOGARITHMIQUE
pseq_phage %>%
  microbiome::transform(., "log10p") -> pseq_phage_comp
### ALPHA DIVERSITÉ
plot_richness(pseq_phage, x = "Sites", measures = c("Chao1")) +
  geom_boxplot() +
  theme_classic() +
  labs(x = "Sites de collecte", y = "Mesures d'Alpha Diversité") +
  theme(axis.text.x = element_text(angle = 0)) +
  theme(text = element_text(size = 25), legend.position = "none") +
  stat_compare_means(method = "t.test")
plot_richness(pseq_phage, x = "Echantillons.1", measures = c("Chao1")) +
  geom_boxplot() +
  theme_classic() +
  labs(x = "Echantillons", y = "Mesures d'Alpha Diversité") +
  theme(axis.text.x = element_text(
    angle = 45,
    vjust = 1,
    hjust = 1
  )) +
  theme(text = element_text(size = 25))
alpha <- estimate_richness(pseq_phage, measures = "Chao1")
alpha
alpha <- base::merge(my_samples, alpha, by = "row.names", all = TRUE)
View(alpha)
boxplot(Chao1 ~ Echantillons.1, data = alpha)
anova_result <- aov(Chao1 ~ Echantillons.1, alpha)
anova_result
summary(anova_result)
Tukey <- TukeyHSD(anova_result, "Echantillons.1", ordered = TRUE)
print(Tukey)
plot(Tukey)
### BETA DIVERSITÉ
pseq_phage_ordre <- tax_glom(pseq_phage_comp, "Ordre")
pseq_phage_ord <-
  ordinate(pseq_phage_ordre, method = "MDS", distance =
             "bray")
plot_ordination(
  pseq_phage_ordre,
  pseq_phage_ord,
  color = "Sites",
  type = "Sample",
  shape = "Insecticides"
) +
  geom_text(aes(label = replicates), size = 5, vjust = 1.5) +
  geom_point(size = 4) +
  theme_classic() + theme(text = element_text(size = 20))
phyloseq::plot_heatmap(
  pseq_phage,
  method = "MDS",
  distance = "bray",
  low = "white",
  high = "red",
  sample.order = c(
    "BD01",
    "BD02",
    "BD03",
    "BP02",
    "BP03",
    "BP04",
    "BU01",
    "BU02",
    "BU03",
    "DD01",
    "DD02",
    "DD03",
    "DP01",
    "DP02",
    "DP03",
    "DU01",
    "DU02",
    "DU03"
  )
) +
  theme(
    text = element_text(size = 15),
    axis.text.x = element_text(
      angle = 45,
      vjust = 1,
      hjust = 1
    ),
    axis.text.y = element_text(size = 10)
  )
# ANALYSES AVEC LE PAQUET MICROBIOMEANALYSTR
mbSet <- Init.mbSetObj()
mbSet <- SetModuleType(mbSet, "mdp")
mbSet <- ReadSampleTable(mbSet, "phage_metadata.csv")
mbSet <- Read16STaxaTable(mbSet, "phage_taxa_table.csv")
mbSet <- Read16SAbundData(mbSet, "phage_table.csv", "text",
                          "Others/Not_specific", "T")
mbSet <- SanityCheckData(mbSet, "text")
mbSet <- PlotLibSizeView(mbSet, "norm_libsizes_0", "png")
mbSet <- CreatePhyloseqObj(mbSet, "text", "Others/Not_specific", "F")
mbSet <- ApplyAbundanceFilter(mbSet, "prevalence", 4, 0.2)
mbSet <- ApplyVarianceFilter(mbSet, "iqr", 0.1)
## BETA DIVERSITÉ
mbSet <-
  PlotBetaDiversity(
    mbSet,
    plotNm = "beta_diver_Sites",
    ordmeth = "PCoA",
    distName = "bray",
    colopt = "expfac",
    metadata = "Sites",
    showlabel = "none",
    taxrank = "OTU",
    taxa = "Salmonella_virus_SP6",
    alphaopt = "Chao1",
    ellopt = "yes",
    format = "png",
    dpi = 72,
    custom_col = "default"
  )
mbSet <- PerformCategoryComp(mbSet, "OTU", "adonis2", "bray", "Sites")
mbSet <- PlotBetaDiversity(
  mbSet,
  plotNm = "beta_diver_Insecticides",
  ordmeth = "PCoA",
  distName = "bray",
  colopt = "expfac",
  metadata = "Insecticides",
  showlabel = "none",
  taxrank = "OTU",
  taxa = "Salmonella_virus_SP6",
  alphaopt = "Chao1",
  ellopt = "yes",
  format = "png",
  dpi = 72,
  custom_col = "default"
)
## ANALYSE COMPARATIVE D’ABONDANCE DIFFÉRENTIELLE
mbSet <- CreatePhyloseqObj(mbSet, "text", "Others/Not_specific", "F")
mbSet <- ApplyAbundanceFilter(mbSet, "prevalence", 4, 0.2)
mbSet <- ApplyVarianceFilter(mbSet, "iqr", 0.1)
### METHODE DU PAQUET EDGER
mbSet <- PerformNormalization(mbSet, "rarewi", "none", "rle")
mbSet <- PerformRNAseqDE(mbSet, "EdgeR", 0.05, "Samples", "NA", "Order")
mbSet <- PlotBoxData(mbSet, "box_plot_0", "Petitvirales", "png")
mbSet <- PlotBoxData(mbSet, "box_plot_2", "Caudovirales", "png")
### METHODE DU PAQUET LEFSER
mbSet <- PerformLefseAnal(mbSet, 0.1, "fdr", 2.0, "Samples", "F", "NA", "Order")
mbSet <- PlotLEfSeSummary(mbSet, 15, "dot", "bar_graph_lefser", "png")