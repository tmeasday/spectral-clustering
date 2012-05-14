function [y, cost_y] = oracle(SDP, alpha, X)

% solves the linear program:
% min sum_j <A_j, X> y_j s.t. b^T y >= alpha and y >=0
% where SDP.A(j,:,:) = A_j; SDP.b = b (is a column vector);

[n n] = size (X);
f = zeros(n,1);

for i=1:n
    f(i) = ( SDP.A(i,:) )*X(:);
end

options = optimset ('Display', 'off', 'LargeScale', 'off', 'Simplex', 'on');
[y, cost_y] = linprog(f, -(SDP.b)', -alpha, [], [], zeros(n,1), [], [], options);



