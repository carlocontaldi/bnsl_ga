function [pv] = random_parent_limitation(EP,pv)
% Randomly pick and remove EP parents from the given parent vector pv (dag column).
while EP > 0
    ps = find(pv);              % parent set
    pi = randi(size(ps,1));     % parent index
    pv(ps(pi)) = 0;
    EP = EP-1;
end
end