################################################################################
#' CellBaseR Class
#' @include commons.R
#' 
#' @description This is an S4 class  which defines the CellBaseR object
#' @details This S4 class holds the default configuration required by CellBaseR 
#' methods to connect to the cellbase web 
#' services. By default it is configured to query human data based on the GRCh37
#' assembly assembly. 
#' @slot host a character specifying the host url. Default 
#' "http://bioinfo.hpc.cam.ac.uk/cellbase/webservices/rest/"
#' @slot version a character specifying the API version. Default "v4"
#' @slot species a character specifying the species to be queried. Default
#'  "hsapiens"
#' @slot batch_size if multiple queries are raised by a single method call, e.g.
#'  getting annotation info for several features,
#' queries will be sent to the server in batches. This slot indicates the size 
#' of these batches. Default 200
#' @slot num_threads the number of threads. Default 8
#' @seealso  \url{https://github.com/opencb/cellbase/wiki} 
#' and the RESTful API documentation 
#' \url{http://bioinfo.hpc.cam.ac.uk/cellbase/webservices/}
#' @export
setClass("CellBaseR", 
    slots = c(host="character", version="character", species="character", 
              batch_size="numeric", num_threads="numeric"),
    prototype = prototype(
    host="http://bioinfo.hpc.cam.ac.uk/cellbase/webservices/webservices/rest/",
    version = "v4/",species="hsapiens/", batch_size=200L, num_threads=8L)
)


###############################################################################
#' CellBaseParam Class
#' 
#' @description  This class  defines a CellBaseParam object to hold filtering 
#' parameters.
#' @details This class stores parameters used for filtering the CellBaseR query
#' and is avaialable for all query methods. CellBaseParam object is used to
#' control what results are returned from the' CellBaseR methods
#' @slot assembly A character the assembly build to query, e.g.GRCh37(default)
#' @slot feature A character vector denoting the feature/s to be queried
#' @slot region A character vector denoting the region/s to be queried must be 
#' in the form 1:100000-1500000
#' @slot rsid A character vector denoting the rs ids to be queried
#' @slot accession A caharcter vector of Cinvar accessions
#' @slot type A caharcter vector of Variant types
#' @slot mode_inheritance_labels A character vector
#' @slot clinsig_labels A character vector
#' @slot alleleOrigin A character vector
#' @slot so A character vector denoting sequence ontology to be queried
#' @slot source A character vector
#' @slot trait A character vector denoting the trait to be queried
#' @slot include A character vector denoting the fields to be returned
#' @slot exclude A character vector denoting the fields to be excluded
#' @slot limit A number limiting the number of results to be returned
#' @seealso  \url{https://github.com/opencb/cellbase/wiki} 
#' and the RESTful API documentation 
#' \url{http://bioinfo.hpc.cam.ac.uk/cellbase/webservices/}
#' @export
setClass("CellBaseParam",
         slots = c(assembly="character", feature="character", 
                  region="character", rsid="character", so="character", 
                  trait="character", accession="character", type="character",
                  source="character", mode_inheritance_labels="character",
                  clinsig_labels="character", alleleOrigin="character", 
                  include ="character", exclude = "character",
                  limit="character"), 
         
                  prototype = prototype(assembly=character(0),
                  feature=character(0), region=character(0), rsid=character(0), 
                  so=character(0), trait=character(0), accession=character(0),
                  source=character(0), mode_inheritance_labels=character(0),
                  clinsig_labels=character(0), alleleOrigin=character(0),
                  include=character(0), exclude=character(0),limit="1000"))
