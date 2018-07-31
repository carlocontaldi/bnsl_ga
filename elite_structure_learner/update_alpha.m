function [alpha] = update_alpha(l_map,x_star,es,alpha,dm,dM)
% Update alpha so as to guarantee a suitable amount of diversity in the
% elite set across the evolution process.
l_cnt = size(l_map,1);
E = size(es,2);
%% Entropy-based Diversity Measure Computation
C = zeros(1,E);
for l = 1:l_cnt
    jj = l_map(l,1);    kk = l_map(l,2);
    edge_star = [x_star(jj,kk) x_star(kk,jj)];
    for e = 1:E
        edge = [es{e}(jj,kk) es{e}(kk,jj)];
        C(e) = C(e) + ~all(edge_star==edge);
    end
end
P = accumarray(C'+1,1)'/E;
H = -sum(P.*log2(P+(P==0)));    % 0*log2(0)=0
%% Alpha Update
Hmax = -(l_cnt+1)*log2(1/E)/E;
if H < dm*Hmax && alpha > 0.5
    alpha = alpha-0.01;
elseif H > dM*Hmax && alpha < 1
    alpha = alpha+0.01;
end
end
