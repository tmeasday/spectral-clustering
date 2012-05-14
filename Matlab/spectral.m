function [y] = spectral(A, k)

% VERY unfinished code for spectral clustering. 
% Cluster indicator is a n (num. data pts) by k (num. clusters) matrix
% the kth column of which is the indicator function of the membership
% of the kth cluster.


% perform spectral clustering into k clusters

% first transform the points spectrally
Y = spectral_transform (A, k);

% then cluster the transformed points
y = kmeans (Y, 2);
% lets get into coordinates we like
y = y*2 - 3;