###############################################################################
#' getTfbs
#' 
#' A method to query transcription factors binding sites data from Cellbase web
#'  services.
#' @details Please for details on possible values for the parameters  and
#'   additional param of this function refer to
#' https://github.com/opencb/cellbase/wiki and the RESTful API documentation 
#' http://bioinfo.hpc.cam.ac.uk/cellbase/webservices/
#' @aliases getTfbs
#' @param object an object of class CellBaseR
#' @param ids a character vector of the ids to be queried, must be a valid 
#' transcription factor name, for example, 
#' Pdr1, and Oaf1
#' @param resource a character vector to specify the resource to be queried
#' @param param a object of class CellBaseParam specifying additional param
#'  for the query
#' @return a dataframe with the results of the query
#' @examples
#'    cb <- CellBaseR()
#'    res <- getTfbs(object=cb, ids="PAX1", resource="gene")
#' @export
setMethod("getTfbs", "CellBaseR",    definition = function(object, ids,
                                                           resource,
                                                           param=NULL) {
    categ <- "regulation"
    subcateg<- "tf"
    ids <- ids
    resource <- resource
    if (!is.null(param)) {
      param <- c(genome=param@genome, gene=param@gene,
                   region=param@region, rs=param@rs,so=param@so,
                   phenotype=param@phenotype, limit=param@limit, 
                   include=param@include, exclude=param@exclude,
                   limit=param@limit)
      param <- paste(param, collapse = "&")
    }
    result <- fetchCellbase(object=object, file=NULL, meta=NULL, categ=categ,
                            subcateg=subcateg,
                            ids=ids, resource=resource, param=param)
    return(result)
})
