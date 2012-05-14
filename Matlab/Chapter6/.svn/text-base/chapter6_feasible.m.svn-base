function Xbar = chapter6_feasible (SDP, delta, alpha)

% think about this later
epsilon = 1/2;

MAX_ITS = 1000;

m_L = length(SDP.beasy);
m_H = length (SDP.bhard + 3);
[n,n] = size (SDP.C);

A = SDP.Aeasy(:,:);
b = SDP.beasy;

w = ones (m_L, 1);
   
% the cost constraint should be a "hard" constraint. It may, 
% sometimes, have low width, but its width will depend on 
% alpha so in general it wont have low width.

% RECALL: all inequalities are trace( A_j * X ) >= b_j.
% for minimization, cost inequality is trace( -C * X ) >= -alpha. 

I = eye(n);
Ahard = [SDP.Ahard(:,:); -SDP.C(:)'; I(:)'; zeros (1, n^2)];
bhard = [SDP.bhard; -alpha; SDP.R; 0];

Xbar = zeros (n);

for it=1:MAX_ITS
    p = w / sum (w);
    
    Ahard(m_H,:) = p' * A;
    bhard(m_H) = p' * b;
    
    X = chapter6_oracle (Ahard, bhard);
    
    if isempty (X)
        Xbar = [];
        return;
    end
    
    Xbar = (Xbar * (it-1) + x) / it;
    
    if all (A * Xbar(:) - b > -delta)
        return;
    end
       
    m = ( A * X(:) - b ) / SDP.rho;
    
    w = w .* (1 + (2*(m < 0)-1) * epsilon).^((2*(m > 0)-1) .* m);
end