###############################################################################
#' getMeta
#' 
#' A method for getting the avaiable metadata from the cellbase web services
#'
#' This method is for getting species data from the cellbase web services.
#' @details Please, for details on possible values for the 
#' parameters  and  additional filters of this function refer to 
#' https://github.com/opencb/cellbase/wiki and the RESTful 
#' http://bioinfo.hpc.cam.ac.uk/cellbase/webservices/
#' @aliases getMeta
#' @param object an object of class CellBaseR
#' @param resource the resource you want to query it metadata
#' @return a dataframe with the
#'  results of the query
#' @examples
#'    cb <- CellBaseR()
#'    res <- getMeta(object=cb, resource="species")
#' @export
setMethod("getMeta", "CellBaseR",    definition = function(object, resource){
    # host <- object@host
    object@species <- ""
    meta <- "meta/"
    categ <- NULL
    subcateg<- NULL
    ids <- NULL
    resource <- resource
    result <- fetchCellbase(object=object, file=NULL, meta=meta, categ=categ,
                            subcateg=subcateg,
                            ids=ids, resource=resource, filters=NULL)
    data <- lapply(result, function(x)as.data.frame(x))
    result <- rbind.pages(data)
    return(result)
})
