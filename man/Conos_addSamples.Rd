% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/conclass.r
\name{Conos_addSamples}
\alias{Conos_addSamples}
\title{initialize or add a set of samples to the conos panel}
\arguments{
\item{x}{a named list of pagoda2 objects (one per sample)}

\item{replace}{whether the existing samples should be purged before adding new ones}
}
\value{
invisible view of the full sample list
}
\description{
note: this will simply add samples, but will not update graph, clustering, etc.
}
