#Example of how to lookup SNPs in a region.

library('TwoSampleMR')
library('ieugwasr')

#Set up workingdirectory
WorkingDirectory<-'~/Desktop/OneDrive - University of Bristol/IEU_GWAS_presentation/'
setwd(WorkingDirectory)

snps_to_lookup <- c("rs6812193", "rs11868035")
outcome_traits <- c("ukb-b-6548","ukb-b-956","ukb-b-16943")


#Get the genomic coordinates for the SNPs (hg19).

snps <- variants_rsid(snps_to_lookup)
snps$start <- snps$pos - 500000
snps$end <- snps$pos + 50000
snps$region.id <- paste0(snps$chr,":",snps$start,"-",snps$end)

#Get the id to lookup up associations across region (chr:start-end).

#Lookup the associations in the region (turn off proxy lookup).

result <- associations(variants=snps$region.id,
                       id=outcome_traits,
                       proxies=0)

table(result$trait)

output_dir<-paste0(WorkingDirectory,"results/example2/")
write.table(result, paste0(output_dir, "regionlookup_output.tab"), sep="\t", row.names=F, col.names=T, quote=F)

#Find the index SNP associations within the region.

snp.df <- result[result$rsid%in%snps_to_lookup,]
write.table(snp.df, paste0(output_dir, "snplookup_output.tab"), sep="\t", row.names=F, col.names=T, quote=F)
