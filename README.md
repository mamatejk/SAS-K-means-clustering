# SAS-K-means-clustering
using proc fastclus data=power maxclusters=6 out=clust  MAXITER=20;
then rerun after removing outliers
