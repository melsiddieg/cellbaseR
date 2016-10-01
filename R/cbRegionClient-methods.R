########################################################################################################################
#' A method to query features within a genomic region from Cellbase web services.
#' @details  Please, for details on possible values
#' for the parameters  and  additional filters of this function refer to https://github.com/opencb/cellbase/wiki and the 
#' RESTful API documentation  http://bioinfo.hpc.cam.ac.uk/cellbase/webservices/
#' @aliases cbRegionClient
#' @param object an object of class CellBaseR
#' @param ids a character vector of the regions to be queried, for example, "1:1000000-1200000' should always be in the
#' form 'chr:start-end'
#' @param resource a character vector to specify the resource to be queried
#' @param filters a object of class CellBaseParam specifying additional filters for the query
#' @param ... any extra arguments
#' @return an object of class CellBaseResponse which holds a dataframe with the results of the query
#' @examples
#'    cb <- CellBaseR()
#'    res <- cbRegionClient(object=cb, ids="17:1000000-1200000", resource="gene")
#' @export
setMethod("cbRegionClient", "CellBaseR", definition = function(object, ids, resource, filters=NULL,...) {
  
    categ <- "genomic"
    subcateg<- "region"
    ids <- ids
    resource <- resource
    
    result <- fetchCellbase(object=object, file=NULL, meta=NULL, categ=categ,
                            subcateg=subcateg, ids=ids, resource=resource, 
                            filters=NULL,...)
    return(result)
})
