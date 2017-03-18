########################################################################################################################
#' getTranscript
#' 
#' A method to query transcript data from Cellbase web services.
#' @details  Please, for details on possible values for the 
#' parameters  and  additional params of this function refer to https://github.com/opencb/cellbase/wiki and the RESTful 
#' http://bioinfo.hpc.cam.ac.uk/cellbase/webservices/
#' @aliases getTranscript
#' @param object an object of class CellBaseR
#' @param ids a character vector of the transcript ids to be queried, for example, ensemble transccript ID
#' like ENST00000380152
#' @param resource a character vector to specify the resource to be queried
#' @param params a object of class CellBaseParam specifying additional params for the query
#' @param ... any extra arguments
#' @return a dataframe with the results of the query
#' @examples
#'    cb <- CellBaseR()
#'    res <- getTranscript(object=cb, ids="ENST00000373644", resource="info")
#' @export
setMethod("getTranscript", "CellBaseR", definition = function(object, ids, resource, params=NULL,...) {

    categ <- "feature"
    subcateg<- "transcript"
    ids <- ids
    resource <- resource
    result <- fetchCellbase(object=object, file=NULL, meta=NULL, categ=categ, subcateg=subcateg,
                            ids=ids, resource=resource, params=NULL,...)
    return(result)
})
