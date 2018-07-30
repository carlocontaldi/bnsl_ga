function [p2,score2,norm_score2] = proportional_selection(N,N2,p,score,norm_score,sum_norm_score)
% Halve population size by retaining fitter individuals with an higher likelihood.
i = 0;  j = 0;  
p2 = cell(1,N2);
score2 = -Inf*ones(1,N2);
norm_score2 = -Inf*ones(1,N2);
while j < N
    i = mod(i,N2) + 1;
    if norm_score(i)/sum_norm_score >= rand
        j = j+1;
        p2{j} = p{i};
        score2(j) = score(i);
        norm_score2(j) = norm_score(i);
    end
end
end