function R = corr_clustering_complete(Advice)

EPS = 0.00001;
n = size(Advice,1);

[MB, partition] = to_block_form(Advice);

Advice = Advice + Advice' + eye(n);
cost = zeros(1,n);

for i=1:n
    v = Advice(:,i);
    cost(i) = v' * MB * v;
end

[min_cost, idx] = min(cost);

R = full(Advice(:,idx(1)));

% ok this R is not good enough... we need to improve it by local search
while (true)
    changes = (Advice * R) .* R;
    
    [min_change, min_idx] = min (changes);
    
    if (min_change) < -EPS
        R(min_idx) = R(min_idx) * -1;
    else
        break;
    end
end