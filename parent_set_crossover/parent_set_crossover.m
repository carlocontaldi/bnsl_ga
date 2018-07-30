function [s] = parent_set_crossover(N,s)
% For each individual: randomly choose its mate in the population, then generate the offspring 
% by randomly picking the parent set of each vertex from one of the parent individuals.
n = size(s{1},1);
for i=1:N
    j = i;
    while i==j
        j = randi(N);       % random mate choice
    end
    s{N+i} = s{i};
    for ps=1:n
        if round(rand)      % random parent set choice
            s{N+i}(:,ps) = s{j}(:,ps);
        end
    end
end
end