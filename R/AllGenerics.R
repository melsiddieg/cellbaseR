# CellBaseR methods
#'@include commons.R
################################################################################
################################################################################
setGeneric("cbClinicalClient", function(object, filters,...)
standardGeneric("cbClinicalClient"))


setGeneric("cbGeneClient", function(object,ids,resource,filters=NULL, ...)
standardGeneric("cbGeneClient"))

################################################################################

################################################################################
setGeneric("cbRegionClient", function(object,ids,resource,filters, ...)
standardGeneric("cbRegionClient"))

################################################################################

################################################################################
setGeneric("cbSnpClient", function(object,ids,resource,filters=NULL, ...)
standardGeneric("cbSnpClient"))

################################################################################

########################################################################################################################
setGeneric("cbVariantClient", function(object,ids,resource,filters=NULL, ...)
standardGeneric("cbVariantClient"))

########################################################################################################################

setGeneric("cbGet", function(object, category, subcategory, ids, resource, filters=NULL,...)
standardGeneric("cbGet"))

########################################################################################################################

########################################################################################################################
setGeneric("cbTfbsClient", function(object,ids,resource,filters=NULL, ...)
standardGeneric("cbTfbsClient"))

########################################################################################################################

########################################################################################################################
setGeneric("cbTranscriptClient", function(object,ids,resource,filters=NULL, ...)
standardGeneric("cbTranscriptClient"))

########################################################################################################################

########################################################################################################################
setGeneric("cbXrefClient", function(object,ids,resource,filters=NULL, ...)
standardGeneric("cbXrefClient"))

########################################################################################################################

########################################################################################################################
setGeneric("cbProteinClient", function(object,ids,resource,filters=NULL, ...)
standardGeneric("cbProteinClient"))

########################################################################################################################
################################################################################
setGeneric("cbChromosomeInfoClient", function(object,ids,resource,filters=NULL, ...)
standardGeneric("cbChromosomeInfoClient"))

################################################################################

setGeneric("cbMetaClient", function(object, resource) 
standardGeneric("cbMetaClient"))

################################################################################
setGeneric("cbAnnotateVcf", function(object, file, ...)
standardGeneric("cbAnnotateVcf"))




