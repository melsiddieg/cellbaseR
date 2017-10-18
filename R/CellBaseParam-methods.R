#' A Constructor for the CellBaseParam Object
#' 
#'CellBaseParam object is used to control what results are returned from the
#'CellBaseR methods
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
#' @slot consistency_labels A character vector
#' @slot so A character vector denoting sequence ontology to be queried
#' @slot source A character vector
#' @slot trait A character vector denoting the trait to be queried
#' @slot include A character vector denoting the fields to be returned
#' @slot exclude A character vector denoting the fields to be excluded
#' @slot limit A number limiting the number of results to be returned
#' @return an object of class CellBaseParam
#' @examples
#' cbParam <- CellBaseParam(assembly="GRCh38",feature=c("TP73","TET1"))
#' print(cbParam)
#' @seealso  \url{https://github.com/opencb/cellbase/wiki} 
#' and the RESTful API documentation 
#' \url{http://bioinfo.hpc.cam.ac.uk/cellbase/webservices/}
#' @export
CellBaseParam <- function(assembly=character(), feature=character(),
region=character(), rsid=character(), accession=character(),
type=character(), mode_inheritance_labels=character(),
clinsig_labels=character(), alleleOrigin=character(), 
consistency_labels=character(), so=character(), trait=character(),
include=character(), exclude=character(), limit=character()){

    if(length(assembly)>0){
        assembly <- paste0(assembly,collapse = ",")
        assembly <- paste("assembly=",assembly,sep = "")
    }else{
        assembly <- character()
    }
    if(length(feature)>0){
        feature <- paste0(feature,collapse = ",")
        feature <- paste("feature=",feature,sep = "")
    }else{
        feature <- character()
    }

    if(length(region)>0){
        region <- paste0(region,collapse = ",")
        region <- paste("region=",region,sep = "")
    }else{
        region <-character()
    }

    if(length(rsid)>0){
        rsid <- paste0(rs,collapse = ",")
        rsid <- paste("id=",rs,sep = "")
    }else{
        rsid <- character()
    }
  if(length(accession)>0){
    accession <- paste0(accession,collapse = ",")
    accession <- paste("accession=",accession,sep = "")
  }else{
    accession <- character()
  }
  
  if(length(type)>0){
    type <- paste0(type,collapse = ",")
    type <- paste("type=",type,sep = "")
  }else{
    type <- character()
  }
  
  if(length(mode_inheritance_labels)>0){
    mode_inheritance_labels <- paste0(mode_inheritance_labels,collapse = ",")
    mode_inheritance_labels <- paste("mode_inheritance_labels=",mode_inheritance_labels,sep = "")
  }else{
    mode_inheritance_labels <- character()
  }
  
  if(length(clinsig_labels)>0){
    clinsig_labels <- paste0(clinsig_labels,collapse = ",")
    clinsig_labels <- paste("clinsig_labels=",clinsig_labels,sep = "")
  }else{
    clinsig_labels <- character()
  }
  if(length(alleleOrigin)>0){
    alleleOrigin <- paste0(alleleOrigin,collapse = ",")
    alleleOrigin <- paste("alleleOrigin=",alleleOrigin,sep = "")
  }else{
    alleleOrigin <- character()
  }
  if(length(consistency_labels)>0){
    consistency_labels <- paste0(consistency_labels,collapse = ",")
    consistency_labels <- paste("consistency_labels=",consistency_labels,sep = "")
  }else{
    consistency_labels <- character()
  }

    if(length(so)>0){
        so <- paste0(so,collapse = ",")
        so <- paste("so=",so,sep = "")
    }else{
        so <- character()
    }

    if(length(trait)>0){
        trait <- paste0(trait,collapse = ",")
        trait <- paste("trait=",trait,sep = "")
    }else{
        trait <- character()
    }

    if(length(include)>0){
        include <- paste0(include,collapse = ",")
        include <- paste("include=",include,sep = "")
    }else{
        include <- character()
    }

    if(length(exclude)>0){
        exclude <- paste0(exclude,collapse = ",")
        exclude <- paste("exclude=",exclude,sep = "")
    }else{
        exclude <- character()
    }
    if(length(limit)>0){
        limit=limit
        limit=paste("limit=", limit, sep="")
    }else{
        limit=paste("limit=", 1000, sep="")
    }

    new("CellBaseParam", assembly=assembly, feature=feature, region=region, 
        rsid=rsid, accession=accession,  type=type, 
        mode_inheritance_labels=mode_inheritance_labels,
        clinsig_labels=clinsig_labels, alleleOrigin=alleleOrigin,
        consistency_labels=consistency_labels, so=so,
        trait=trait, include=include, exclude=exclude, limit=limit)

}
