#' getClinicalByGene
#' 
#' A convienice method to fetch clinical variants for specific gene/s
#' @param gene a charcter vector of HUGO symbol (gene names)
#' @return a dataframe of the query result
#' @examples 
#' res <- getClinicalByGene("TET1")
#' @export
getClinicalByGene <- function(gene){
 cb <- CellBaseR()
 res <- getGene(object = cb, ids = gene, resource = "clinical")
 res
}
##############################################################################
#' getTranscriptByGene
#' 
#' A convienice method to fetch transcripts for specific gene/s
#' @param gene a charcter vector of HUGO symbol (gene names)
#' @return a dataframe of the query result
#' @examples 
#' res <- getTranscriptByGene("TET1")
#' @export
getTranscriptByGene <- function(gene){
  cb <- CellBaseR()
  res <- getGene(object = cb, ids = gene, resource = "transcript")
  res
}
##############################################################################
#' getGeneInfo
#' 
#' A convienice method to fetch gene annotations specific gene/s
#' @param gene a charcter vector of HUGO symbol (gene names)
#' @return a dataframe of the query result
#' @examples 
#' res <- getGeneInfo("TET1")
#' @export
getGeneInfo <- function(gene){
  cb <- CellBaseR()
  res <- getGene(object = cb, ids = gene, resource = "info")
  res
}
##############################################################################
#' getSnpByGene
#' 
#' A convienice method to fetch known variants (snps) for specific gene/s
#' @param gene a charcter vector of HUGO symbol (gene names)
#' @return a dataframe of the query result
#' @examples 
#' res <- getSnpByGene("TET1")
#' @export
getSnpByGene <- function(gene){
  cb <- CellBaseR()
  res <- getGene(object = cb, ids = gene, resource = "snp")
  res
}
##############################################################################
#' getProteinInfo
#' 
#' A convienice method to fetch annotations for specific protein/s
#' @param protein a charcter vector of Uniprot Ids 
#' @return a dataframe of the query result
#' @examples 
#' res <- getProteinInfo("O15350")
#' @export
getProteinInfo <- function(protein){
  cb <- CellBaseR()
  res <- getProtein(object = cb, ids = protein, resource = "info")
  res
}
##############################################################################
#' getClinicalByRegion
#' 
#' A convienice method to fetch clinical variants for specific region/s
#' @param region a charcter vector of genomic regions, eg 17:1000000-1100000
#' @return a dataframe of the query result
#' @examples 
#' res <- getClinicalByRegion("17:1000000-1189811")
#' @export
getClinicalByRegion <- function(region){
  cb <- CellBaseR()
  res <- getRegion(object = cb, ids = region, resource = "clinical")
  res
}
##############################################################################
#' getConservationByRegion
#' 
#' A convienice method to fetch conservation data for specific region/s
#' @param region a charcter vector of genomic regions, eg 17:1000000-1100000
#' @return a dataframe of the query result
#' @examples 
#' res <- getConservationByRegion("17:1000000-1189811")
#' @export
getConservationByRegion <- function(region){
  cb <- CellBaseR()
  res <- getRegion(object = cb, ids = region, resource = "conservation")
  res
}
##############################################################################
#' getRegulatoryByRegion
#' 
#' A convienice method to fetch regulatory data for specific region/s
#' @param region a charcter vector of genomic regions, eg 17:1000000-1100000
#' @return a dataframe of the query result
#' @examples 
#' res <- getRegulatoryByRegion("17:1000000-1189811")
#' @export
getRegulatoryByRegion <- function(region){
  cb <- CellBaseR()
  res <- getRegion(object = cb, ids = region, resource = "regulatory")
  res
}
##############################################################################
#' getTfbsByRegion
#' 
#' A convienice method to fetch Transcription facrots data for specific region/s
#' @param region a charcter vector of genomic regions, eg 17:1000000-1100000
#' @return a dataframe of the query result
#' @examples 
#' res <- getTfbsByRegion("17:1000000-1189811")
#' @export
getTfbsByRegion <- function(region){
  cb <- CellBaseR()
  res <- getRegion(object = cb, ids = region, resource = "tfbs")
  res
}
##############################################################################
#' getCaddScores
#' 
#' A convienice method to fetch Cadd scores for specific variant/s
#' @param variant a charcter vector of genomic variants, eg 19:45411941:T:C
#' @return a dataframe of the query result
#' @examples 
#' res <- getCaddScores("19:45411941:T:C")
#' @export
getCaddScores <- function(variant){
  cb <- CellBaseR()
  res <- getVariant(object = cb, ids = variant, resource = "cadd")
  res
}
##############################################################################
#' getVariantAnnotation
#' 
#' A convienice method to fetch variant annotation for specific variant/s
#' @param variant a charcter vector of length < 200 of genomic variants,
#'  eg 19:45411941:T:C
#' @return a dataframe of the query result
#' @examples 
#' res <- getVariantAnnotation("19:45411941:T:C")
#' @export
getVariantAnnotation <- function(variant){
  cb <- CellBaseR()
  res <- getVariant(object = cb, ids = variant, resource = "annotation")
  res
}