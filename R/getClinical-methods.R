###############################################################################
#' getClinical
#'
#'  A method to query Clinical data from Cellbase web services.
#' @details  Please, for details on possible values for the parameters 
#' and  additional filters of this function refer to 
#' https://github.com/opencb/cellbase/wiki and the RESTful API 
#' documentation  http://bioinfo.hpc.cam.ac.uk/cellbase/webservices/
#' @aliases getClinical
#' @param object an object of class CellBaseR
#' @param filters a object of class CellBaseParam specifying the parameters
#'  limiting the CellBaseR
#' @param ... any extra arguments
#' @return an object of class CellBaseResponse which holds a dataframe with the
#'  results of the query
#' @examples
#'    cb <- CellBaseR()
#'    cbParam <- CellBaseParam(gene=c("TP73","TET1"))
#'    res <- getClinical(object=cb,filters=cbParam)
#' @export
##############################################################################
setMethod("getClinical", "CellBaseR", definition = function(object,
                                                            filters=NULL,...) {
   
    categ <- "feature"
    subcateg<- "clinical"
    ids <- NULL
    resource <- "search"

    filters <- c(genome=filters@genome, gene=filters@gene,
    region=filters@region,rs=filters@rs,so=filters@so,
    phenotype=filters@phenotype, include=filters@include,
    exclude=filters@exclude, limit=filters@limit)
    filters <- paste(filters, collapse = "&")
    result <- fetchCellbase(object=object,file=NULL, meta=NULL, categ=categ, 
                            subcateg=subcateg,ids=ids,resource=resource, 
                            filters=filters,...)
    
    return(result)
})
