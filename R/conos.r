#' @useDynLib conos
#' @import Matrix
#' @import igraph
#' @importFrom parallel mclapply
NULL

scaledMatricesP2 <- function(p2.objs, data.type, od.genes, var.scale, neighborhood.average) {
  ## Common variance scaling
  if (var.scale) {
    cgsf <- do.call(cbind, lapply(p2.objs,function(x) x$misc$varinfo[od.genes,]$gsf)) %>%  log() %>% rowMeans() %>% exp()
    #cgsf <- do.call(cbind, lapply(p2.objs,function(x) x$misc$varinfo[od.genes,]$gsf)) %>% rowMeans()
  }
  ## Prepare the matrices
  cproj <- lapply(p2.objs,function(r) {
    if (data.type == 'counts') {
      x <- r$counts[,od.genes];
    } else if (data.type %in% names(r$reductions)){
      if (!all(od.genes %in% colnames(r$reductions[[data.type]]))) {
        stop("Reduction '", data.type, "' should have columns indexed by gene, with all overdispersed genes presented")
      }
      x <- r$reductions[[data.type]][,od.genes];
    } else {
      stop("No reduction named '", data.type, "' in pagoda")
    }

    if(var.scale) {
      # x@x <- x@x*rep(r$misc$varinfo[od.genes,]$gsf,diff(x@p))
      x@x <- x@x*rep(cgsf,diff(x@p))
    }
    if(neighborhood.average) {
      ## use the averaged matrices
      x <- Matrix::t(edgeMat(r)$mat) %*% x
    }
    x
  })

  return(cproj)
}

scaledMatricesSeurat <- function(so.objs, data.type, od.genes, var.scale, neighborhood.average) {
  if (var.scale) {
    warning("Seurat doesn't support variance scaling")
  }

  if (data.type == 'scaled') {
    x.data <- lapply(so.objs, function(so) t(so@scale.data)[,od.genes])
  } else if (data.type == 'counts') {
    x.data <- lapply(so.objs, function(so) t(so@data)[,od.genes])
  } else {
    stop("Unknown data type for Seurat: ", data.type)
  }

  res <- mapply(function(so, x) if(neighborhood.average) Matrix::t(edgeMat(so)$mat) %*% x else x,
                so.objs, x.data)

  return(res)
}

scaledMatrices <- function(samples, data.type, od.genes, var.scale, neighborhood.average) {
  if (class(samples[[1]]) == "Pagoda2")
    return(scaledMatricesP2(samples, data.type=data.type, od.genes, var.scale, neighborhood.average))

  if (class(samples[[1]]) == "seurat")
    return(scaledMatricesSeurat(samples, data.type=data.type, od.genes, var.scale, neighborhood.average))

  stop("Unknown class of sample: ", class(samples[[1]]))
}

commonOverdispersedGenes <- function(samples, n.odgenes, verbose) {
  od.genes <- sort(table(unlist(lapply(samples, getOverdispersedGenes, n.odgenes))),decreasing=T)
  od.genes <- od.genes[names(od.genes) %in% Reduce(intersect, lapply(samples, getGenes))]

  if(verbose) cat("using",length(od.genes),"od genes\n")

  return(names(od.genes)[1:min(length(od.genes),n.odgenes)])
}

quickNULL <- function(p2.objs, data.type='counts', n.odgenes = NULL, var.scale = T,
                      verbose = TRUE, neighborhood.average=FALSE) {
  if(length(p2.objs) != 2) stop('quickNULL only supports pairwise alignment');

  od.genes <- commonOverdispersedGenes(p2.objs, n.odgenes, verbose=verbose)
  cproj <- scaledMatrices(p2.objs, data.type=data.type, od.genes=od.genes, var.scale=var.scale,
                          neighborhood.average=neighborhood.average)

  return(list(genespace1=cproj[[1]], genespace2=cproj[[2]]))
}

#' Perform pairwise JNMF
quickJNMF <- function(p2.objs, data.type='counts', n.comps = 30, n.odgenes=NULL, var.scale=TRUE,
                      verbose =TRUE, max.iter=1000, neighborhood.average=FALSE) {
  ## Stop if more than 2 samples
  if (length(p2.objs) != 2) stop('quickJNMF only supports pairwise alignment');

  od.genes <- commonOverdispersedGenes(p2.objs, n.odgenes, verbose=verbose)

  cproj <- scaledMatrices(p2.objs, data.type=data.type, od.genes=od.genes, var.scale=var.scale,
                          neighborhood.average=neighborhood.average) %>%
    lapply(as.matrix)

  rjnmf.seed <- 12345
  ## Do JNMF
  z <- Rjnmf::Rjnmf(Xs=t(cproj[[1]]), Xu=t(cproj[[2]]), k=n.comps, alpha=0.5, lambda = 0.5, epsilon = 0.001,
                    maxiter= max.iter, verbose=F, seed=rjnmf.seed)
  rot1 <- cproj[[1]] %*% z$W
  rot2 <- cproj[[2]] %*% z$W
  ## return
  list(rot1=rot1, rot2=rot2,z=z)
}

cpcaFast <- function(covl,ncells,ncomp=10,maxit=1000,tol=1e-6,use.irlba=TRUE,verbose=F) {
  ncomp <- min(c(nrow(covl)-1,ncol(covl)-1,ncomp));
  if(use.irlba) {
    # irlba initialization
    p <- nrow(covl[[1]]);
    S <- matrix(0, nrow = p, ncol = p)
    for(i in 1:length(covl)) {
      S <- S + (ncells[i] / sum(ncells)) * covl[[i]]
    }
    ncomp <- min(c(nrow(S)-1,ncol(S)-1,ncomp));
    ev <- irlba::irlba(S, ncomp, maxit=10000)
    cc <- abind::abind(covl,along=3)
    cpcaF(cc,ncells,ncomp,maxit,tol,eigenvR=ev$v,verbose)
  } else {
    cpcaF(cc,ncells,ncomp,maxit,tol,verbose=verbose)
  }
}


#' Perform cpca on two samples
#' @param r.n list of p2 objects
#' @param k neighborhood size to use
#' @param ncomps number of components to calculate (default=100)
#' @param n.odgenes number of overdispersed genes to take from each dataset
#' @param var.scale whether to scale variance (default=TRUE)
#' @param verbose whether to be verbose
#' @param neighborhood.average use neighborhood average values
#' @param n.cores number of cores to use
quickCPCA <- function(r.n,data.type='counts',k=30,ncomps=100,n.odgenes=NULL,var.scale=TRUE,verbose=TRUE,neighborhood.average=FALSE) {
  od.genes <- commonOverdispersedGenes(r.n, n.odgenes, verbose=verbose)

  ncomps <- min(ncomps, length(od.genes) - 1)

  if(verbose) cat('calculating covariances for',length(r.n),' datasets ...')

  ## # use internal C++ implementation
  ## sparse.cov <- function(x,cMeans=NULL){
  ##   if(is.null(cMeans)) {  cMeans <- Matrix::colMeans(x) }
  ##   covmat <- spcov(x,cMeans);
  ## }

  covl <- scaledMatrices(r.n, data.type=data.type, od.genes=od.genes, var.scale=var.scale,
                         neighborhood.average=neighborhood.average) %>%
    lapply(function(x) spcov(as(x, "dgCMatrix"), Matrix::colMeans(x)))

  ## # centering
  ## if(common.centering) {
  ##   ncells <- unlist(lapply(covl,nrow));
  ##   centering <- colSums(do.call(rbind,lapply(covl,colMeans))*ncells)/sum(ncells)
  ## } else {
  ##   centering <- NULL;
  ## }

  ## covl <- lapply(covl,sparse.cov,cMeans=centering)

  if(verbose) cat(' done\n')

  #W: get counts
  ncells <- unlist(lapply(r.n,function(x) length(getCellNames(x))));
  if(verbose) cat('common PCs ...')
  #xcp <- cpca(covl,ncells,ncomp=ncomps)
  xcp <- cpcaFast(covl,ncells,ncomp=ncomps,verbose=verbose,maxit=500,tol=1e-5);
  #system.time(xcp <- cpca:::cpca_stepwise_base(covl,ncells,k=ncomps))
  #xcp <- cpc(abind(covl,along=3),k=ncomps)
  rownames(xcp$CPC) <- od.genes;
  #xcp$rot <- xcp$CPC*cgsf;
  if(verbose) cat(' done\n')
  return(xcp);
}


#' Use space of combined sample-specific PCAs as a space
#' @param r.n list of p2 objects
#' @param k neighborhood size to use
#' @param ncomps number of components to calculate (default=30)
#' @param n.odgenes number of overdispersed genes to take from each dataset
#' @param var.scale whether to scale variance (default=TRUE)
#' @param verbose whether to be verbose
#' @param cgsf an optional set of common genes to align on
#' @param neighborhood.average use neighborhood average values
#' @param n.cores number of cores to use
quickPlainPCA <- function(r.n,data.type='counts',k=30,ncomps=30,n.odgenes=NULL,var.scale=TRUE,verbose=TRUE,neighborhood.average=FALSE,n.cores=30) {
  od.genes <- commonOverdispersedGenes(r.n, n.odgenes, verbose=verbose)

  if(verbose) cat('calculating PCs for',length(r.n),' datasets ...')

  pcs <- scaledMatrices(r.n, data.type=data.type, od.genes=od.genes, var.scale=var.scale, neighborhood.average=neighborhood.average) %>%
    lapply(function(x) {
      cm <- Matrix::colMeans(x);
      ncomps <- min(c(nrow(cm)-1,ncol(cm)-1,ncomps));
      pcs <- irlba::irlba(x, nv=ncomps, nu =0, center=cm, right_only = F, reorth = T);
      #rownames(pcs$v) <- colnames(x);
      pcs$v
    })

  pcs <- do.call(cbind,pcs)
  rownames(pcs) <- od.genes;

  if(verbose) cat(' done\n')

  return(list(CPC=pcs));
}


# dendrogram modification functions
#' Set dendrogram node width by breadth of the provided factor
#' @param d dendrogram
#' @param fac across cells
#' @param leafContent $leafContent output of greedy.modularity.cut() providing information about which cells map to which dendrogram leafs
#' @param min.width minimum line width
#' @param max.width maximum line width
#' @export
dend.set.width.by.breadth <- function(d,fac,leafContent,min.width=1,max.width=4) {
  cc2width <- function(cc) {
    ent <- entropy::entropy(cc[-1],method='MM',unit='log2')/log2(length(levels(fac)))
    min.width+ent*(max.width-min.width)
  }
  
  cbm <- function(d,fac) {
    if(is.leaf(d)) {
      lc <- fac[leafContent[[attr(d,'label')]]]
      cc <- c(sum(is.na(lc)),table(lc));
      lwd <- cc2width(cc)
      attr(d,"edgePar") <- c(attr(d,"edgePar"),list(lwd=lwd))
      attr(d,'cc') <- cc;
      return(d);
    } else {
      oa <- attributes(d);
      d <- lapply(d,cbm,fac=fac);
      attributes(d) <- oa;
      cc <- attr(d[[1]],'cc')+attr(d[[2]],'cc')
      lwd <- cc2width(cc)
      attr(d,"edgePar") <- c(attr(d,"edgePar"),list(lwd=lwd))
      attr(d,'cc') <- cc;
      return(d);
    }
  }
  cbm(d,fac);
}

#' Set dendrogram colors according to a 2- or 3-level factor mixture
#' @param d dendrogram
#' @param fac across cells
#' @param leafContent $leafContent output of greedy.modularity.cut() providing information about which cells map to which dendrogram leafs
#' @export
dend.set.color.by.mixture <- function(d,fac,leafContent) {
  fac <- as.factor(fac);
  if(length(levels(fac))>3) stop("factor with more than 3 levels are not supported")
  if(length(levels(fac))<2) stop("factor with less than 2 levels are not supported")
  
  cc2col <- function(cc,base=0.1) {
    if(sum(cc)==0) {
      cc <- rep(1,length(cc))
    } else {
      cc <- cc/sum(cc)
    }
    
    if(length(cc)==3) { # 2-color
      cv <- c(cc[2],0,cc[3])+base; cv <- cv/max(cv) * (1-base)
      #rgb(base+cc[2],base,base+cc[3],1)
      rgb(cv[1],cv[2],cv[3],1)
    } else if(length(cc)==4) { # 3-color
      cv <- c(cc[2],cc[3],cc[4])+base; cv <- cv/max(cv) * (1-base);
      #rgb(base+cc[2],base+cc[3],base+cc[4],1)
      rgb(cv[1],cv[2],cv[3],1)
      
    }
  }
  
  cbm <- function(d,fac) {
    if(is.leaf(d)) {
      lc <- fac[leafContent[[attr(d,'label')]]]
      cc <- c(sum(is.na(lc)),table(lc));
      col <- cc2col(cc)
      attr(d,"edgePar") <- c(attr(d,"edgePar"),list(col=col))
      attr(d,'cc') <- cc;
      return(d);
    } else {
      oa <- attributes(d);
      d <- lapply(d,cbm,fac=fac);
      attributes(d) <- oa;
      cc <- attr(d[[1]],'cc')+attr(d[[2]],'cc')
      col <- cc2col(cc)
      attr(d,"edgePar") <- c(attr(d,"edgePar"),list(col=col))
      attr(d,'cc') <- cc;
      return(d);
    }
  }
  cbm(d,fac);
}

# other functions

# use mclapply if available, fall back on BiocParallel, but use regular
# lapply() when only one core is specified
papply <- function(...,n.cores=parallel::detectCores(), mc.preschedule=FALSE) {
  if(n.cores>1) {
    if(requireNamespace("parallel", quietly = TRUE)) {
      res <- mclapply(...,mc.cores=n.cores,mc.preschedule=mc.preschedule)
    }
    else if(requireNamespace("BiocParallel", quietly = TRUE)) {
      # It should never happen because parallel is specified in Imports
      res <- BiocParallel::bplapply(... , BPPARAM = BiocParallel::MulticoreParam(workers = n.cores))
    }
  } else {
    # fall back on lapply
    res <- lapply(...)
  }

  is.error <- (sapply(res, class) == "try-error")
  if (any(is.error)) {
    stop(paste("Errors in papply:", res[is.error]))
  }

  return(res)
}

##################################
## Benchmarks
##################################

#' Get % of clusters that are private to one sample
#' @param p2list list of pagoda2 objects on which the panelClust() was run
#' @param pjc result of panelClust()
#' @param priv.cutoff percent of total cells of a cluster that have to come from a single cluster
#' for it to be called private
getClusterPrivacy <- function(p2list, pjc, priv.cutoff= 0.99) {
    ## Get the clustering factor
    cl <- pjc$cls.mem
    ## Cell metadata
    meta <- do.call(rbind, lapply(names(p2list), function(n) {
        x <- p2list[[n]];
        data.frame(
            p2name = c(n),
            cellid = getCellNames(x)
        )
    }))
    ## get sample / cluster counts
    meta$cl <- cl[meta$cellid]
    cl.sample.counts <- reshape2::acast(meta, p2name ~ cl, fun.aggregate=length,value.var='cl')
    ## Get clusters that are sample private
    private.clusters <- names(which(apply(sweep(cl.sample.counts, 2, apply(cl.sample.counts,2,sum), FUN='/') > priv.cutoff,2,sum) > 0))
    ## percent clusters that are private
    length(private.clusters) / length(unique(cl))
}

sn <- function(x) { names(x) <- x; x }


#' Evaluate consistency of cluster relationships
#' @description Using the clustering we are generating per-sample dendrograms
#' and we are examining their similarity between different samples
#' More information about similarity measures
#' https://www.rdocumentation.org/packages/dendextend/versions/1.8.0/topics/cor_cophenetic
#' https://www.rdocumentation.org/packages/dendextend/versions/1.8.0/topics/cor_bakers_gamma
#' @param p2list list of pagoda2 object
#' @param pjc a clustering factor
#' @return list of cophenetic and bakers_gama similarities of the dendrograms from each sample
getClusterRelationshipConsistency <- function(p2list, pjc) {
    hcs <- lapply(sn(names(p2list)), function(n) {
        x <- p2list[[n]]
        app.cl <- pjc[names(pjc) %in% getCellNames(x)]
        cpm <- sweep(rowsum(as.matrix(x$misc$rawCounts),
                            app.cl[rownames(x$misc$rawCounts)]),1, table(app.cl), FUN='/') * 1e6
        as.dendrogram(hclust(as.dist( 1 - cor(t(cpm)))))
    })
    ## Compare all dendrograms pairwise
    cis <- combn(names(hcs), 2)
    dend.comp <- lapply(1:ncol(cis), function(i) {
        s1 <- cis[1,i]
        s2 <- cis[2,i]
        dl1 <- dendextend::intersect_trees(hcs[[s1]],hcs[[s2]])
        list(
            cophenetic=dendextend::cor_cophenetic(dl1[[1]],dl1[[2]]),
            bakers_gamma=dendextend::cor_bakers_gamma(dl1[[1]],dl1[[2]])
        )
    })
    ## return mean and sd
    list(
        mean.cophenetic = mean(unlist(lapply(dend.comp, function(x) {x$cophenetic}))),
        sd.cophenetic = sd(unlist(lapply(dend.comp, function(x) {x$cophenetic}))),
        mean.bakers_gamma = mean(unlist(lapply(dend.comp, function(x) {x$bakers_gamma}))),
        sd.bakers_gamma = sd(unlist(lapply(dend.comp, function(x) {x$bakers_gamma})))
    )
}


#' Evaluate how many clusters are global
#' @param p2list list of pagoda2 object on which clustering was generated
#' @param pjc the result of joint clustering
#' @param pc.samples.cutoff the percent of the number of the total samples that a cluster has to span to be considered global
#' @param min.cell.count.per.samples minimum number of cells of cluster in sample to be considered as represented in that sample
#' @return percent of clusters that are global given the above criteria
getPercentGlobalClusters <- function(p2list, pjc, pc.samples.cutoff = 0.9, min.cell.count.per.sample = 10) {
    ## get the cluster factor
    cl <- pjc$cls.mem
    ## get metadata table
    meta <- do.call(rbind, lapply(names(p2list), function(n) {
        x <- p2list[[n]];
        data.frame(
            p2name = c(n),
            cellid = getCellNames(x)
        )
    }))
    ## get sample / cluster counts
    meta$cl <- cl[meta$cellid]
    cl.sample.counts <- reshape2::acast(meta, p2name ~ cl, fun.aggregate=length,value.var='cl')
    ## which clusters are global
    global.cluster <- apply(cl.sample.counts > min.cell.count.per.sample, 2, sum) >=  ceiling(nrow(cl.sample.counts) * pc.samples.cutoff)
    ## pc global clusters
    sum(global.cluster) / length(global.cluster)
}



## helper function for breaking down a factor into a list
factorBreakdown <- function(f) {tapply(names(f),f, identity) }

#' Post process clusters generated with walktrap to control granularity
#' @param p2list list of pagoda2 objects
#' @param pjc joint clustering that was performed with walktrap
#' @param no.cl number of clusters to get from the walktrap dendrogram
#' @param size.cutoff cutoff below which to merge the clusters
#' @param n.cores number of cores to use
postProcessWalktrapClusters <- function(p2list, pjc, no.cl = 200, size.cutoff = 10, n.cores=4) {
    ##devel
    ## pjc <- pjc3
    ## no.cl <- 200
    ## size.cutoff <- 10
    ## n.cores <- 4
    ## rm(pjc, no.cl,size.cutoff, n.cores)
    ##
    global.cluster <- igraph::cut_at(cls, no=no.cl)
    names(global.cluster) <- names(igraph::membership(cls))
    ## identify clusters to merge
    fqs <- as.data.frame(table(global.cluster))
    cl.to.merge <- fqs[fqs$Freq < size.cutoff,]$global.cluster
    cl.to.keep <- fqs[fqs$Freq >= size.cutoff,]$global.cluster
    ## Memberships to keep
    global.cluster.filtered <- as.factor(global.cluster[global.cluster %in% cl.to.keep])
    ## Get new assignments for all the cells
    new.assign <- unlist(unname(parallel::mclapply(p2list, function(p2o) {
        try({
            ## get global cluster centroids for cells in this app
            global.cluster.filtered.bd <- factorBreakdown(global.cluster.filtered)

            # W: counts accessor
            global.cl.centers <- do.call(rbind, lapply(global.cluster.filtered.bd, function(cells) {
                cells <- cells[cells %in% getCellNames(p2o)]
                if (length(cells) > 1) {
                    Matrix::colSums(p2o$counts[cells,])
                } else {
                    NULL
                }
            }))
            ## cells to reassign in this app
            cells.reassign <- names(global.cluster[global.cluster %in% cl.to.merge])
            cells.reassign <- cells.reassign[cells.reassign %in% rownames(p2o$counts)]

            # W: counts accessor
            xcor <- cor(t(as.matrix(p2o$counts[cells.reassign,,drop=FALSE])), t(as.matrix(global.cl.centers)))
            ## Get new cluster assignments
            new.cluster.assign <- apply(xcor,1, function(x) {colnames(xcor)[which.max(x)]})
            new.cluster.assign
        })
    },mc.cores=n.cores)))
    ## Merge
    x <- as.character(global.cluster.filtered)
    names(x) <- names(global.cluster.filtered)
    new.clusters <- as.factor(c(x,new.assign))
    new.clusters
}

#' Get top overdispersed genes across samples
#' @param samples list of pagoda2 objects
#' @param n.genes number of overdispersed genes to extract
getOdGenesUniformly <- function(samples, n.genes) {
  gene.info <- lapply(samples, function(s)
    tibble::rownames_to_column(s$misc[['varinfo']], "gene") %>%
      dplyr::mutate(rank=rank(lpa, ties.method="first"))
  )
  genes <- gene.info %>% dplyr::bind_rows() %>% dplyr::group_by(gene) %>%
    dplyr::summarise(rank=min(rank)) %>% dplyr::arrange(rank) %>% .$gene

  return(genes[1:min(n.genes, length(genes))])
}



##' Find threshold of cluster detectability
##'
##' For a given clustering, walks the walktrap result tree to find
##' a subtree with max(min(sens,spec)) for each cluster, where sens is sensitivity, spec is specificity
##' @param res walktrap result object (igraph)
##' @param clusters cluster factor
##' @return a list of $thresholds - per cluster optimal detectability values, and $node - internal node id (merge row) where the optimum was found
##' @export
bestClusterThresholds <- function(res,clusters) {
  clusters <- as.factor(clusters);
  # prepare cluster vectors
  cl <- as.integer(clusters[res$names]);
  clT <- tabulate(cl,nbins=length(levels(clusters)))
  # run
  res$merges <- igraph:::complete.dend(res,FALSE)
  x <- findBestClusterThreshold(res$merges-1L,cl-1L,clT)
}



##' performs a greedy top-down selective cut to optmize modularity
##'
##' @param wt walktrap rsult
##' @param N number of top greedy splits to take
##' @param leaf.labels leaf sample label factor, for breadth calculations - must be a named factor containing all wt$names, or if wt$names is null, a factor listing cells in the same order as wt leafs
##' @param minsize minimum size of the branch (in number of leafs)
##' @param minbreadth minimum allowed breadth of a branch (measured as normalized entropy)
##' @param flat.cut whether to simply take a flat cut (i.e. follow provided tree; default=TRUE). Does no observe minsize/minbreadth restrictions
##' @return list(hclust - hclust structure of the derived tree, leafContent - binary matrix with rows corresponding to old leaves, columns to new ones, deltaM - modularity increments)
##' @export
greedy.modularity.cut <- function(wt,N,leaf.labels=NULL,minsize=0,minbreadth=0,flat.cut=TRUE) {
  # prepare labels
  nleafs <- nrow(wt$merges)+1;
  if(is.null(leaf.labels)) {
    ll <- integer(nleafs);
  } else {
    if(is.null(wt$names)) {
      # assume that leaf.labels are provided in the correct order
      if(length(leaf.labels)!=nleafs) stop("leaf.labels is of incorrct length and wt$names is NULL")
      ll <- as.integer(as.factor(leaf.labels))-1L;
    } else {
      if(!all(wt$names %in% names(leaf.labels))) { stop("leaf.labels do not cover all wt$names")}
      ll <- as.integer(as.factor(leaf.labels[wt$names]))-1L;
    }
  }
  x <- greedyModularityCut(wt$merges-1L,-1*diff(wt$modularity),N,minsize,ll,minbreadth,flat.cut)
  if(length(x$splitsequence)<1) { 
    stop("unable to make a single split using specified size/breadth restrictions")
  }
  # transfer cell names for the leaf content
  if(!is.null(wt$names)) { rownames(x$leafContent) <- wt$names; } else { rownames(x$leafContent) <- c(1:nrow(x$leafContent)) }
  m <- x$merges+1; nleafs <- nrow(m)+1; m[m<=nleafs] <- -1*m[m<=nleafs]; m[m>0] <- m[m>0]-nleafs;
  hc <- list(merge=m,height=1:nrow(m),labels=c(1:nleafs),order=c(1:nleafs)); class(hc) <- 'hclust'
  # fix the ordering so that edges don't intersects
  hc$order <- order.dendrogram(as.dendrogram(hc))
  leafContentCollapsed <- apply(x$leafContent,2,function(z)rownames(x$leafContent)[which(z>0)])
  clfac <- as.factor(apply(x$leafContent,1,which.max))
  return(list(hc=hc,groups=clfac,leafContentArray=x$leafContent,leafContent=leafContentCollapsed,deltaM=x$deltaM,breadth=as.vector(x$breadth),splits=x$splitsequence))
}

##' determine number of detectable clusters given a reference walktrap and a bunch of permuted walktraps
##'
##' @param refwt reference walktrap rsult
##' @param tests a list of permuted walktrap results
##' @param min.threshold min detectability threshold
##' @param min.size minimum cluster size (number of leafs)
##' @param average.thresholds report a single number of detectable clusters for averaged detected thresholds (a list of detected clusters for each element of the tests list is returned by default)
##' @return number of detectable stable clusters
##' @export
stable.tree.clusters <- function(refwt,tests,min.threshold=0.8,min.size=10,n.cores=30,average.thresholds=FALSE) {
  # calculate detectability thresholds for each node against entire list of tests
  #i<- 0;
  refwt$merges <- igraph:::complete.dend(refwt,FALSE)
  for(i in 1:length(tests)) tests[[i]]$merges <- igraph:::complete.dend(tests[[i]],FALSE)
  thrs <- papply(tests,function(testwt) {
    #i<<- i+1; cat("i=",i,'\n');
    idmap <- match(refwt$names,testwt$names)-1L;
    idmap[is.na(idmap)] <- -1;
    x <- scoreTreeConsistency(testwt$merges-1L,refwt$merges-1L,idmap ,min.size)
    x$thresholds;
  },n.cores=n.cores)
  if(length(tests)==1) {
    x <- maxStableClusters(refwt$merges-1L,thrs[[1]],min.threshold,min.size)
    return(length(x$terminalnodes))
  } else {
    if(average.thresholds) {
      # calculate average detection threshold and
      x <- maxStableClusters(refwt$merges-1L,rowMeans(do.call(cbind,thrs)),min.threshold,min.size)
      return(length(x$terminalnodes))
    } else { # reporting the resulting numbers of clusters for each
      xl <- lapply(thrs,function(z) maxStableClusters(refwt$merges-1L,z,min.threshold,min.size))
      return(unlist(lapply(xl,function(x) length(x$terminalnodes))))
    }
  }
}

#' @description Create Seurat object from gene count matrix
#'
#' @param count.matrix gene count matrix
#' @param vars.to.regress variables to regress with Seurat
#' @param verbose verbose mode
#' @param do.par use parallel processing for regressing out variables faster
#' @param n.pcs number of principal components
#' @param cluster do clustering
#' @param tsne do tSNE embedding
#' @return Seurat object
#' @export
basicSeuratProc <- function(count.matrix, vars.to.regress=NULL, verbose=TRUE, do.par=TRUE, n.pcs=100, cluster=TRUE, tsne=TRUE) {
  if (!requireNamespace("Seurat")) {
    stop("You need to install 'Seurat' package to be able to use this function")
  }

  rownames(count.matrix) <- make.unique(rownames(count.matrix))

  max.n.pcs <- min(nrow(count.matrix) - 1, ncol(count.matrix) - 1, n.pcs)
  so <- Seurat::CreateSeuratObject(count.matrix, display.progress=verbose) %>%
    Seurat::NormalizeData(display.progress=verbose) %>%
    Seurat::ScaleData(vars.to.regress=vars.to.regress, display.progress=verbose, do.par=do.par) %>%
    Seurat::FindVariableGenes(do.plot = FALSE, display.progress=verbose) %>%
    Seurat::RunPCA(pcs.compute=max.n.pcs, do.print=FALSE)

  if (cluster) {
    so <- Seurat::FindClusters(so, n.iter=500, n.start=10, dims.use=1:n.pcs, print.output = F)
  }

  if (tsne) {
    so <- Seurat::RunTSNE(so, dims.use=1:n.pcs)
  }

  return(so)
}
