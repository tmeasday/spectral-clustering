function [P] = mmw(sumM, epsilon)

% function runs the matrix multiplicative weights algorithms from p24 of
% Satyen Kale's thesis (in the order, step 2., step 3., step 1.)

W = expm (-epsilon * sumM);

P = W/trace(W);