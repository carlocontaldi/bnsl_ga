function [p] = make_dag(p,MP)
% This function solves the Minimum Feedback Arc Set Problem, reduces
% #parents for each vertex to MP and returns a DAG.
% Ref: https://doi.org/10.1016/0020-0190(93)90079-O
N = size(p,2);
for i=1:N
    %% Determine Quasi-Optimal Vertex Sequence
    todo = 1:size(p{1},1);
    seq1 = [];  seq2 = [];
    while ~isempty(todo)
        brk = 0;
        while brk == 0 && ~isempty(todo)
            dp = sum(p{i}(todo,todo),2);
            m = find(dp==min(dp),1);
            if dp(m)==0
                seq2 = [todo(m) seq2];
                todo = [todo(1:m-1) todo(m+1:end)];
            else
                brk = 1;
            end
        end
        brk = 0;
        while brk == 0 && ~isempty(todo)
            dm = sum(p{i}(todo,todo));
            m = find(dm==min(dm),1);
            if dm(m)==0
                seq1 = [seq1 todo(m)];
                todo = [todo(1:m-1) todo(m+1:end)];
            else
                brk = 1;
            end
        end
        if ~isempty(todo)
            Ddeg = sum(p{i}(todo,todo),2)'-sum(p{i}(todo,todo));
            M = find(Ddeg==max(Ddeg),1);
            seq1 = [seq1 todo(M)];
            todo = [todo(1:M-1) todo(M+1:end)];
        end
    end
    seq = [seq1 seq2];
    %% Remove BackArcs
    ind = 0;
    for j = seq(2:end)
        ind = ind + 1;
        for k = seq(1:ind)
            p{i}(j,k) = 0;
        end        
    end
    %% Constrain Max Fan-in to MP
    p{i} = naive_limit_parents(MP,p{i});
end
end