function [s] = uniform_crossover(N,s,l_map)
% For each individual: randomly choose its mate in the population, then generate the offspring 
% by randomly picking the edge state for each locus from one of the parent individuals.
l_cnt = size(l_map,1);
for i=1:N
    j = i;
    while i==j
        j = randi(N);
    end
    s{N+i} = s{i};
    for l=1:l_cnt
        e1 = l_map(l,1);    e2 = l_map(l,2);
        if round(rand)
            s{N+i}(e1,e2) = s{i}(e1,e2);    s{N+i}(e2,e1) = s{i}(e2,e1);
        else
            s{N+i}(e1,e2) = s{j}(e1,e2);    s{N+i}(e2,e1) = s{j}(e2,e1);
        end
    end
end
end