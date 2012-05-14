function R = G_S_stable(R,D)

% runs the numerically stable version of Gram-Schmidt on the columns of R
% to produce a new basis for the span of the columns of R that satisfies
% R' * D * R = I.

[n, k] = size(R);

for j=1:k
    for i=1:(j-1)
        R(:,j) = R(:,j) - (R(:,j)' * D *  R(:,i)) * R(:,i);
    end
    R(:,j) = R(:,j) / sqrt(R(:,j)' * D * R(:,j));
end