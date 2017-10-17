###############################################################################
#' getClinical
#'
#'  A method to query Clinical data from Cellbase web services.
#' @details  This method retrieves clinicaly relevant variants annotations from
#' multiple resources including clinvar, cosmic and gwas catalog. Furthermore,
#'  the user can filter these data in many ways including trait, features, rs,
#'  etc,.
#' @aliases getClinical
#' @param object an object of class CellBaseR
#' @param param a object of class CellBaseParam specifying the parameters
#'  limiting the CellBaseR
#' @return a dataframe with the results of the query
#' @examples
#'    cb <- CellBaseR()
#'    cbParam <- CellBaseParam(feature=c("TP73","TET1"), limit=100)
#'    res <- getClinical(object=cb,param=cbParam)
#' @seealso  \url{https://github.com/opencb/cellbase/wiki} 
#' and the RESTful API documentation 
#' \url{http://bioinfo.hpc.cam.ac.uk/cellbase/webservices/}   
#' @export
##############################################################################
setMethod("getClinical", "CellBaseR", definition = function(object,
                                                            param=NULL) {
   
    categ <- "clinical"
    subcateg<-"variant" 
    ids <- NULL
    resource <- "search"

    param <- c(assembly=param@assembly, feature=param@feature,
    region=param@region,rsid=param@rsid,so=param@so,
    trait=param@trait, include=param@include,
    exclude=param@exclude, limit=param@limit)
    param <- paste(param, collapse = "&")
    result <- fetchCellbase(object=object,file=NULL, meta=NULL, categ=categ, 
                            subcateg=subcateg,ids=ids,resource=resource, 
                            param=param)
    
    return(result$annotation)
})
