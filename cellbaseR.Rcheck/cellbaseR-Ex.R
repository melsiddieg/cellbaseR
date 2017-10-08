pkgname <- "cellbaseR"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
library('cellbaseR')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
cleanEx()
nameEx("AnnotateVcf-CellBaseR-method")
### * AnnotateVcf-CellBaseR-method

flush(stderr()); flush(stdout())

### Name: AnnotateVcf,CellBaseR-method
### Title: AnnotateVcf
### Aliases: AnnotateVcf,CellBaseR-method AnnotateVcf

### ** Examples

cb <- CellBaseR()
fl <- system.file("extdata", "hapmap_exome_chr22_500.vcf.gz",
                  package = "cellbaseR" )
res <- AnnotateVcf(object=cb, file=fl, BPPARAM = bpparam(workers=2))



cleanEx()
nameEx("CellBaseParam")
### * CellBaseParam

flush(stderr()); flush(stdout())

### Name: CellBaseParam
### Title: A Constructor for the CellBaseParam Object
### Aliases: CellBaseParam

### ** Examples

cbParam <- CellBaseParam(genome="GRCh38",gene=c("TP73","TET1"))
print(cbParam)



cleanEx()
nameEx("CellBaseR")
### * CellBaseR

flush(stderr()); flush(stdout())

### Name: CellBaseR
### Title: CellBaseR
### Aliases: CellBaseR

### ** Examples

   cb <- CellBaseR()
   print(cb)



cleanEx()
nameEx("createGeneModel")
### * createGeneModel

flush(stderr()); flush(stdout())

### Name: createGeneModel
### Title: createGeneModel
### Aliases: createGeneModel

### ** Examples

cb <- CellBaseR()
test <- createGeneModel(object = cb, region = "17:1500000-1550000")



cleanEx()
nameEx("getCaddScores")
### * getCaddScores

flush(stderr()); flush(stdout())

### Name: getCaddScores
### Title: getCaddScores
### Aliases: getCaddScores

### ** Examples

cb <- CellBaseR()
res <- getCaddScores(cb, "19:45411941:T:C")



cleanEx()
nameEx("getCellBase-CellBaseR-method")
### * getCellBase-CellBaseR-method

flush(stderr()); flush(stdout())

### Name: getCellBase,CellBaseR-method
### Title: getCellBase
### Aliases: getCellBase,CellBaseR-method getCellBase

### ** Examples

   cb <- CellBaseR()
   res <- getCellBase(object=cb, category="feature", subcategory="gene", 
   ids="TET1", resource="info")



cleanEx()
nameEx("getCellBaseResourceHelp")
### * getCellBaseResourceHelp

flush(stderr()); flush(stdout())

### Name: getCellBaseResourceHelp
### Title: getCellBaseResourceHelp
### Aliases: getCellBaseResourceHelp

### ** Examples

cb <- CellBaseR()
# Get help about what resources are available to the getGene method
getCellBaseResourceHelp(cb, subcategory="gene")
# Get help about what resources are available to the getRegion method
getCellBaseResourceHelp(cb, subcategory="region")
# Get help about what resources are available to the getXref method
getCellBaseResourceHelp(cb, subcategory="id")



cleanEx()
nameEx("getChromosomeInfo-CellBaseR-method")
### * getChromosomeInfo-CellBaseR-method

flush(stderr()); flush(stdout())

### Name: getChromosomeInfo,CellBaseR-method
### Title: getChromosomeInfo
### Aliases: getChromosomeInfo,CellBaseR-method getChromosomeInfo

### ** Examples

   cb <- CellBaseR()
   res <- getChromosomeInfo(object=cb, ids="22", resource="info")



cleanEx()
nameEx("getClinical-CellBaseR-method")
### * getClinical-CellBaseR-method

flush(stderr()); flush(stdout())

### Name: getClinical,CellBaseR-method
### Title: getClinical
### Aliases: getClinical,CellBaseR-method getClinical

### ** Examples

   cb <- CellBaseR()
   cbParam <- CellBaseParam(gene=c("TP73","TET1"))
   res <- getClinical(object=cb,param=cbParam)



cleanEx()
nameEx("getClinicalByGene")
### * getClinicalByGene

flush(stderr()); flush(stdout())

### Name: getClinicalByGene
### Title: getClinicalByGene
### Aliases: getClinicalByGene

### ** Examples

cb <- CellBaseR()
res <- getClinicalByGene(cb, "TET1")



cleanEx()
nameEx("getClinicalByRegion")
### * getClinicalByRegion

flush(stderr()); flush(stdout())

### Name: getClinicalByRegion
### Title: getClinicalByRegion
### Aliases: getClinicalByRegion

### ** Examples

cb <- CellBaseR()
res <- getClinicalByRegion(cb, "17:1000000-1189811")



cleanEx()
nameEx("getConservationByRegion")
### * getConservationByRegion

flush(stderr()); flush(stdout())

### Name: getConservationByRegion
### Title: getConservationByRegion
### Aliases: getConservationByRegion

### ** Examples

cb <- CellBaseR()
res <- getConservationByRegion(cb, "17:1000000-1189811")



cleanEx()
nameEx("getGene-CellBaseR-method")
### * getGene-CellBaseR-method

flush(stderr()); flush(stdout())

### Name: getGene,CellBaseR-method
### Title: getGene
### Aliases: getGene,CellBaseR-method getGene

### ** Examples

   cb <- CellBaseR()
   res <- getGene(object=cb, ids=c("TP73","TET1"), resource="info")



cleanEx()
nameEx("getGeneInfo")
### * getGeneInfo

flush(stderr()); flush(stdout())

### Name: getGeneInfo
### Title: getGeneInfo
### Aliases: getGeneInfo

### ** Examples

cb <- CellBaseR()
res <- getGeneInfo(cb, "TET1")



cleanEx()
nameEx("getMeta-CellBaseR-method")
### * getMeta-CellBaseR-method

flush(stderr()); flush(stdout())

### Name: getMeta,CellBaseR-method
### Title: getMeta
### Aliases: getMeta,CellBaseR-method getMeta

### ** Examples

   cb <- CellBaseR()
   res <- getMeta(object=cb, resource="species")



cleanEx()
nameEx("getProtein-CellBaseR-method")
### * getProtein-CellBaseR-method

flush(stderr()); flush(stdout())

### Name: getProtein,CellBaseR-method
### Title: getProtein
### Aliases: getProtein,CellBaseR-method getProtein

### ** Examples

   cb <- CellBaseR()
   res <- getProtein(object=cb, ids="O15350", resource="info")



cleanEx()
nameEx("getProteinInfo")
### * getProteinInfo

flush(stderr()); flush(stdout())

### Name: getProteinInfo
### Title: getProteinInfo
### Aliases: getProteinInfo

### ** Examples

cb <- CellBaseR()
res <- getProteinInfo(cb, "O15350")



cleanEx()
nameEx("getRegion-CellBaseR-method")
### * getRegion-CellBaseR-method

flush(stderr()); flush(stdout())

### Name: getRegion,CellBaseR-method
### Title: getRegion
### Aliases: getRegion,CellBaseR-method getRegion

### ** Examples

   cb <- CellBaseR()
   res <- getRegion(object=cb, ids="17:1000000-1200000", resource="gene")



cleanEx()
nameEx("getRegulatoryByRegion")
### * getRegulatoryByRegion

flush(stderr()); flush(stdout())

### Name: getRegulatoryByRegion
### Title: getRegulatoryByRegion
### Aliases: getRegulatoryByRegion

### ** Examples

cb <- CellBaseR()
res <- getRegulatoryByRegion(cb, "17:1000000-1189811")



cleanEx()
nameEx("getSnp-CellBaseR-method")
### * getSnp-CellBaseR-method

flush(stderr()); flush(stdout())

### Name: getSnp,CellBaseR-method
### Title: getSnp
### Aliases: getSnp,CellBaseR-method getSnp

### ** Examples

cb <- CellBaseR()
res <- getSnp(object=cb, ids="rs6025", resource="info")



cleanEx()
nameEx("getSnpByGene")
### * getSnpByGene

flush(stderr()); flush(stdout())

### Name: getSnpByGene
### Title: getSnpByGene
### Aliases: getSnpByGene

### ** Examples

cb <- CellBaseR()
param <- CellBaseParam(limit = 10)
res <- getSnpByGene(cb, "TET1", param = param)



cleanEx()
nameEx("getTf-CellBaseR-method")
### * getTf-CellBaseR-method

flush(stderr()); flush(stdout())

### Name: getTf,CellBaseR-method
### Title: getTf
### Aliases: getTf,CellBaseR-method getTf

### ** Examples

   cb <- CellBaseR()
   param <- CellBaseParam(limit = 12)
   res <- getTf(object=cb, ids="CTCF", resource="tfbs", param=param)



cleanEx()
nameEx("getTfbsByRegion")
### * getTfbsByRegion

flush(stderr()); flush(stdout())

### Name: getTfbsByRegion
### Title: getTfbsByRegion
### Aliases: getTfbsByRegion

### ** Examples

cb <- CellBaseR()
res <- getTfbsByRegion(cb, "17:1000000-1189811")



cleanEx()
nameEx("getTranscript-CellBaseR-method")
### * getTranscript-CellBaseR-method

flush(stderr()); flush(stdout())

### Name: getTranscript,CellBaseR-method
### Title: getTranscript
### Aliases: getTranscript,CellBaseR-method getTranscript

### ** Examples

   cb <- CellBaseR()
   res <- getTranscript(object=cb, ids="ENST00000373644", resource="info")



cleanEx()
nameEx("getTranscriptByGene")
### * getTranscriptByGene

flush(stderr()); flush(stdout())

### Name: getTranscriptByGene
### Title: getTranscriptByGene
### Aliases: getTranscriptByGene

### ** Examples

cb <- CellBaseR()
res <- getTranscriptByGene(cb, "TET1")



cleanEx()
nameEx("getVariant-CellBaseR-method")
### * getVariant-CellBaseR-method

flush(stderr()); flush(stdout())

### Name: getVariant,CellBaseR-method
### Title: getVariant
### Aliases: getVariant,CellBaseR-method getVariant

### ** Examples

   cb <- CellBaseR()
   res <- getVariant(object=cb, ids="19:45411941:T:C", resource="annotation")



cleanEx()
nameEx("getVariantAnnotation")
### * getVariantAnnotation

flush(stderr()); flush(stdout())

### Name: getVariantAnnotation
### Title: getVariantAnnotation
### Aliases: getVariantAnnotation

### ** Examples

cb <- CellBaseR()
res <- getVariantAnnotation(cb, "19:45411941:T:C")



cleanEx()
nameEx("getXref-CellBaseR-method")
### * getXref-CellBaseR-method

flush(stderr()); flush(stdout())

### Name: getXref,CellBaseR-method
### Title: getXref
### Aliases: getXref,CellBaseR-method getXref

### ** Examples

   cb <- CellBaseR()
   res <- getXref(object=cb, ids="ENST00000373644", resource="xref")



### * <FOOTER>
###
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
