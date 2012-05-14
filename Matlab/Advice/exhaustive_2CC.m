function v = exhaustive_2CC(MB)

n = size(MB,2);

% WLOG assume first coordinate of v is 1.

if n==1
    v = 1;
    return;
elseif n==2
    v = [1;1];
    if v' * MB * v == 0
        return
    else
        v = [1;-1];
    end
end
    
