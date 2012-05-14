function A = epsilon_nhood (Data, epsilon, metric)

% Data is a k (dimension) by n (number of points) matrix of data. 
% A is the adjacency matrix of an epsilon-neighbourhood graph. 
% That is, start with K_n with edge weights given by Euclidean 
% distance between vertices. Give all edges of weight less 
% than epilon weight 1. Give all other edges weight 0.

[n k] = size (Data);
A = zeros (n);

if nargin == 2
    metric = @(x,y) norm(x - y);
end

for i=1:n
    for j=1:n
        A(i,j) = metric (Data(i,:), Data(j,:)) < epsilon;
    end
end

A = A - eye (n);

