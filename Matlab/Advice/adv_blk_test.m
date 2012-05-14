function [V, D] = adv_blk_test(Advice)

% arguments:
% -- The adjacency matrix of a connected graph on n vertices that has
% positive and negative edge weights such that the absolute value of the
% edge weights sums to 2.

% returns:
% -- an orthogonal matrix consisting of the eigenvalues of the advice-block
% matrix corrsponding to the advice-graph.


% build the advice-block matrix. Assume that Advice is in the right form
% and has the `right' dimensions.

[n n] = size (Advice);

Block = zeros (n);

% the diagonal entries of Block 
D = diag (sum (abs (Advice)));

Block = D - Advice;

[V, D] = eig(Block);