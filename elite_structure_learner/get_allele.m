function [l_val] = get_allele(e1,e2)
% Get allele value from edge state.
if ~e1 && ~e2
    l_val = 1;
elseif ~e1 && e2
    l_val = 2;
else % if e1 && ~e2
    l_val = 3;
end
end