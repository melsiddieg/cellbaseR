% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/user.R
\name{getVariantAnnotation}
\alias{getVariantAnnotation}
\title{getVariantAnnotation}
\usage{
getVariantAnnotation(object, id, param = NULL)
}
\arguments{
\item{object}{an object of class CellBaseR}

\item{id}{a charcter vector of length < 200 of genomic variants,
eg 19:45411941:T:C}

\item{param}{an object of class CellBaseParam}
}
\value{
a dataframe of the query result
}
\description{
A convienice method to fetch variant annotation for specific variant/s
}
\examples{
cb <- CellBaseR()
res <- getVariantAnnotation(cb, "19:45411941:T:C")
}
