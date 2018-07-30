function [x_star,sc_star] = get_elite(score,p)
% Get elite individual from current generation population.
j_star = find(score==max(score),1);
sc_star = score(j_star);
x_star = p{j_star};
end