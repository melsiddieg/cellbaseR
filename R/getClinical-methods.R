###############################################################################
#' getClinical
#'
#'  A method to query Clinical data from Cellbase web services.
#' @details  Please, for details on possible values for the parameters 
#' and  additional param of this function refer to 
#' https://github.com/opencb/cellbase/wiki and the RESTful API 
#' documentation  http://bioinfo.hpc.cam.ac.uk/cellbase/webservices/
#' @aliases getClinical
#' @param object an object of class CellBaseR
#' @param param a object of class CellBaseParam specifying the parameters
#'  limiting the CellBaseR
#' @param ... any extra arguments
#' @return an object of class CellBaseResponse which holds a dataframe with the
#'  results of the query
#' @examples
#'    cb <- CellBaseR()
#'    cbParam <- CellBaseParam(gene=c("TP73","TET1"))
#'    res <- getClinical(object=cb,param=cbParam)
#' @export
##############################################################################
setMethod("getClinical", "CellBaseR", definition = function(object,
                                                            param=NULL,...) {
   
    categ <- "feature"
    subcateg<- "clinical"
    ids <- NULL
    resource <- "search"

    param <- c(genome=param@genome, gene=param@gene,
    region=param@region,rs=param@rs,so=param@so,
    phenotype=param@phenotype, include=param@include,
    exclude=param@exclude, limit=param@limit)
    param <- paste(param, collapse = "&")
    result <- fetchCellbase(object=object,file=NULL, meta=NULL, categ=categ, 
                            subcateg=subcateg,ids=ids,resource=resource, 
                            param=param,...)
    
    return(result)
})
