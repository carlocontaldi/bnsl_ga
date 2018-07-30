function [pwm] = construct_pwm(l_cnt,e_score,es,ss)
% Build the Position Weight Matrix.
n = size(ss,1);
pwm = zeros(l_cnt,3);
sum_norm_e_score = 0;
for e=1:size(es,2)
    l = 0;
    sum_norm_e_score = sum_norm_e_score + e_score(e);
    for j=1:n-1
        for k = j+1:n
            if ss(j,k)
                l = l+1;
                l_val = get_allele(es{e}(j,k),es{e}(k,j));
                pwm(l,l_val) = pwm(l,l_val) + e_score(e);
            end
        end
    end
end
pwm = pwm/sum_norm_e_score;
end