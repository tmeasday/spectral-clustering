function [Y] = spectral_transform (A, k)

% form the Laplacian of A
D = diag (sum (A));
L = D - A;

% normalize the laplacian
Dinvsqrt = D^(-1/2);
Lsym = Dinvsqrt * L * Dinvsqrt;

% might be better to produce generalized eigenvalues?
[Vecs, Vals] = eig (Lsym);

[sorted, idx] = sort (diag (Vals));

Y = Vecs(:,idx(2:k));
% potentially Y should be renormalized...