function [X_opt, cost] = ...
    sdp_solver(SDP, alpha_min, alpha_max, epsilon, delta, tol)

% solve an sdp by binary search using the techniques in pp. 30-38
% of Satyen Kale's thesis. Solves to within tol of the optimum.
% It is important that delta < 1. This algorithm will search "upwards" 
% much slower than it searches "downwards" if delta is close to 1. 
% Note that we require SDP.A(:,:,1)== eye(n).

error = abs (alpha_max - alpha_min);

while (error > tol)
    alpha = (alpha_min + alpha_max)/2
    
    [X, y, cost] = check_alpha (alpha, SDP, epsilon, delta);
    
    if isempty(y)
        % found a primal feasible point of cost <= alpha < alpha_max
        alpha_max = cost
        X_opt = X;
    else
        % found a dual feasible point with 
        % cost >= (1 - delta)*alpha > alpha_min
        alpha_min = cost
    end
    error = abs (alpha_max - alpha_min);
end


