%% Bayesian network hybrid learning using an elite-guided genetic algorithm
% Ref: https://doi.org/10.1007/s10462-018-9615-5
%% Init
% Uncomment algo & bnet of your choice, then set parameters as needed.
% Input
%   data - T instances of n-by-D dataset, a numeric matrix of D n-sized samples
% Output
%   eoer - End Of Execution Results
%   conv - Convergence Behavior structure
algo = 'ESL_GA';            % Elite-based Structure Learner using GA
% algo = 'AESL_GA';         % Adaptive Elite-based Structure Learner using GA
bnet = mk_asia_bnet;        dataset = 'ASIA';   net = 'AS';
% bnet = mk_insur_bnet;     dataset = 'INS';    net = 'IN';
% bnet = mk_alarm_bnet;     dataset = 'ALARM';  net = 'AL';
% bnet = mk_hepar2_bnet;	dataset = 'HEPAR';  net = 'HE';
% bnet = mk_win95pts_bnet;	dataset = 'WIN';    net = 'WI';
D = 50;                     % dataset size
gen_new_data = true;        % if true generate data, else load existing data
N = 100;                    % population size
M = 100;                    % max #iterations
MP = 4;                     % max fan-in (max #parents)
T = 20;                     % #trials
tol = 0.01;                 % CI test threshold for CB phase
scoring_fn = 'bayesian';    % scoring function for S&S phase
alpha = 0.5;                % elite eligibility threshold
d = struct('m0',1/5,'M0',3/5,'m1',1/10,'M1',1/2);   % healthy diversity interval
fprintf('Running... %s_%s%s - N=%s M=%s P=%s [%s]\n',...
    algo,net,num2str(D),num2str(N),num2str(M),num2str(MP),datestr(now));
fprintf('Iter   F1 Score  Sensitivity  Specificity    Bayes Score     Exe Time  #Generations\n');
n = size(bnet.dag,1);       % #nodes
cache = score_init_cache(n,256*n);
eoer = cell(T,1);           % end-of-execution results
conv(1:T) = struct('f1',zeros(1,M),'se',zeros(1,M),'sp',zeros(1,M),'sc',zeros(1,M));   % convergence behavior
str = sprintf('%s%s',dataset,num2str(D));
data = acquire_data(str,D,T,gen_new_data,bnet);
bnet.dag = logical(bnet.dag);   % double2boolean DAG conversion
format shortG
%% Execution
for t = 1:T
    eoer{t} = -1*ones(1,6);
    start = cputime;                % tic
    ss = mutual_dependencies(data{t}',bnet,tol);    % CB Phase
    if strcmp(algo,'ESL_GA')                        % S&S Phase
        [dag,eoer{t}(1,4),conv(t),eoer{t}(1,6)] = esl_ga(ss,data{t},N,M,MP,alpha,d,scoring_fn,bnet);   
    else
        [dag,eoer{t}(1,4),conv(t),eoer{t}(1,6)] = aesl_ga(ss,data{t},N,M,MP,alpha,d,scoring_fn,bnet);
    end
    eoer{t}(1,5) = cputime-start; % toc
    [eoer{t}(1,1),eoer{t}(1,2),eoer{t}(1,3)] = eval_dags(dag,bnet.dag,1);
    fprintf('%4d  %9.5f    %9.5f    %9.5f    %11.3f  %11.3f      %4d\n',...
        t,eoer{t}(1),eoer{t}(2),eoer{t}(3),eoer{t}(4),eoer{t}(5),eoer{t}(6));
end
%% End Of Execution Results
filename = sprintf('eoer_%s%s_%s_%s_%s_%s',net,num2str(D),num2str(N),num2str(M),num2str(MP),algo);
save(filename,'eoer');
[eoer_avg, eoer_std] = avg_std(eoer,T);
print_avg_std(eoer_avg,eoer_std);
%% Convergence Behavior
conv_avg = struct;
fn = fieldnames(conv);
for f=1:numel(fn)
    conv_avg.(fn{f}) = sum(cat(M,conv.(fn{f})),M)/T;
end
filename = sprintf('conv_%s%s_%s_%s_%s_%s',net,num2str(D),num2str(N),num2str(M),num2str(MP),algo);
save(filename,'conv_avg');