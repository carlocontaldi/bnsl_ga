function [max_time] = get_max_time(n)
% Get maximum CPU time allotted for execution, based on network size.
if n<10
    max_time = 200;
elseif n<20
    max_time = 600;
elseif n<30
    max_time = 2000;
elseif n<40
    max_time = 4000;
elseif n<60
    max_time = 8000;
elseif n<80
    max_time = 12000;
else
    max_time = 36000;
end
end