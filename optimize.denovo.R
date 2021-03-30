#optimize denovo
#devtools::install_github("DevonDeRaad/RADstackshelpR")
library(RADstackshelpR)

setwd("/Users/devder/Desktop/hipposideros/")

#optimize m
output<-optimize_m(m3="m_3.vcf",
           m4="m_4.vcf",
           m5="m_5.vcf",
           m6="m_6.vcf",
           m7="m_7.vcf")

#optimize M
output<-optimize_bigM(M1="M1.vcf",
           M2="M2.vcf",
           M3="M3.vcf",
           M4="M4.vcf",
           M5="M5.vcf",
           M6="M6.vcf",
           M7="M7.vcf",
           M8="M8.vcf")

#optimize n
optimize_n(nequalsMminus1="n1.vcf",
           nequalsM="n2.vcf",
           nequalsMplus1="n3.vcf")
           




#check out what's going on with missingness between samples
vcf<-vcfR::read.vcfR("/Users/devder/Desktop/hipposideros/m3.vcf")
missing.by.sample(vcf)
missing.by.snp(vcf)
#we have 41 samples, with 4664 SNPs retained at 60% completeness, and 346 SNPs retained at 80% completeness

light.vcf<-missing.by.sample(vcf, cutoff=.9)
missing.by.snp(light.vcf)
#after light filtering, we retain 38 samples, with 5694 SNPs at 60% complete, and 376 SNPs at 80% complete

#the strongly bimodal distribution of missing data by sample indicates potential batch effect or just bimodal sequencing outcomes
vcf.agg<-missing.by.sample(vcf, cutoff = .85)
missing.by.snp(vcf.agg)
#surprisingly, removing the most missing samples isn't accounting for this bimodality, and isn't fixing our problem

#I feel relatively confident that this is a batch effect because the samples driving it
#are not simply the ones with the most missing data 
#I think this means that even though the samples sequenced fine, the SNPs retained are largely non-overlapping
#it is only after filtering to 60% missing data that the batch effect appears
#Need to drop the samples that are missing data outliers after filtering
vcf.60<-missing.by.snp(vcf, cutoff=.6)
#shows me the list of the 10 problem samples

#subset the vcf to remove these 10 samples only
vcf@gt<-vcf@gt[,colnames(vcf@gt) != "Chalc.indi.WAM.22872" & colnames(vcf@gt) != "Chalc.indi.AMNH.21441" & colnames(vcf@gt) != "Chalc.indi.CAS.777" & colnames(vcf@gt) != "Chalc.indi.ANWC.B55964" & colnames(vcf@gt) != "Chalc.indi.AMNH.21534" 
               & colnames(vcf@gt) != "Chalc.indi.AMNH.21572" & colnames(vcf@gt) != "Chalco.step.KU.27832" & colnames(vcf@gt) != "Chalco.step.KU.12228" & colnames(vcf@gt) != "Chalco.step.WAM.26645" & colnames(vcf@gt) != "Chalc.indi.AMNH.21615"]

vcf
missing.by.snp(vcf)

#by removing potential batch effect samples, we retain 31 samples with 10846 SNPs at 60% complete, 3912 SNPs at 80% complete











setwd("/Users/devder/Desktop/hipposideros/")
optimize_m(m3="m3.vcf",
           m4="m4.vcf")

vcf<-vcfR::read.vcfR("m3.vcf")
missing.by.sample(vcf)

missing.by.snp(vcf)
vcfR::write.vcf(vcfr, "m3.filt.vcf")
missing.by.snp(vcfr)
setwd("/Users/devder/Desktop/aph.data/")
optimize_m(m3="populations.snps.vcf")
optimize_m(m3="m3.filt.vcf")

hist(rowSums(is.na(vcf@gt))/ncol(vcf@gt))

setwd("/Users/devder/Downloads/")
optimize_m(m3="populations.snps.vcf")
vcf<-vcfR::read.vcfR("populations.snps.vcf")
vcf<-missing.by.sample(vcf, cutoff = .9)
vcfR::write.vcf(vcf, "dummy.vcf")
optimize_m(m3="dummy.vcf")

