function [p,l_map,l_cnt] = init_population(ss,N)
% Initialize population through random state assignment to ss edges.
% ss acts as a mutation matrix: if edge (i,j) is oriented in the ss then 
% it can change state in each individual in the population.
n = size(ss,1);     % #nodes
p = cell(1,N);      % population
p(:) = {false(n)};
l_cnt = 0;          % loci count / individual string length
l_map = zeros(0,2); % locus to matrix pair map
for j=1:n-1
    for k=j+1:n
        if ss(j,k)
            l_cnt = l_cnt+1;
            l_map(l_cnt,:) = [j k];
            for i=1:N
                switch(randi(3))    % randomly choose edge state
                    case 1
                        p{i}(j,k) = true;   p{i}(k,j) = false;
                    case 2
                        p{i}(j,k) = false;  p{i}(k,j) = true;
                    % otherwise     % already done @line 6
                        % p{i}(j,k) = false;  p{i}(k,j) = false;
                end
            end
        end
    end
end
end