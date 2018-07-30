function [x] = naive_limit_parents(MP,x)
% Naive strategy to reduce #parents for each vertex to MP.
EP = sum(x) - MP;    % #exceeding_parents
for v = 1:size(x,1)
    if EP(v) > 0
        x(:,v) = random_parent_limitation(EP(v),x(:,v));        
    end
end
end