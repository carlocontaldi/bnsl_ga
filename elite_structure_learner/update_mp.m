function [MP] = update_mp(MP,MPmax,es)
% Update the MP thresholds in an elite-based, knowledge-driven approach.
n = size(MP,2);
esp = cell(1,n); % #distinct parent nodes of each vertex over all elite individuals
for e = 1:size(es,2)
    for i = 1:n
        p = find(es{e}(:,i))';
        esp{i} = unique([esp{i} p]);
    end
end
for i = 1:n
    S = 1 + size(esp{i},2);     % safety threshold
    if MP(i) > S
        MP(i) = MP(i)-1;
    elseif MP(i) < min(S,MPmax)
        MP(i) = MP(i)+1;
    end
end 
end