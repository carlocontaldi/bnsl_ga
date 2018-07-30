function [x] = elite_guided_limit_parents(MP,x,l_map,pwm)
% Knowledge-driven strategy to reduce #parents for each vertex to MP.
% The edges to remove are determined with the Parent Weight Vector.
EP = sum(x) - MP;    % #exceeding_parents
for v = 1:size(x,1)
    if EP(v) > 0
        l_idx = [find(l_map(:,1)==v); find(l_map(:,2)==v)];
        ps = find(x(:,v))';     % exceeding parent set
        pwv = zeros(1,size(ps,2));
        pi = 0;     % parent index
        for p = ps
            pi = pi+1;
            e = l_idx(l_map(l_idx,1)==p);
            l_val = 3;
            if isempty(e)
                e = l_idx(l_map(l_idx,2)==p);
                l_val = 2;
            end
            pwv(pi) = pwm(e,l_val);
        end
        if size(unique(pwv),2) > 1    % all parents have not the same weight
            while EP(v) > 0
                mi = find(pwv==min(pwv),1);
                x(ps(mi),v) = 0;
                pwv(mi) = 2;   % impossible value
                EP(v) = EP(v)-1;
            end
        else
            x(:,v) = random_parent_limitation(EP(v),x(:,v));
        end
    end
end
end