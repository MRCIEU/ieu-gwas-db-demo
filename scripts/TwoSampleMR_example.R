#Example script - pQTL v PD two sample MR

library(devtools)

#Install TwoSampleMR
devtools::install_github("MRCIEU/TwoSampleMR")

#Install ieugwasr
devtools::install_github("mrcieu/ieugwasr")

#Install gwasglue

#Needs GenomicRanges Bioconducter.
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("GenomicRanges")

devtools::install_github("mrcieu/gwasglue")

library('TwoSampleMR')
library('ieugwasr')
library('gwasglue')

#Set up workingdirectory
WorkingDirectory<-'~/Desktop/OneDrive - University of Bristol/IEU_GWAS_presentation/'
setwd(WorkingDirectory)

#Traits of interest.

##Exposure GWAS

###Get the available GWASs in the database.
ao<-gwasinfo()
str(ao)
head(ao)

###Extract the list of pQTLs to lookup.
exp_traits <- unique(ao[grepl("prot-a-", ao$id),]$id)

###Example - get descriptive statistics for pQTL.
gwasinfo("prot-a-1363")

##Outcome GWAS
outcome_traits <- c("ukb-b-6548","ukb-b-956","ukb-b-16943")



###Double check IDs.
gwasinfo("ukb-b-6548")
gwasinfo("ukb-b-956")
gwasinfo("ukb-b-16943")

#Extract the instruments from the pQTL GWAS
exp.df <- tophits(
  id=exp_traits,
  pval = 5e-08, #default
  clump = 1, #flag to clump or not
  r2 = 0.001, #default
  kb = 10000, #default
)

str(exp.df)

#Find the instruments in the outcome GWASs.

snp_list <- unique(exp.df$rsid)

out.df <- associations(
  variants=snp_list, #rsids to lookup
  id=outcome_traits, #traits to lookup
  proxies = 1, #Look for proxies in outcome.
  r2 = 0.8, #proxy r2 required
  align_alleles = 1, #default
  palindromes = 1, #default
  maf_threshold = 0.3, #default
)

#Harmonise the data.

##Convert to MRBase format and save out to rds.

output_dir<-paste0(WorkingDirectory,"results/example1/")

#Using TwoSampleMR

exp.dat<-format_data(
 dat=exp.df,
  type="exposure",
  phenotype_col = "trait",
  snp_col="rsid",
  effect_allele_col="ea",
  other_allele_col="nea",
  eaf_col = "eaf",
  beta_col = "beta",
  se_col="se",
  pval_col="p",
  samplesize_col = "n"
)

saveRDS(exp.dat, paste0(output_dir, "instruments.rds"))

#Using TwoSampleMR.

out.dat<-format_data(
  dat=out.df,
  type="outcome",
  phenotype_col = "trait",
  snp_col="rsid",
  effect_allele_col="ea",
  other_allele_col="nea",
  eaf_col = "eaf",
  beta_col = "beta",
  se_col="se",
  pval_col="p",
  samplesize_col = "n"
)

saveRDS(out.dat, paste0(output_dir, "instrument_outcome_assoc.rds"))

#Harmonise the exposure and outcome associations.

dat <- harmonise_data(exp.dat, out.dat)

saveRDS(dat, paste0(output_dir, "harmon_output.rds"))

#Run the MR (Wald Ratios only).

res <- mr_singlesnp(dat)

write.table(res, paste0(output_dir, "singlesnpWR_output.tab"), sep="\t", row.names=F, col.names=T, quote=F)
