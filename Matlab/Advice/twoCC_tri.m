function v = twoCC_tri(MB)

m = size(MB,2);

num_constr = m + nchoosek(m,3);
num_vars = m^2 + nchoosek(m,3);

constr = sparse(num_constr, num_vars);

    for i=1:m
        Ei = sparse(m,m);
        Ei(i,i) = 1;
        constr(i,:) = [sparse(nchoosek(m,3), 1); Ei(:)]';
    end
    
    % add triangle inequalities
    counter = 1;
    for i=1:(m-2)
        for j=(i+1):(m-1)
            for k=(j+1):m
                E = sparse(m,m);
                E(k,k) = -1;
                E(i,j) = -1;
                E(i,k) = 1;
                E(j,k) = 1;
                fill = sparse(nchoosek(m,3), 1);
                fill(counter) = 1;
                constr(counter + m,:) = [fill; E(:)]';
                counter = counter + 1;
            end
        end
    end
                
    
    b = sparse(num_constr,1);
    b(1:m) = 1;
    
    K.f = 0;
    K.l = nchoosek(m,3);
    K.q = 0;
    K.r = 0;
    K.s = m;
    
    [opt, y, info] = sedumi(constr,b,[sparse(nchoosek(m,3), 1); MB(:)]', K);
    
    opt = reshape (opt((nchoosek(m,3)+1):end), m, m);
    [U,S] = eig(opt);
    V_relaxed = U * sqrt(S) * U';
    v = (kmeans (V_relaxed, 2)) * 2 - 3;
