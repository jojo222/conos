// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <RcppArmadillo.h>
#include <RcppEigen.h>
#include <Rcpp.h>

using namespace Rcpp;

// checkBits
bool checkBits();
RcppExport SEXP _conos_checkBits() {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    rcpp_result_gen = Rcpp::wrap(checkBits());
    return rcpp_result_gen;
END_RCPP
}
// checkOpenMP
bool checkOpenMP();
RcppExport SEXP _conos_checkOpenMP() {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    rcpp_result_gen = Rcpp::wrap(checkOpenMP());
    return rcpp_result_gen;
END_RCPP
}
// cpcaF
Rcpp::List cpcaF(const arma::cube& cov, const arma::vec& ng, int ncomp, int maxit, double tol, Nullable<NumericMatrix> eigenvR, bool verbose);
RcppExport SEXP _conos_cpcaF(SEXP covSEXP, SEXP ngSEXP, SEXP ncompSEXP, SEXP maxitSEXP, SEXP tolSEXP, SEXP eigenvRSEXP, SEXP verboseSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const arma::cube& >::type cov(covSEXP);
    Rcpp::traits::input_parameter< const arma::vec& >::type ng(ngSEXP);
    Rcpp::traits::input_parameter< int >::type ncomp(ncompSEXP);
    Rcpp::traits::input_parameter< int >::type maxit(maxitSEXP);
    Rcpp::traits::input_parameter< double >::type tol(tolSEXP);
    Rcpp::traits::input_parameter< Nullable<NumericMatrix> >::type eigenvR(eigenvRSEXP);
    Rcpp::traits::input_parameter< bool >::type verbose(verboseSEXP);
    rcpp_result_gen = Rcpp::wrap(cpcaF(cov, ng, ncomp, maxit, tol, eigenvR, verbose));
    return rcpp_result_gen;
END_RCPP
}
// greedyModularityCut
Rcpp::List greedyModularityCut(arma::imat& merges, arma::vec& deltaM, int N, int minsize, arma::ivec& labels, double minbreadth);
RcppExport SEXP _conos_greedyModularityCut(SEXP mergesSEXP, SEXP deltaMSEXP, SEXP NSEXP, SEXP minsizeSEXP, SEXP labelsSEXP, SEXP minbreadthSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< arma::imat& >::type merges(mergesSEXP);
    Rcpp::traits::input_parameter< arma::vec& >::type deltaM(deltaMSEXP);
    Rcpp::traits::input_parameter< int >::type N(NSEXP);
    Rcpp::traits::input_parameter< int >::type minsize(minsizeSEXP);
    Rcpp::traits::input_parameter< arma::ivec& >::type labels(labelsSEXP);
    Rcpp::traits::input_parameter< double >::type minbreadth(minbreadthSEXP);
    rcpp_result_gen = Rcpp::wrap(greedyModularityCut(merges, deltaM, N, minsize, labels, minbreadth));
    return rcpp_result_gen;
END_RCPP
}
// findBestClusterThreshold
Rcpp::List findBestClusterThreshold(arma::imat& merges, arma::ivec& clusters, arma::ivec& clusterTotals);
RcppExport SEXP _conos_findBestClusterThreshold(SEXP mergesSEXP, SEXP clustersSEXP, SEXP clusterTotalsSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< arma::imat& >::type merges(mergesSEXP);
    Rcpp::traits::input_parameter< arma::ivec& >::type clusters(clustersSEXP);
    Rcpp::traits::input_parameter< arma::ivec& >::type clusterTotals(clusterTotalsSEXP);
    rcpp_result_gen = Rcpp::wrap(findBestClusterThreshold(merges, clusters, clusterTotals));
    return rcpp_result_gen;
END_RCPP
}
// scoreTreeConsistency
Rcpp::List scoreTreeConsistency(arma::imat& test, arma::imat& ref, arma::ivec& leafidmap, int minsize);
RcppExport SEXP _conos_scoreTreeConsistency(SEXP testSEXP, SEXP refSEXP, SEXP leafidmapSEXP, SEXP minsizeSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< arma::imat& >::type test(testSEXP);
    Rcpp::traits::input_parameter< arma::imat& >::type ref(refSEXP);
    Rcpp::traits::input_parameter< arma::ivec& >::type leafidmap(leafidmapSEXP);
    Rcpp::traits::input_parameter< int >::type minsize(minsizeSEXP);
    rcpp_result_gen = Rcpp::wrap(scoreTreeConsistency(test, ref, leafidmap, minsize));
    return rcpp_result_gen;
END_RCPP
}
// maxStableClusters
Rcpp::List maxStableClusters(arma::imat& merges, arma::vec& thresholds, double minthreshold, int minsize);
RcppExport SEXP _conos_maxStableClusters(SEXP mergesSEXP, SEXP thresholdsSEXP, SEXP minthresholdSEXP, SEXP minsizeSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< arma::imat& >::type merges(mergesSEXP);
    Rcpp::traits::input_parameter< arma::vec& >::type thresholds(thresholdsSEXP);
    Rcpp::traits::input_parameter< double >::type minthreshold(minthresholdSEXP);
    Rcpp::traits::input_parameter< int >::type minsize(minsizeSEXP);
    rcpp_result_gen = Rcpp::wrap(maxStableClusters(merges, thresholds, minthreshold, minsize));
    return rcpp_result_gen;
END_RCPP
}
// referenceWij
arma::sp_mat referenceWij(const arma::ivec& i, const arma::ivec& j, arma::vec& d, Rcpp::Nullable<Rcpp::IntegerVector> threads, double perplexity);
RcppExport SEXP _conos_referenceWij(SEXP iSEXP, SEXP jSEXP, SEXP dSEXP, SEXP threadsSEXP, SEXP perplexitySEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const arma::ivec& >::type i(iSEXP);
    Rcpp::traits::input_parameter< const arma::ivec& >::type j(jSEXP);
    Rcpp::traits::input_parameter< arma::vec& >::type d(dSEXP);
    Rcpp::traits::input_parameter< Rcpp::Nullable<Rcpp::IntegerVector> >::type threads(threadsSEXP);
    Rcpp::traits::input_parameter< double >::type perplexity(perplexitySEXP);
    rcpp_result_gen = Rcpp::wrap(referenceWij(i, j, d, threads, perplexity));
    return rcpp_result_gen;
END_RCPP
}
// sgd
arma::mat sgd(arma::mat& coords, arma::ivec& targets_i, arma::ivec& sources_j, arma::ivec& ps, arma::vec& weights, const double& gamma, const double& rho, const arma::uword& n_samples, const int& M, const double& alpha, const Rcpp::Nullable<Rcpp::NumericVector> momentum, const bool& useDegree, const Rcpp::Nullable<Rcpp::NumericVector> seed, const Rcpp::Nullable<Rcpp::IntegerVector> threads, const bool verbose);
RcppExport SEXP _conos_sgd(SEXP coordsSEXP, SEXP targets_iSEXP, SEXP sources_jSEXP, SEXP psSEXP, SEXP weightsSEXP, SEXP gammaSEXP, SEXP rhoSEXP, SEXP n_samplesSEXP, SEXP MSEXP, SEXP alphaSEXP, SEXP momentumSEXP, SEXP useDegreeSEXP, SEXP seedSEXP, SEXP threadsSEXP, SEXP verboseSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< arma::mat& >::type coords(coordsSEXP);
    Rcpp::traits::input_parameter< arma::ivec& >::type targets_i(targets_iSEXP);
    Rcpp::traits::input_parameter< arma::ivec& >::type sources_j(sources_jSEXP);
    Rcpp::traits::input_parameter< arma::ivec& >::type ps(psSEXP);
    Rcpp::traits::input_parameter< arma::vec& >::type weights(weightsSEXP);
    Rcpp::traits::input_parameter< const double& >::type gamma(gammaSEXP);
    Rcpp::traits::input_parameter< const double& >::type rho(rhoSEXP);
    Rcpp::traits::input_parameter< const arma::uword& >::type n_samples(n_samplesSEXP);
    Rcpp::traits::input_parameter< const int& >::type M(MSEXP);
    Rcpp::traits::input_parameter< const double& >::type alpha(alphaSEXP);
    Rcpp::traits::input_parameter< const Rcpp::Nullable<Rcpp::NumericVector> >::type momentum(momentumSEXP);
    Rcpp::traits::input_parameter< const bool& >::type useDegree(useDegreeSEXP);
    Rcpp::traits::input_parameter< const Rcpp::Nullable<Rcpp::NumericVector> >::type seed(seedSEXP);
    Rcpp::traits::input_parameter< const Rcpp::Nullable<Rcpp::IntegerVector> >::type threads(threadsSEXP);
    Rcpp::traits::input_parameter< const bool >::type verbose(verboseSEXP);
    rcpp_result_gen = Rcpp::wrap(sgd(coords, targets_i, sources_j, ps, weights, gamma, rho, n_samples, M, alpha, momentum, useDegree, seed, threads, verbose));
    return rcpp_result_gen;
END_RCPP
}
// n2Knn
arma::sp_mat n2Knn(const NumericMatrix& m, int k, int nThreads, bool verbose, std::string indexType, int M, int MaxM0);
RcppExport SEXP _conos_n2Knn(SEXP mSEXP, SEXP kSEXP, SEXP nThreadsSEXP, SEXP verboseSEXP, SEXP indexTypeSEXP, SEXP MSEXP, SEXP MaxM0SEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const NumericMatrix& >::type m(mSEXP);
    Rcpp::traits::input_parameter< int >::type k(kSEXP);
    Rcpp::traits::input_parameter< int >::type nThreads(nThreadsSEXP);
    Rcpp::traits::input_parameter< bool >::type verbose(verboseSEXP);
    Rcpp::traits::input_parameter< std::string >::type indexType(indexTypeSEXP);
    Rcpp::traits::input_parameter< int >::type M(MSEXP);
    Rcpp::traits::input_parameter< int >::type MaxM0(MaxM0SEXP);
    rcpp_result_gen = Rcpp::wrap(n2Knn(m, k, nThreads, verbose, indexType, M, MaxM0));
    return rcpp_result_gen;
END_RCPP
}
// n2CrossKnn
arma::sp_mat n2CrossKnn(const NumericMatrix& mA, const NumericMatrix& mB, int k, int nThreads, bool verbose, std::string indexType, int M, int MaxM0);
RcppExport SEXP _conos_n2CrossKnn(SEXP mASEXP, SEXP mBSEXP, SEXP kSEXP, SEXP nThreadsSEXP, SEXP verboseSEXP, SEXP indexTypeSEXP, SEXP MSEXP, SEXP MaxM0SEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const NumericMatrix& >::type mA(mASEXP);
    Rcpp::traits::input_parameter< const NumericMatrix& >::type mB(mBSEXP);
    Rcpp::traits::input_parameter< int >::type k(kSEXP);
    Rcpp::traits::input_parameter< int >::type nThreads(nThreadsSEXP);
    Rcpp::traits::input_parameter< bool >::type verbose(verboseSEXP);
    Rcpp::traits::input_parameter< std::string >::type indexType(indexTypeSEXP);
    Rcpp::traits::input_parameter< int >::type M(MSEXP);
    Rcpp::traits::input_parameter< int >::type MaxM0(MaxM0SEXP);
    rcpp_result_gen = Rcpp::wrap(n2CrossKnn(mA, mB, k, nThreads, verbose, indexType, M, MaxM0));
    return rcpp_result_gen;
END_RCPP
}
// propagate_labels
Rcpp::NumericMatrix propagate_labels(const Rcpp::StringMatrix& edge_verts, const std::vector<double>& edge_weights, const Rcpp::StringVector& vert_labels, int max_n_iters, bool verbose, int method, double diffusion_fading, double diffusion_fading_const, double tol);
RcppExport SEXP _conos_propagate_labels(SEXP edge_vertsSEXP, SEXP edge_weightsSEXP, SEXP vert_labelsSEXP, SEXP max_n_itersSEXP, SEXP verboseSEXP, SEXP methodSEXP, SEXP diffusion_fadingSEXP, SEXP diffusion_fading_constSEXP, SEXP tolSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const Rcpp::StringMatrix& >::type edge_verts(edge_vertsSEXP);
    Rcpp::traits::input_parameter< const std::vector<double>& >::type edge_weights(edge_weightsSEXP);
    Rcpp::traits::input_parameter< const Rcpp::StringVector& >::type vert_labels(vert_labelsSEXP);
    Rcpp::traits::input_parameter< int >::type max_n_iters(max_n_itersSEXP);
    Rcpp::traits::input_parameter< bool >::type verbose(verboseSEXP);
    Rcpp::traits::input_parameter< int >::type method(methodSEXP);
    Rcpp::traits::input_parameter< double >::type diffusion_fading(diffusion_fadingSEXP);
    Rcpp::traits::input_parameter< double >::type diffusion_fading_const(diffusion_fading_constSEXP);
    Rcpp::traits::input_parameter< double >::type tol(tolSEXP);
    rcpp_result_gen = Rcpp::wrap(propagate_labels(edge_verts, edge_weights, vert_labels, max_n_iters, verbose, method, diffusion_fading, diffusion_fading_const, tol));
    return rcpp_result_gen;
END_RCPP
}
// smooth_count_matrix
SEXP smooth_count_matrix(const Rcpp::StringMatrix& edge_verts, const std::vector<double>& edge_weights, const Rcpp::NumericMatrix& count_matrix, int max_n_iters, double diffusion_fading, double diffusion_fading_const, double tol, bool verbose);
RcppExport SEXP _conos_smooth_count_matrix(SEXP edge_vertsSEXP, SEXP edge_weightsSEXP, SEXP count_matrixSEXP, SEXP max_n_itersSEXP, SEXP diffusion_fadingSEXP, SEXP diffusion_fading_constSEXP, SEXP tolSEXP, SEXP verboseSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const Rcpp::StringMatrix& >::type edge_verts(edge_vertsSEXP);
    Rcpp::traits::input_parameter< const std::vector<double>& >::type edge_weights(edge_weightsSEXP);
    Rcpp::traits::input_parameter< const Rcpp::NumericMatrix& >::type count_matrix(count_matrixSEXP);
    Rcpp::traits::input_parameter< int >::type max_n_iters(max_n_itersSEXP);
    Rcpp::traits::input_parameter< double >::type diffusion_fading(diffusion_fadingSEXP);
    Rcpp::traits::input_parameter< double >::type diffusion_fading_const(diffusion_fading_constSEXP);
    Rcpp::traits::input_parameter< double >::type tol(tolSEXP);
    Rcpp::traits::input_parameter< bool >::type verbose(verboseSEXP);
    rcpp_result_gen = Rcpp::wrap(smooth_count_matrix(edge_verts, edge_weights, count_matrix, max_n_iters, diffusion_fading, diffusion_fading_const, tol, verbose));
    return rcpp_result_gen;
END_RCPP
}
// adjacent_vertices
Rcpp::List adjacent_vertices(const Rcpp::StringMatrix& edge_verts);
RcppExport SEXP _conos_adjacent_vertices(SEXP edge_vertsSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const Rcpp::StringMatrix& >::type edge_verts(edge_vertsSEXP);
    rcpp_result_gen = Rcpp::wrap(adjacent_vertices(edge_verts));
    return rcpp_result_gen;
END_RCPP
}
// adjacent_vertex_weights
Rcpp::List adjacent_vertex_weights(const Rcpp::StringMatrix& edge_verts, const std::vector<double>& edge_weights);
RcppExport SEXP _conos_adjacent_vertex_weights(SEXP edge_vertsSEXP, SEXP edge_weightsSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const Rcpp::StringMatrix& >::type edge_verts(edge_vertsSEXP);
    Rcpp::traits::input_parameter< const std::vector<double>& >::type edge_weights(edge_weightsSEXP);
    rcpp_result_gen = Rcpp::wrap(adjacent_vertex_weights(edge_verts, edge_weights));
    return rcpp_result_gen;
END_RCPP
}
// spcov
Eigen::MatrixXd spcov(const Eigen::SparseMatrix<double>& m, Eigen::VectorXd cm);
RcppExport SEXP _conos_spcov(SEXP mSEXP, SEXP cmSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const Eigen::SparseMatrix<double>& >::type m(mSEXP);
    Rcpp::traits::input_parameter< Eigen::VectorXd >::type cm(cmSEXP);
    rcpp_result_gen = Rcpp::wrap(spcov(m, cm));
    return rcpp_result_gen;
END_RCPP
}

static const R_CallMethodDef CallEntries[] = {
    {"_conos_checkBits", (DL_FUNC) &_conos_checkBits, 0},
    {"_conos_checkOpenMP", (DL_FUNC) &_conos_checkOpenMP, 0},
    {"_conos_cpcaF", (DL_FUNC) &_conos_cpcaF, 7},
    {"_conos_greedyModularityCut", (DL_FUNC) &_conos_greedyModularityCut, 6},
    {"_conos_findBestClusterThreshold", (DL_FUNC) &_conos_findBestClusterThreshold, 3},
    {"_conos_scoreTreeConsistency", (DL_FUNC) &_conos_scoreTreeConsistency, 4},
    {"_conos_maxStableClusters", (DL_FUNC) &_conos_maxStableClusters, 4},
    {"_conos_referenceWij", (DL_FUNC) &_conos_referenceWij, 5},
    {"_conos_sgd", (DL_FUNC) &_conos_sgd, 15},
    {"_conos_n2Knn", (DL_FUNC) &_conos_n2Knn, 7},
    {"_conos_n2CrossKnn", (DL_FUNC) &_conos_n2CrossKnn, 8},
    {"_conos_propagate_labels", (DL_FUNC) &_conos_propagate_labels, 9},
    {"_conos_smooth_count_matrix", (DL_FUNC) &_conos_smooth_count_matrix, 8},
    {"_conos_adjacent_vertices", (DL_FUNC) &_conos_adjacent_vertices, 1},
    {"_conos_adjacent_vertex_weights", (DL_FUNC) &_conos_adjacent_vertex_weights, 2},
    {"_conos_spcov", (DL_FUNC) &_conos_spcov, 2},
    {NULL, NULL, 0}
};

RcppExport void R_init_conos(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
