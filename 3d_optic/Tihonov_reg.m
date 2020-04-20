function [distribution, flag_opt, regul_param, error_opt, alpha, error_tix] = Tihonov_reg(C2_pic, res_matrix, stop_flag, step_tau)%, preAlpha)
alpha = zeros(stop_flag,1);
% alpha(1) = preAlpha;
regul_param = 0.75*sqrt(sum((C2_pic).^2));
flag_opt = 1;
error_opt = zeros(stop_flag,1);
error_tix = 0;
if regul_param == 0 
    return
end
% alpha = 0:0.01:1000;
% R = zeros(size(alpha,2),20);
% stop_flag = size(alpha,2);          
while flag_opt < stop_flag
    F = res_matrix.' * res_matrix  + alpha(flag_opt) .* eye(size(res_matrix));
    R = C2_pic*(F\res_matrix.');
    LMz = sqrt(sum((R*res_matrix).^2));
    error_opt(flag_opt) = LMz-regul_param;
    if abs(error_opt(flag_opt)) < 0.01*regul_param
        error_tix = error_opt(flag_opt);
        distribution = R;
        return
    end
    alpha(flag_opt+1) = alpha(flag_opt) + error_opt(flag_opt)*step_tau;%1000*sign(error_opt(flag_opt));%%*1.65e4; %1000*sign(error_opt(flag_opt)); 
    flag_opt = flag_opt +1;
end
distribution = R;
end

