# CellBaseR methods
#'@include commons.R
###############################################################################
###############################################################################
setGeneric("getClinical", function(object, filters,...)
standardGeneric("getClinical"))


setGeneric("getGene", function(object,ids,resource,filters=NULL, ...)
standardGeneric("getGene"))

###############################################################################

###############################################################################
setGeneric("getRegion", function(object,ids,resource,filters=NULL, ...)
standardGeneric("getRegion"))

###############################################################################

###############################################################################
setGeneric("getSnp", function(object,ids,resource,filters=NULL, ...)
standardGeneric("getSnp"))

###############################################################################

###############################################################################
setGeneric("getVariant", function(object,ids,resource,filters=NULL, ...)
standardGeneric("getVariant"))

###############################################################################

setGeneric("getCellBase", function(object, category, subcategory, ids, resource,
                                   filters=NULL,...)
standardGeneric("getCellBase"))

###############################################################################

###############################################################################
setGeneric("getTfbs", function(object,ids,resource,filters=NULL, ...)
standardGeneric("getTfbs"))

###############################################################################

###############################################################################
setGeneric("getTranscript", function(object,ids,resource,filters=NULL, ...)
standardGeneric("getTranscript"))

##############################################################################

##############################################################################
setGeneric("getXref", function(object,ids,resource,filters=NULL, ...)
standardGeneric("getXref"))

##############################################################################

##############################################################################
setGeneric("getProtein", function(object,ids,resource,filters=NULL, ...)
standardGeneric("getProtein"))

###############################################################################
###############################################################################
setGeneric("getChromosomeInfo", function(object,ids,resource,filters=NULL, ...)
standardGeneric("getChromosomeInfo"))

###############################################################################

setGeneric("getMeta", function(object, resource) 
standardGeneric("getMeta"))

###############################################################################
setGeneric("AnnotateVcf", function(object, file, ...)
standardGeneric("AnnotateVcf"))




