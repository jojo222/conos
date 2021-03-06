% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/conclass.r
\docType{class}
\name{Conos-class}
\alias{Conos-class}
\alias{Conos}
\title{Conos reference class}
\description{
Conos reference class
}
\details{
The class encompasses sample collections, providing methods for calculating and visualizing joint graph and communities.
}
\section{Methods}{

\describe{
\item{\code{correctGenes(genes = NULL, n.od.genes = 500, fading = 10,
  fading.const = 0.5, max.iters = 15, tol = 0.005, name = "diffusion",
  verbose = TRUE, count.matrix = NULL, normalize = TRUE)}}{Smooth expression of genes, so they better represent structure of the graph.

       Use diffusion of expression on graph with the equation dv = exp(-a * (v + b))

       Params:

       - genes: list of genes for smoothing

       - n.od.genes: if 'genes' is NULL, top n.od.genes of overdispersed genes are taken across all samples. Default: 500.

       - fading: level of fading of expression change from distance on the graph (parameter 'a' of the equation). Default: 10.

       - fading.const: minimal penalty for each new edge during diffusion (parameter 'b' of the equation). Default: 0.5.

       - max.iters: maximal number of diffusion iterations. Default: 15.

       - tol: tolerance after which the diffusion stops. Default: 5e-3.

       - name: name to save the correction. Default: diffusion.

       - verbose: verbose mode. Default: TRUE.
       - count.matrix: alternative gene count matrix to correct. Default: joint count matrix for all datasets.
      }

\item{\code{propagateLabels(labels, max.iters = 50, method = 2, diffusion.fading = 10,
  diffusion.fading.const = 0.5, tol = 0.005, return.distribution = TRUE,
  verbose = TRUE)}}{Estimate labeling distribution for each vertex, based on provided labels.

     Params:

     - labels: vector of factor or character labels, named by cell names

     - max.iters: maximal number of iterations. Default: 50.

     - return.distribution: return distribution of labeling, but not single label for each vertex. Default: TRUE.

     - verbose: verbose mode. Default: TRUE.

     

     Return: matrix with distribution of label probabilities for each vertex by rows.
    }
}}

