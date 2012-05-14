% note that map runs over rows

function Out = map (f, In)
    [r, c] = size (In);
    
    if (isempty (In))
        Out = [];
        return;
    end
    
    row1 = f (In (1,:));
   
    Out = zeros (r, length (row1));
    Out(1,:) = row1;
    for i=2:r
        Out (i, :) = f (In (i, :));
    end