function [f1,se,sp] = eval_dags(dags,dag0,N)
% Get F1 score, Sensitivity and Specificity for a set of DAGs wrt DAG0 (target_dag).
n = size(dag0,1);
totP0 = 0;      % #oriented_edges in dag0
totN0 = 0;      % #absent_edges in dag0
for j = 1:n
    for k = j:n
        if xor(dag0(j,k),dag0(k,j))
            totP0 = totP0+1;
        else
            totN0 = totN0+1;
        end
    end
end
f1 = zeros(1,N);
se = zeros(1,N);
sp = zeros(1,N);
for i = 1:N
    matchP = 0;     % TP: #matching_oriented_edges in dag
    matchN = 0;     % TN: #matching_absent_edges in dag
    totP = 0;       % P: #oriented_edges in dag
    totN = 0;       % N: #absent_edges in dag
    for j = 1:n
        for k = j:n
            jk = dags{i}(j,k);  kj = dags{i}(k,j);
            if xor(jk,kj)
                totP = totP+1;
            else
                totN = totN+1;
            end
            if jk==dag0(j,k) && kj==dag0(k,j)
                if jk==0 && kj==0
                    matchN = matchN+1;
                else
                    matchP = matchP+1;
                end
            end
        end
    end
    if totP0==0
        se(i) = 1;    % if true dag is null, sensitivity is 1
    else
        se(i) = matchP/totP0;    % TP/totP0
    end
    if totP == 0
        pr = 1;       % if predicted dag is null, precision is 1
    else
        pr = matchP/totP;         % TP/totP
    end
    if totN0 == 0
        sp(i) = 1;    % if true dag is complete, specificity is 1
    else
        sp(i) = matchN/totN0;    % TN/totN0
    end
    if pr+se(i) == 0
        f1(i) = 0;
    else
        f1(i) = 2*pr*se(i)/(pr+se(i));
    end
end
end