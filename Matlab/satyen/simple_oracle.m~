function [y, cost_y] = simple_oracle(SDP, alpha, X)

persistent idx alpidx last_alpha D;

% TODO... can alpha be negative? if so return 0. 


% work out which constraints we can disregard
if isempty (idx)
    for i=1:length(SDP.b)
        mineig = min (eig (squeeze (SDP.A(i,:,:))));
        idx(i) = mineig >= SDP.b(i);
    end
    
    D = SDP.A(:,:) ./ SDP.b
end


if (isempty (last_alpha) || last_alpha ~= alpha)
    % we know more if alpha is non-negative (this is probable)
    alpidx = idx;
    if (alpha >= 0)
        alpidx = idx & (SDP.b >= 0)';
    end
    last_alpha = alpha;
end

