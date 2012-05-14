function new_data = diagonal_metric (Pts, Constraints)

EPSILON = 0.01;

% uses the notation from the paper....
% Here D has rows that are the 'difference' constraints

[n,k] = size (Pts);
    
[S, nS] = getConstrDiff (Pts, Constraints > 0);
[D, nD] = getConstrDiff (Pts, Constraints < 0);

A = eye (k);

while true
    mynorm = mahalanobis (A);
    
    % gradient
    g = zeros (k, 1);
    % hessian
    H = zeros (k);
    
    % work out the sum of the D distance relative to A
    beta = sum (mynorm (D));

    
    % initialize g's to be just the second term (useful for H)
    for i=1:k
        uf = @(x) x(i)^2 / mynorm (x);
        u = sum (map (uf, D));
        
        g(i) = - u / (2*beta);
    end
    
    % ok. Now work out H
    for i=1:k
        for j=1:k
            nf = @(x) x(i)^2 * x(j)^2 / (4 * mynorm (x)^3);
            num = sum (map (nf, D)) / beta;
            
            H(i,j) = num + g(i) * g(j);
        end
    end
    
    % now finish working out the g's
    for i=1:k
        df = @(x) x(i)^2;
        g(i) = g(i) + sum (map (df, S));
    end
    
    g
    H
    
    % Calculate p and how far along p we can go whilst remaining non
    % negative...
    % p = H^{-1} g % TODO -- exploit that this is symmetric
    p = H \ g
    
    
    alpha = 1;
    for i=1:k
        if (A(i,i) < alpha * p(i))
            alpha = A(i,i) / p(i);
        end
    end
    
    alpha
    
    dist = norm(p) * alpha;
    % stopping condition--we aren't moving very far
    if (dist < EPSILON)
        break % and return mynorm
    end
    
    % now change the matrix
    A = A - diag(alpha * p)
end

transform = A^.5;
new_data = Pts * transform;

% the differences between points in constraints are listed in the the rows
% of C....
function [C, nC] = getConstrDiff (Pts, Constrs)
    [n,k] = size (Pts);
    [i1,i2] = find(Constrs);
    Clist = Pts([i1,i2]',:);
    [nC, junk] = size (i1);

    C = zeros(nC, k);
    for i=1:nC
        C(i,:) = Clist(2*i - 1, :) - Clist (2*i, :);
    end