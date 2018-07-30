function [x_star,sc_star,p,score] = update_elite(x_star,sc_star,p,score)
% Update elite individual for current generation population.
[x_star2,sc_star2] = get_elite(score,p);
if sc_star2 > sc_star
    x_star = x_star2;
    sc_star = sc_star2;
else
    j_worst = find(score==min(score),1);
    p{j_worst} = x_star;    % Place-Elite-Individual
    score(j_worst) = sc_star;
end
end