#Example of how to lookup SNPs in a region.

library('TwoSampleMR')
library('ieugwasr')

#Set up workingdirectory
WorkingDirectory<-'~/Desktop/OneDrive - University of Bristol/IEU_GWAS_presentation/'
setwd(WorkingDirectory)

snps_to_lookup <- c("rs6812193", "rs11868035")

#Get the associations across the traits in the database.

results <- phewas(variants=snps_to_lookup)

table(results$rsid)

output_dir<-paste0(WorkingDirectory,"results/example3/")
write.table(result, paste0(output_dir, "PheWaslookup_ieugwasr.output.tab"), sep="\t", row.names=F, col.names=T, quote=F)
