% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/user.R
\name{getClinicalByGene}
\alias{getClinicalByGene}
\title{getClinicalByGene}
\usage{
getClinicalByGene(object, id, param = NULL)
}
\arguments{
\item{object}{an object of CellBaseR class}

\item{id}{a charcter vector of HUGO symbol (gene names)}

\item{param}{an object of class CellBaseParam}
}
\value{
a dataframe of the query result
}
\description{
A convienice method to fetch clinical variants for specific gene/s
}
\examples{
cb <- CellBaseR()
res <- getClinicalByGene(cb, "TET1")
}
