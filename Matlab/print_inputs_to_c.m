function print_inputs_to_c (fname, Pts, Constrs)

    out = fopen (fname, 'w');
    
    for pt=Pts'
        comma = false;
        for coord=pt'
            if comma
                fprintf (out, ',');
            else
                comma = true;
            end
            
            fprintf (out, '%0.8f', coord);
        end
        fprintf (out, '\n');
    end
    
    [is, js] = find (Constrs > 0);
    for ij=[is,js]'
        fprintf (out, '%d,%d:1\n', ij(1)-1, ij(2)-1);
    end
    
    
    [is, js] = find (Constrs < 0);
    for ij=[is,js]'
        fprintf (out, '%d,%d:-1\n', ij(1)-1, ij(2)-1);
    end
    
    fclose (out);