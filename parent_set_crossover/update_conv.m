function [conv] = update_conv(conv,x,sc,target_dag,i)
% Update convergence behavior structure.
[f1,se,sp] = eval_dags({x},target_dag,1);
conv.f1(1,i) = conv.f1(1,i) + f1;
conv.se(1,i) = conv.se(1,i) + se;
conv.sp(1,i) = conv.sp(1,i) + sp;
conv.sc(1,i) = conv.sc(1,i) + sc;
end