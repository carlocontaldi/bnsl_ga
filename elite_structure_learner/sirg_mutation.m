function [s] = sirg_mutation(N,l_map,s,score,pwm)
% Compute a distinct mutation rate for each site of every individual dag 
% and possibly perform mutation on that specific site.
l_cnt = size(l_map,1);
meps = 0.01;    % small positive value
for j=1:N
    for l=1:l_cnt
        jj = l_map(l,1);    kk = l_map(l,2);
        l_val = get_allele(s{j}(jj,kk), s{j}(kk,jj));
        mu = ( meps + (1-meps)*(1-score(j)) )*( meps + (1-meps)*(1-pwm(l,l_val)) );
        if mu >= rand
            l_val_new = mod(l_val+round(rand),3)+1; % randomly pick one of remaining alleles
            switch l_val_new
                case 1
                    s{j}(jj,kk)=false; s{j}(kk,jj)=false;
                case 2
                    s{j}(jj,kk)=false; s{j}(kk,jj)=true;
                case 3
                    s{j}(jj,kk)=true; s{j}(kk,jj)=false;
            end
        end
    end
end
end