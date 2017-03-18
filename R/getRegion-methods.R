###############################################################################
#' getRegion
#' 
#'   A method to query features within a genomic region from Cellbase web 
#'   services.
#' @details  Please, for details on possible values
#' for the parameters  and  additional param of this function refer to 
#' https://github.com/opencb/cellbase/wiki and the 
#' RESTful API documentation http://bioinfo.hpc.cam.ac.uk/cellbase/webservices/
#' @aliases getRegion
#' @param object an object of class CellBaseR
#' @param ids a character vector of the regions to be queried, for example,
#'  "1:1000000-1200000' should always be in the
#' form 'chr:start-end'
#' @param resource a character vector to specify the resource to be queried
#' @param param a object of class CellBaseParam specifying additional param
#'  for the query
#' @return a dataframe with the results of the query
#' @examples
#'    cb <- CellBaseR()
#'    res <- getRegion(object=cb, ids="17:1000000-1200000", resource="gene")
#' @export
setMethod("getRegion", "CellBaseR", definition = function(object, ids, resource,
                                                          param=NULL) {
  
    categ <- "genomic"
    subcateg<- "region"
    ids <- ids
    resource <- resource
    if (!is.null(param)){
      param <- c(genome=param@genome, gene=param@gene,
                   region=param@region, rs=param@rs,so=param@so,
                   phenotype=param@phenotype, limit=param@limit, 
                   include=param@include, exclude=param@exclude,
                   limit=param@limit)
      param <- paste(param, collapse = "&")
    }
    result <- fetchCellbase(object=object, file=NULL, meta=NULL, categ=categ,
                            subcateg=subcateg, ids=ids, resource=resource, 
                            param=param)
    return(result)
})
