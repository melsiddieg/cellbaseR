###############################################################################
#' getCellBase
#' 
#' The generic method for cbGet This method allows the user to query the 
#' cellbase web services without any  predefined categories, subcategries, 
#' or resources. Please, for details on possible values for the parameters and 
#' @aliases getCellBase
#' @param object an object of class CellBaseR
#' @param category character to specify the category to be queried.
#' @param subcategory character to specify the subcategory to be queried
#' @param ids a character vector of the ids to be queried
#' @param resource a character to specify the resource to be queried
#' @param param an object of class CellBaseParam specifying additional param
#'  for the CellBaseR
#' @param ... any extra arguments
#' @return a dataframe holding the results of the query
#' @examples
#'    cb <- CellBaseR()
#'    res <- getCellBase(object=cb, category="feature", subcategory="gene", 
#'    ids="TET1", resource="info")
#' @seealso  https://github.com/opencb/cellbase/wiki 
#' and the RESTful API documentation 
#' http://bioinfo.hpc.cam.ac.uk/cellbase/webservices/
#' @export
setMethod("getCellBase", "CellBaseR", definition = function(object, category, 
                                                      subcategory, ids, resource
                                                      ,param=NULL,...) {
  categ <- category
  subcateg<- subcategory
  ids <- ids
  resource <- resource
  if (!is.null(param)) {
    param <- c(genome=param@genome, gene=param@gene,region=param@region
                 , rs=param@rs,so=param@so, phenotype=param@phenotype,
                 limit=param@limit, include=param@include,
                 exclude=param@exclude, limit=param@limit)
    param <- paste(param, collapse = "&")
  }
  # TODO: param are not enabled
  result <- fetchCellbase(object=object, file=NULL, meta = NULL, categ=categ, 
                          subcateg=subcateg, ids=ids, resource=resource , 
                          param=param,...)
  
  return(result)
})
