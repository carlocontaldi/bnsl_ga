function [eoer_avg,eoer_std] = avg_std(eoer,T)
% Compute mean and standard deviation over a set of T trials.
Sx = size(eoer{1},1); Sy = size(eoer{1},2);
eoer_avg = zeros(Sx,Sy); eoer_cnt = zeros(Sx,Sy);
for i = 1:T
    for j = 1:Sx
        for k = 1:Sy
            if eoer{i}(j,k) ~= -1
                eoer_avg(j,k) = eoer_avg(j,k) + eoer{i}(j,k);
                eoer_cnt(j,k) = eoer_cnt(j,k) + 1;
            end
        end
    end
end
eoer_avg = eoer_avg./eoer_cnt;
eoer_std = zeros(Sx,Sy);
for i = 1:T
    for j = 1:Sx
        for k = 1:Sy
            if eoer{i}(j,k) ~= -1
                eoer_std(j,k) = eoer_std(j,k) + power(eoer{i}(j,k)-eoer_avg(j,k),2);
            end
        end
    end
end
eoer_std = realsqrt(eoer_std./eoer_cnt);
end