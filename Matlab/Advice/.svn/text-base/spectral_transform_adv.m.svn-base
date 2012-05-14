function [Y] = spectral_transform_adv (A, Advice, f, vxmeasure, mode)

% form the Laplacian of A
D = diag (vxmeasure);
L = diag (sum (A,2)) - A;

% do subspace trick, rturns R.
R = subspace_trick(Advice, f, mode);

% find S a D-orthonormal basis for the range space of R.
S = G_S_stable(R,D);

if size(S, 2) == 1
    warning ('One dimensional constraint space');
    Z = S;
else
    % find a D-orthnormal basis for range(R) \intersect null(diag(D)')
    N = null ( diag (D)' * S );
    Z = S * N;
end

% restrict to this subspace
L_new = Z' * L * Z;

% find eigenvector corresponding to smallest eigenvalue
[Vecs, Vals] = eig (L_new);
[sorted, idx] = sort (diag (Vals));
Y = Z * Vecs(:,idx(1));