% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot.R
\name{plotEmbeddings}
\alias{plotEmbeddings}
\title{Plot panel of specified embeddings}
\usage{
plotEmbeddings(embeddings, groups = NULL, colors = NULL, ncol = NULL,
  nrow = NULL, raster = FALSE, panel.size = NULL,
  adjust.func = NULL, title.size = 6, raster.width = NULL,
  raster.height = NULL, ...)
}
\arguments{
\item{embeddings}{list of two-column matrices with (x, y) coordinates of the embeddings. Each mutrix must have cell names in rownames.}

\item{groups}{vector of cluster labels, names contain cell names}

\item{colors}{vector of numbers, which must be shouwn with point colors, names contain cell names. This argument is ignored if groups are provided.}

\item{ncol}{number of columns in the panel}

\item{nrow}{number of rows in the panel}

\item{raster}{should layer with the points be rasterized (TRUE/ FALSE)? Setting of this argument to TRUE is useful when you need to export a plot with large number of points}

\item{panel.size}{vector with two numbers, which specified (width, height) of the panel in inches. Ignored if raster == FALSE.}

\item{adjust.func}{function to adjust plots before combining them to single panel. Can be used, for example, to provide color pallette of guides of the plots.}

\item{raster.width}{width of the plot in inches. Ignored if raster == FALSE.}

\item{raster.height}{height of the plot in inches. Ignored if raster == FALSE.}
}
\value{
ggplot2 object with the panel of plots
}
\description{
Plot panel of specified embeddings
}
