function [ss] = mutual_dependencies(data,bnet,tol)
% Get super-structure by applying 0th-order CI tests.
n = size(bnet.dag,1);   % #nodes
ss = xor(true(n),diag(true(1,n)));      % init super-structure
for i = 1:n-1
    for j = i+1:n
        ci = cond_indep_chisquare(i,j,[],data,'LRT',tol,bnet.node_sizes);
        if ci == 1
            ss(i,j) = false; ss(j,i) = false;   % remove edge
        end
    end
end
end