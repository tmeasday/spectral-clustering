function [opt cost] = twoCC(MB, algorithm, leeway)

% solves a relaxation of min-disagree[2] correlation clustering. 
% Arguments:
% -- MB: an advice-block matrix.
% -- algorithm: a string taking value 'spectral' or 'SDP'
% -- leeway: (optional) tells spectral how many eigenvectors to return by
% telling it how far from the smallest eigenvalue we are allowed to
% deviate. Default value is 10^(-6).

% Returns:
% -- opt: the optimal point(s)
% -- cost: the optimal cost

% Algorithm:
% if algorithm == 'spectral' return the eigenvector of MB corresponding to
% the smallest eigenvalue. The cost is opt' * MB * opt.
% if algorithm == 'SDP' solve:
% min tr(MB * X) s.t. X_ii = 1, X psd.

EPS = 10^(-5);

if strcmp(algorithm, 'spectral')
    [Vecs, Vals] = eig (full(MB));
    [sorted, idx] = sort (diag (Vals));
    
    opt = [];
    if abs(sorted(1)) < EPS
        opt = Vecs(:, idx(1));
    else
        ratios = sorted / sorted(1);
        for i=1:length(ratios)
            if ratios(i) <= (1 + leeway)
                opt = [opt Vecs(:,idx(i))];
            else
                break;
            end
        end
    end
    cost = opt(:,1)' * MB * opt(:,1);
    
    
%     differences = abs(sorted - sorted(1));
%     opt = [];
%     
%     if nargin == 2
%         leeway = 10^(-6);
%     end
%     
%     for i=1:length (differences)
%         if differences(i) < leeway + EPS
%             opt = [opt Vecs(:,idx(i))];
%         else
%             break;
%         end
%     end
%     cost = opt(:,1)' * MB * opt(:,1);
elseif strcmp(algorithm, 'SDP')
    
    m = size(MB,2);
    
    constr = sparse(m, m^2);
    for i=1:m
        Ei = sparse(m,m);
        Ei(i,i) = 1;
        constr(i,:) = Ei(:);
    end
    
    b = ones(m,1);
    
    K.f = 0;
    K.l = 0;
    K.q = 0;
    K.r = 0;
    K.s = m;
    
    [opt, y, info] = sedumi(constr,b,MB(:), K);
    
    cost = MB(:)' * opt;
    
    opt = reshape (opt, m, m);
else
    error('Second argument must be either ''spectral'' or ''SDP'' or ''2CC''');
end

