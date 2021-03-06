% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/user.R
\name{getClinicalByRegion}
\alias{getClinicalByRegion}
\title{getClinicalByRegion}
\usage{
getClinicalByRegion(object, id, param = NULL)
}
\arguments{
\item{object}{an object of class CellBaseR}

\item{id}{a charcter vector of genomic regions, eg 17:1000000-1100000}

\item{param}{an object of class CellBaseParam}
}
\value{
a dataframe of the query result
}
\description{
A convienice method to fetch clinical variants for specific region/s
}
\examples{
cb <- CellBaseR()
res <- getClinicalByRegion(cb, "17:1000000-1189811")
}
