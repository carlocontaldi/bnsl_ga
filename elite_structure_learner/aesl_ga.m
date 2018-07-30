% Adaptive Elite-based Structure Learner using GA
function [dag,sc_star,conv,last_gen] = aesl_ga(ss,data,N,M,MPmax,alpha,d,scoring_fn,bnet)
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
max_time = get_max_time(n);
start = cputime;        % tic
N2 = bitsll(N,1);       % population size before selection
cache_dim = 256*n;
cache = score_init_cache(n,cache_dim);
dm = d.m0;              dM = d.M0;  % time-sensitive healthy diversity interval
dms = (d.m1-d.m0)/M;    dMs = (d.M1-d.M0)/M;
[p,l_map,l_cnt] = init_population(ss,N2);
p = make_dag_naive(p,MPmax);   % Make-DAG & Naive-Limit-Parents
MP = repmat(MPmax,1,n);        % dynamic MP thresholds array init
pwm = ones(l_cnt,3)/3;  % uniform pwm
[score, cache] = score_dags(data,ns,p,'scoring_fn',scoring_fn,'cache',cache);
[x_star,sc_star] = get_elite(score,p); % Get-Elite-Individual
%% Main Loop
for i=1:M
    if cputime-start > max_time   % toc
        last_gen = i;
        [sc_star,conv] = finalize_output(x_star,data,bnet,scoring_fn,M,conv,last_gen);
        break;
    end
    [norm_score,sum_norm_score] = normalize(score,sc_star,true);
    if ~isempty(find(norm_score,1))     % all individuals are not the same
        [p2,score2] = proportional_selection(N,N2,p,score,norm_score,sum_norm_score);
        p2 = uniform_crossover(N,p2,l_map);
        p2(N+1:N2) = make_dag_elite(p2(N+1:N2),MP,l_map,pwm); % Make-DAG & Elite-Guided-Limit-Parents
        [score2(N+1:N2),cache] = score_dags(data,ns,p2(N+1:N2),'scoring_fn',scoring_fn,'cache',cache);
        [x_star2,sc_star2] = get_elite(score2,p2);
        norm_score2 = normalize(score2,sc_star2,false);
        [es,e_score] = form_elite_set(alpha,N2,p2,norm_score2);
        alpha = update_alpha(l_map,x_star2,es,alpha,dm,dM);
        pwm = construct_pwm(l_cnt,e_score,es,ss);
    else
        p2 = p;
        norm_score2 = norm_score;
        pwm = ones(l_cnt,3)/3;  % uniform pwm
    end 
    p = sirg_mutation(N2,l_map,p2,norm_score2,pwm);
    MP = update_mp(MP,MPmax,es);
    p = make_dag_elite(p,MP,l_map,pwm);
    [score,cache] = score_dags(data,ns,p,'scoring_fn',scoring_fn,'cache',cache);
    [x_star,sc_star,p,score] = update_elite(x_star,sc_star,p,score);   % Get&Place-Elite-Individual
    conv = update_conv(conv,x_star,sc_star,bnet.dag,i);
    dm = dm+dms;    dM = dM+dMs;    % healthy diversity interval update
end
dag = {x_star};
end
