###############################################################################
#' getSnp
#' 
#' A method to query genomic variation data from Cellbase web services from 
#' Cellbase web services. 
#' @details Please for details on possible values for the parameters  and  
#' additional filters of this function refer to
#' https://github.com/opencb/cellbase/wiki and the RESTful API documentation 
#' http://bioinfo.hpc.cam.ac.uk/cellbase/webservices/
#' @aliases getSnp
#' @param object an object of class CellBaseR
#' @param ids a character vector of the ids to be queried, must be a valid rsid,
#' for example 'rs6025'
#' @param resource a character vector to specify the resource to be queried
#' @param filters a object of class CellBaseParam specifying additional filters
#'  for the query
#' @param ... any extra arguments
#' @return a dataframe with the results of the query
#' @examples
#' cb <- CellBaseR()
#' res <- getSnp(object=cb, ids="rs6025", resource="info")
#' @export
setMethod("getSnp", "CellBaseR", definition = function(object, ids, resource,
                                                       filters=NULL,...) {
    categ <- "feature"
    subcateg<- "variation"
    ids <- ids
    resource <- resource
    if (!is.null(filters)) {
      filters <- c(genome=filters@genome, gene=filters@gene,
                   region=filters@region, rs=filters@rs,so=filters@so,
                   phenotype=filters@phenotype, limit=filters@limit, 
                   include=filters@include, exclude=filters@exclude,
                   limit=filters@limit)
      filters <- paste(filters, collapse = "&")
    }
    result <- fetchCellbase(object=object, file=NULL, meta=NULL, categ=categ,
                            subcateg=subcateg, ids=ids, resource=resource,
                            filters=filters,...)
    return(result)
})
