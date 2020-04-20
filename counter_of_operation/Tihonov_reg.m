function [distribution, flag_opt, regul_param ] = Tihonov_reg(C2_pic, res_matrix, tetta)
% step_alpha = 500;clcl
alpha = 0;
regul_param = 0.75*sqrt(sum((C2_pic).^2));
distribution = zeros(1,length(C2_pic));
flag_opt = 0;
if regul_param == 0 
    return
end
while flag_opt < 35
    F = res_matrix.' * res_matrix  + alpha .* eye(size(res_matrix));
    R = C2_pic*(F\res_matrix.');
    LMz = sqrt(sum((R*res_matrix).^2));
    error_opt = LMz-regul_param;
    if abs(error_opt) < 0.01*regul_param 
        distribution = smooth(R,3);
        return
    end
    alpha = alpha + error_opt*1.65e4;
    flag_opt = flag_opt +1;
end
end

