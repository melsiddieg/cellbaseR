###############################################################################
#' getCellBase
#' 
#' The generic method for querying CellBase web services.
#' @details  This method allows the user to query the 
#' cellbase web services without any  predefined categories, subcategries, 
#' or resources.
#' @aliases getCellBase
#' @param object an object of class CellBaseR
#' @param category character to specify the category to be queried.
#' @param subcategory character to specify the subcategory to be queried
#' @param ids a character vector of the ids to be queried
#' @param resource a character to specify the resource to be queried
#' @param param an object of class CellBaseParam specifying additional param
#'  for the CellBaseR
#' @return a dataframe holding the results of the query
#' @examples
#'    cb <- CellBaseR()
#'    res <- getCellBase(object=cb, category="feature", subcategory="gene", 
#'    ids="TET1", resource="info")
#' @seealso  \url{https://github.com/opencb/cellbase/wiki} 
#' and the RESTful API documentation 
#' \url{http://bioinfo.hpc.cam.ac.uk/cellbase/webservices/}
#' @export
setMethod("getCellBase", "CellBaseR", definition = function(object, category, 
                                                      subcategory, ids, resource
                                                      ,param=NULL) {
  categ <- category
  subcateg<- subcategory
  ids <- ids
  resource <- resource
  if (!is.null(param)) {
    param <- c(assembly=param@assembly,feature=param@feature,region=param@region
              ,rsid=param@rsid,so=param@so, trait=param@trait,
               accession=param@accession, type=param@type,
               mode_inheritance_labels=param@mode_inheritance_labels,
               clinsig_labels=param@clinsig_labels, 
              alleleOrigin=param@alleleOrigin, 
               consistency_labels=param@consistency_labels,
              include=param@include, exclude=param@exclude,
              limit=param@limit)
    param <- paste(param, collapse = "&")
  }
  # TODO: param are not enabled
  result <- fetchCellbase(object=object, file=NULL, meta = NULL, categ=categ, 
                          subcateg=subcateg, ids=ids, resource=resource , 
                          param=param)
  
  return(result)
})
