function [max, gaps] = is_consistent (Advice)
    EPS = 0.00001;

    [MB, part] = to_block_form (Advice);
    
    gaps = [];
    
    max = EPS;
    for i=1:length(part)
        MBi = MB(part{i},part{i});
        
        val = eig (MBi);
        small = min (val);
        
        if small < -EPS
            error ('MBi was not PSD');
        elseif small > EPS
            gaps = [gaps; (val / small) - 1];
            
            if small > max
                max = small;
            end
        end
    end
    
    gaps = unique (gaps);
    
    if max == EPS
        max = 0;
    end