function [data] = acquire_data(str,D,T,gen_new_data,bnet)
% Acquire experimental datasets from newly generated or existing data.
n = size(bnet.dag,1);   % #nodes
if gen_new_data     % generate new test case
    data = cell(1,T);
    for t=1:T
        data{t} = zeros(n,D);
        for i=1:D
            sample = sample_bnet(bnet);
            data{t}(:,i) = [sample{:}];
        end
    end 
    eval([str,'=data;']);
    save([str '.mat'],str);
else                % load pre-generated test case
    data = load(str);
    data = data.(str);
end
end