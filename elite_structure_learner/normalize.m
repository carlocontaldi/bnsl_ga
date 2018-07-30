function [norm_score,sum_norm_score] = normalize(score,sc_star,compute_sum)
% Normalize score array.
eps = 0.0000001;        % small positive number
sum_norm_score = 0;
sc_worst = min(score);
range = sc_star-sc_worst;
norm_score = (score-sc_worst)/(eps+range); % normalized score
if compute_sum
    sum_norm_score = sum(norm_score)+eps;
end
end