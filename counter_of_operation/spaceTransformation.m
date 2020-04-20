function [] = spaceTransformation(pname)
%modelingMode
flops(0)
%%
load model_initial.mat res_matrix
%% Подгрузка спектров
oldFolder = cd(pname);
Load_file = zeros(20, 3648);
prename = 'AVST_mesurement_';
for i = 1:20
    Load_name = strcat(prename, string(i), '.csv');
    Load_file(i,:) = load(Load_name);
end
cd(oldFolder)
%% Регуляризация Тихонова
% distribution = zeros(size(Load_file,2),20);
flag_opt = zeros(size(Load_file,2),1);
regul_param = zeros(size(Load_file,2),1);
[~, j ] = max(Load_file(1,900:1100));
i = j + 900;
addflops(1);
for i = 1:size(Load_file,2)
    C2_pic = Load_file(:,i)';
    alpha = 0;
    regul_param(i) = 0.75*sqrt(sum((C2_pic).^2));
    addflops(1 + flops_sqrt + flops_row_sum(size(C2_pic)) + length(C2_pic)*flops_pow(2));
    flag_opt(i) = 0;
    if regul_param(i) == 0 
        return
    end
    while flag_opt(i) < 35
        F = res_matrix.' * res_matrix  + alpha .* eye(size(res_matrix));
        addflops(flops_mul(res_matrix.',res_matrix) + size(res_matrix,1));
        R = C2_pic*(F\res_matrix.');
        addflops(flops_mul(C2_pic,res_matrix) + flops_mul(F,res_matrix) + flops_inv(size(res_matrix,1)));
        LMz = sqrt(sum((R*res_matrix).^2));
        addflops(flops_mul(R,res_matrix) + length(R)*flops_pow(2) + flops_sqrt);
        error_opt = LMz-regul_param(i);
        addflops(1);
        if abs(error_opt) < 0.01*regul_param(i)
%             distribution(i,:) = smooth(R,1);
            return
        end
        alpha = alpha + error_opt*1.65e4;
        addflops(1 + 1)
        flag_opt(i) = flag_opt(i) +1;
        addflops(1)
    end
end

end