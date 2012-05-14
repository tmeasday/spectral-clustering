function [X, ystar, cost] = check_alpha (alpha, SDP, epsilon, delta)

% note that SDP.A(:,:) is a k x n^2 matrix whose rows are the A_j unfolded
% into *row* vectors.

ERR=10^-6;
MAX_ITS=10000;

[k,n,n] = size (SDP.A);
R = SDP.b(1);

X = eye(n) * R/n;

ybar = zeros (k,1);

sumM = zeros (n);
    
for it=1:MAX_ITS
    
    [y,c] = oracle (SDP, alpha, X);
 
    % check this
    % if the best y has larger S.X than C.X then X scaled to be feasible
    % will have cost less than alpha
    if ((c - SDP.C(:)' * X(:)) > ERR)
        % how much do we need to scale X?
   
        % there's probably some special way to do this
        
        % scale = 1;
        
        % this line added to replace the loop below
        scale = max ( SDP.b ./ ( SDP.A(:,:)*X(:) ) );
             
%         for i = 1:k
%             fit = SDP.b(i) / SDP.A(i,:)' * X(:);
%             
%             if (fit > scale)
%                 scale = fit;
%             end
%         end

        X = X * scale;
        cost = X(:)' * SDP.C(:);
        
        ystar = [];
        return;
    end
   
    
    % else work out what ystar is going to be
    ybar = (ybar * (it-1) + y) / it;
    
    % we need to know what S's largest eigenvalue is
%    S = -1 * SDP.C;
    % again, probably a better way to do this
%     for i = 1:k
%         S = S + y(i) * squeeze (SDP.A(i,:,:));
%     end
% added this line to replace the loop above. Perhaps the y here should 
% be ybar?
    Sbar = reshape ( ybar' * SDP.A(:,:), n, n ) - SDP.C;

    % not sure if this is what we want. Perhaps we should do
    E = sort (eig(Sbar));
    largest = E(end);
    
    ystar = ybar;
    if largest > 0
        ystar(1) = ystar(1) - largest;
    end
    
    % now.. does it have sufficient cost
    cost = SDP.b' * ystar; 
    if cost > (1 - delta) * alpha
        return;
    end
    
    % ok.. no X, or y... so call mmw again.
    % M is curly S
    S = reshape ( y' * SDP.A(:,:), n, n ) - SDP.C;

    % not sure if this is what we want. Perhaps we should do
    E = sort (eig(S));
    smallest = E(1);
    largest = E(end);
    
    
    if abs(largest) > abs (smallest)
        M = -1 * (S - smallest * eye(n)) / (largest - smallest);
    else
        M = -1 * (S - largest * eye(n)) / (largest - smallest);
    end
    
    
    sumM = sumM + M;
    P = mmw (sumM, epsilon);
    
    X = P * R;
end

% error?
