function [dag,sc_star,conv,last_gen] = std_ga_psx(ss,data,N,M,MP,scoring_fn,bnet)
% Standard GA implementing Parent Set Crossover
%% Init
n = size(bnet.dag,1);   % #nodes
ns = bnet.node_sizes;   % node sizes
conv = struct('f1',zeros(1,M),'se',zeros(1,M),'sp',zeros(1,M),'sc',zeros(1,M));
last_gen = M;           % #generations completed in the allotted time
if isempty(find(ss,1))  % input ss has no edges
    [sc_star,conv] = finalize_output(ss,data,bnet,scoring_fn,M,conv,1);
    dag = {ss};
    return
end
max_time = get_max_time(n); % get max allotted cpu time
start = cputime;    % tic
N2 = bitsll(N,1);   % population size before selection
cache_dim = 256*n;
cache = score_init_cache(n,cache_dim);
[p,l_map] = init_population(ss,N2);
p = make_dag(p,MP);     % Make-DAG & Limit-Parents
[score,cache] = score_dags(data,ns,p,'scoring_fn',scoring_fn,'cache',cache);
[x_star,sc_star] = get_elite(score,p);  % Get-Elite-Individual
%% Main Loop
for i=1:M
    if cputime-start > max_time   % toc
        last_gen = i;
        [sc_star,conv] = finalize_output(x_star,data,bnet,scoring_fn,M,conv,last_gen);
        break;
    end
    [norm_score, sum_norm_score] = normalize(score,sc_star,true);
    if ~isempty(find(norm_score,1)) % all individuals are not the same
        p2 = proportional_selection(N,N2,p,score,norm_score,sum_norm_score);
        p2 = parent_set_crossover(N,p2);
        p2(N+1:N2) = make_dag(p2(N+1:N2),MP);
    else
        p2 = p;
    end
    p = bitflip_mutation(N2,l_map,p2);
    p = make_dag(p,MP);
    [score, cache] = score_dags(data,ns,p,'scoring_fn',scoring_fn,'cache',cache);
    [x_star,sc_star,p,score] = update_elite(x_star,sc_star,p,score);   % Get&Place-Elite-Individual
    conv = update_conv(conv,x_star,sc_star,bnet.dag,i);
end
dag = {x_star};
end