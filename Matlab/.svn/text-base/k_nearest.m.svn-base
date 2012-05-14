function A = k_nearest(Data, k, flag, metric)

% Data is a k (dimension) by n (number of points) matrix of data. 
% A is the adjacency matrix of "the" k-nearest neighbour graph.
% flag is a string that indicates whether we want a 'mutual'
% k-nearest neighbour graph or 'nonmutual' k-nearest neighbour graph.

% That is, start with K_n with edge weights given by Euclidean 
% distance between vertices. For the 'nonmutual' case, if edge e_{ij} 
% is among the k lowest weight edges incident on vertex i OR edge e_{ij} 
% is among the k lowest weight edges incident on vertex j, assign weight 
% 1 to e_{ij} than epilon weight 1. Give all other edges weight 0. For the
% 'mutual' case replace OR with AND.

[n m] = size (Data);
Distances = zeros (n);

if nargin == 3
    metric = @(x,y) norm(x - y);
end

% we will eventually sort this so the edges are in the right places. 
% we start at two so that we don't include the zero distance from a 
% vertex to itself as giving a "nearest" neighbour.
A = repmat (false, n, n);
A(2:k+1,1:n) = true;

for i=1:n
    for j=1:n
        Distances(i,j) = metric (Data(i,:) , Data(j,:));
    end
end

% sort the columns of Distances
[Sorted_data Perm] = sort (Distances);
[junk Inv_perm] = sort (Perm);

A = A(Inv_perm);

if strcmp (flag, 'nonmutual')
    A = A | A';
elseif strcmp (flag, 'mutual')
    A = A & A';
else 
    error ('third argument must be either "mutual" or "nonmutual"');
end


