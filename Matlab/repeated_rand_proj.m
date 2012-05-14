function [min_y, min_cost] = repeated_rand_proj(Data, cost_func, iter)

% Data is a k (dimension) by n (number of points) matrix whose columns are
% unit vectors. min_y will be a n-vector of +/- 1s of cost min_cost.
% cost_func is a function that determines the cost of a candidate output 
% vector y. iter is the number of randomized projections taken.

for i=1:iter
    
    y = randomized_projection (Data);
    Gamma = y*y';
    cost = cost_func(Gamma(:));
    if i==1
        min_cost = cost;
        min_y = y;
    elseif (cost < min_cost)
        min_cost = cost;
        min_y = y;
    end
end