function mynorm = mahalanobis (D)

mynorm = @(X) sqrt (sum (X' .* (D * X'), 1));