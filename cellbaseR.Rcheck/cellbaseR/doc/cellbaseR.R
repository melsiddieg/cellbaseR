## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

## ---- eval=FALSE, message=FALSE------------------------------------------
#  # to get the default CellbaseR object (human data, from genome GRCh37)
#  library(cellbaseR)
#  # A default cellbaseR object is created as follows
#  cb <- CellBaseR()

## ---- message=FALSE, warning=FALSE---------------------------------------
library(cellbaseR)
cb <- CellBaseR()
genes <- c("TP73","TET1")
res <- getGene(object = cb, ids = genes, resource = "info")
str(res,2)
# as you can see the res dataframe also contains a transcripts column 
# which is in fact a list column of nested dataframes, to get the
# trasnscripts data.frame for first gene
TET1_transcripts <- res$transcripts[[1]]
str(TET1_transcripts,1)

## ---- message=FALSE, warning=FALSE---------------------------------------
# making a query through cbRegion to get all the clinically relevant variants 
# in a specific region
library(cellbaseR)
cb <- CellBaseR()
res <- getRegion(object=cb,ids="17:1000000-1005000",
resource="clinical")
# to get all conservation data in this region
res <- getRegion(object=cb,ids="17:1000000-1005000",
resource="conservation")
#likewise to get all the regulatory data for the same region
res <- getRegion(object=cb,ids="17:1000000-1005000", resource="regulatory")
str(res,1)

## ---- eval=FALSE,message=FALSE, warning=FALSE----------------------------
#  library(cellbaseR)
#  cb <- CellBaseR()
#  res2 <- getVariant(object=cb, ids="1:169549811:A:G", resource="annotation")
#  # to get the data
#  res2 <- cbData(res2)
#  str(res2, 1)

## ---- eval=TRUE, message=FALSE, warning=FALSE----------------------------
library(cellbaseR)
cb <- CellBaseR()
# First we have to specify aour param, we do that by creating an object of
# class CellbaseParam
cbparam <- CellBaseParam(gene="TET1", genome="GRCh38")
cbparam
# Note that cbClinical does NOT require any Ids to be passed, only the param
# and of course the CellbaseQuery object
res <- getClinical(object=cb,param=cbparam)
str(res,1)


## ----message=FALSE, warning=FALSE, eval=TRUE-----------------------------
library(cellbaseR)
cb <- CellBaseR()
test <- createGeneModel(object = cb, region = "17:1500000-1550000")
if(require("Gviz")){
  testTrack <- Gviz::GeneRegionTrack(test)
  Gviz::plotTracks(testTrack, transcriptAnnotation='symbol')
}


## ---- message=FALSE, warning=FALSE, eval=TRUE----------------------------
library(cellbaseR)
library(VariantAnnotation)
cb <- CellBaseR()
fl <- system.file("extdata", "hapmap_exome_chr22_500.vcf.gz",package = "cellbaseR" )
res <- AnnotateVcf(object=cb, file=fl, BPPARAM = bpparam(workers=2))
vcf <- readVcf(fl, "hg19")
samples(header(vcf))
length(rowRanges(vcf))==nrow(res)
str(res,1)


## ------------------------------------------------------------------------
library(cellbaseR)
cb <- CellBaseR()
# Get help about what resources are available to the getGene method
getCellBaseResourceHelp(cb, subcategory="gene")
# Get help about what resources are available to the getRegion method
getCellBaseResourceHelp(cb, subcategory="region")
# Get help about what resources are available to the getXref method
getCellBaseResourceHelp(cb, subcategory="id")



