###############################################################################
#' getTranscript
#' 
#' A method to query transcript data from Cellbase web services.
#' @details This method retrieves various genomic annotations for transcripts
#'  including exons, cDNA sequence, annotations flags, and cross references,etc.
#' @aliases getTranscript
#' @param object an object of class CellBaseR
#' @param ids a character vector of the transcript ids to be queried, use 
#' ensemble transccript IDs eq, ENST00000380152
#' @param resource a character vector to specify the resource to be queried
#' @param param an object of class CellBaseParam specifying additional params 
#' for the query
#' @return a dataframe with the results of the query
#' @examples
#'    cb <- CellBaseR()
#'    res <- getTranscript(object=cb, ids="ENST00000373644", resource="info")
#' @seealso  \url{https://github.com/opencb/cellbase/wiki} 
#' and the RESTful API documentation 
#' \url{http://bioinfo.hpc.cam.ac.uk/cellbase/webservices/}
#' @export
setMethod("getTranscript", "CellBaseR", definition = function(object, ids, 
                                                              resource, 
                                                              param=NULL) {

    categ <- "feature"
    subcateg<- "transcript"
    ids <- ids
    resource <- resource
    if (!is.null(param)) {
      param <- c(assembly=param@assembly,feature=param@feature,region=param@region
                 ,rsid=param@rsid,so=param@so, trait=param@trait,
                 accession=param@accession, type=param@type,
                 mode_inheritance_labels=param@mode_inheritance_labels,
                 clinsig_labels=param@clinsig_labels, 
                 alleleOrigin=param@alleleOrigin, 
                 consistency_labels=param@consistency_labels,
                 include=param@include, exclude=param@exclude,
                 limit=param@limit)
      param <- paste(param, collapse = "&")
    }
    result <- fetchCellbase(object=object, file=NULL, meta=NULL, categ=categ,
                            subcateg=subcateg,
                            ids=ids, resource=resource, param=NULL)
    return(result)
})
