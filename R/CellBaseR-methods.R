### CellbaseR constructor function
#' @aliases CellBaseR
#' @title  CellBaseR
#' 
#' @description  This is a constructor function for CellBaseR object
#' @details
#' This class defines the CellBaseR object. It holds the default
#' configuration required by CellBaseR methods to connect to the
#' cellbase web services. By defult it is configured to query human
#' data based on the GRCh37 genome assembly. Please, visit
#' https://github.com/opencb/cellbase/wiki and
#' bioinfodev.hpc.cam.ac.uk/cellbase/webservices/ for more details on
#' following parameters.
#' @import methods
#' @param  host A character the default host url for cellbase webservices,
#' e.g. "http://bioinfo.hpc.cam.ac.uk/cellbase/webservices/rest/"
#' @param  version A character the cellbae API version, e.g. "V4"
#' @param  species a character specifying the species to be queried, e.g. 
#' "hsapiens"
#' @param  batch_size intger if multiple queries are raised by a single method 
#' call, e.g. getting annotation info for several genes, queries will be sent 
#' to the server in batches.This slot indicates the size of each batch,e.g. 200
#' @param num_threads integer number of  batches to be sent to the server
#' @param api the CellBase api 
#' @param tags available CellBase categories
#' @return An object of class CellBaseR
#' @examples
#'    cb <- CellBaseR()
#'    print(cb)
#' @export
CellBaseR <- function(host=NULL, version=NULL, species=NULL, 
                      batch_size=NULL, num_threads=NULL, api=NULL, tags=NULL ){
    if(!is.null(host)){
      host <- paste0(host, "/")
    }else {
      host <-"http://bioinfo.hpc.cam.ac.uk/cellbase/webservices/rest/"
    }
  available_species=c("hsapiens","mmusculus","drerio","rnorvegicus",
                      "ptroglodytes","ggorilla","pabelii","mmulatta",
                      "csabaeus","sscrofa","cfamiliaris","ecaballus",
                      "ocuniculus","ggallus","btaurus","fcatus",
                      "cintestinalis","oaries","olatipes","ttruncatus",
                      "lafricana","cjacchus","nleucogenys","aplatyrhynchos",
                      "falbicollis","celegans","dmelanogaster","dsimulans",
                      "dyakuba","agambiae","adarlingi","nvectensis",
                      "spurpuratus","bmori","aaegypti","apisum","scerevisiae"
                      ,"spombe","afumigatus","aniger","anidulans","aoryzae",
                      "foxysporum","pgraminis","ptriticina","moryzae",
                      "umaydis","ssclerotiorum","cneoformans","ztritici",
                      "pfalciparum","lmajor","ddiscoideum","glamblia",
                      "pultimum","alaibachii","athaliana","alyrata",
                      "bdistachyon","osativa","gmax","vvinifera","zmays",
                      "hvulgare","macuminata","sbicolor","sitalica",
                      "taestivum","brapa","ptrichocarpa","slycopersicum",
                      "stuberosum","smoellendorffii","creinhardtii",
                      "cmerolae")
  if(!is.null(species)){
      if(species%in% available_species){
        species<-species
      } else{
      stop("please enter a valid species name\n
           see ?getMeta examples to see the aviable species")
            } 
    }else{
      species <- 'hsapiens'
    }
  
    if(!is.null(version)){
      version <- paste0(version,"/")
    }else{
      version <- "v4/"
    }
  
   if(!is.null(batch_size)){
     batch_size <- batch_size
   }else{
     batch_size <- 200L
   }
  
   if(!is.null(num_threads)){
     num_threads <- num_threads
   }else{
     num_threads <- 8L
   }
  # Get the API list
  cbDocsUrl <- paste0(host, "swagger.json")
  Datp <- fromJSON(cbDocsUrl)
  tags <- Datp$tags
  paths <- Datp$paths
  api <- lapply(paths, function(x)x$get)
  
    new("CellBaseR", host=host, version=version,species=species,
        batch_size=batch_size, num_threads=num_threads, api=api, tags=tags )
}
