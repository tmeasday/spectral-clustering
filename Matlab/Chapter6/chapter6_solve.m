function [X, cost] = chapter6_solve (SDP, delta)

% SDP is as follows:
% SDP.R is the trace of X
% SDP.C is the cost matrix (n * n)
% SDP.Aeasy is a m_L * n * n array of matrices
% SDP.beasy is m_L-length vector
% SDP.rho
% SDP.Ahard is a m_H * n * n array of matrices
% SDP.bhard is a m_H length vector
% SDP.alphamin
% SDP.alphamax

% SDP assumed to be min problem. Easy to change code to allow both. 
% Assume inequality constraints of the form trace( A_j*X ) >= b_j.
% to be consistent with Satyen's formulation. Note that one of them 
% is trace( X ) >= R.

alphamin = SDP.alphamin;
alphamax = SDP.alphamax;

bestX;
bestCost;

while (alphamax - alphamin > delta)
   
    alpha = (alphamax + alphamin) / 2;
    
    X = chapter6_feasible (SDP, delta, alpha);
    
    if (isempty (X))
        alphamin = alpha;
    else
        bestX = X;
        bestCost = alpha;
        alphamax = alpha;
    end
end