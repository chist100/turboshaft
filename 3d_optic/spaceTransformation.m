function [distribution, ligth_start_coordX, Wavelenghts, flag_opt, res_matrix, error_opt, alpha, regul_param, error_tix, Load_file] = spaceTransformation(pname, modelingMode, tetta)
%modelingMode
if modelingMode == 1 && modelingMode == 0
    error('modelingMode is not boolean. Try change input values');
end
%pname
pname = convertStringsToChars(pname);
if ~ischar(pname)
    error('description is not string or char. Try change input values');
end
%%
if modelingMode 
    number_nodes = 20;
    error_position = 0;
    savingMode = 0;
    description = '';
    mode_flame = 'equable';
    [~, res_matrix, ligth_start_coordX] = race_tracing(number_nodes, error_position, savingMode, description, mode_flame);
else
    load model_initial.mat res_matrix ligth_start_coordX
end

%% Подгрузка спектров
oldFolder = cd(pname);
Load_file = zeros(20, 3648);
prename = 'AVST_mesurement_';
for i = 1:20
    Load_name = strcat(prename, string(i), '.csv');
    Load_file(i,:) = load(Load_name);
end
Wavelenghts = load('Wavelenghts.csv');
cd(oldFolder)

tic
% Load_file = Load_file(:,1500);
% 
% prediktion_L2 = zeros(size(Load_file,2),1);
% prediktion_param = 0.75*sqrt(sum((Load_file).^2));
% prediktion_R = Load_file'*((res_matrix.' * res_matrix)\res_matrix.');
% for i = 1:size(prediktion_R,1)
%     prediktion_L2(i) = sqrt(sum((prediktion_R(i,:)*res_matrix).^2));
% end
% Fisrt_opt = prediktion_L2-prediktion_param';
% load Preposition f serror
% [~, IpreAlpha] = min(abs(Fisrt_opt-serror'),[],2);
% preAlpha = f(IpreAlpha);


%% Регуляризация Тихонова

distribution = zeros(size(Load_file,2),20);
flag_opt = zeros(size(Load_file,2),1);
regul_param = zeros(size(Load_file,2),1);
error_opt = zeros(size(Load_file,2),tetta);
alpha = zeros(size(Load_file,2),tetta);
error_tix = zeros(size(Load_file,2),1);



% [~, j ] = max(Load_file(1,900:1100));
% i = j + 900;
% Load_file = Load_file(:,i);

% figure
% h = animatedline;
% step_tau = 1.65e4;
step_tau = 20e3;
for i = 1:size(Load_file,2)
    [distribution(i,:), flag_opt(i), regul_param(i), error_opt(i,:), alpha(i,:), error_tix(i)] = Tihonov_reg(Load_file(:,i)', res_matrix, tetta, step_tau);%, preAlpha(i));
%     addpoints(h,i,flag_opt(i));
%     drawnow limitrate
end
% for j = 1:1:10
%     step_tau = j*1000+15000;
% 	for i = 1:size(Load_file,2)
%         [distribution(i,:), flag_opt(i,j), ~, ~, ~, ~] = Tihonov_reg(Load_file(:,i)', res_matrix, tetta, step_tau);
%     end
%     flag_opt = sum(flag_opt,1);
% end
% distributionv = zeros(size(Load_file,2),20);
% for i = 1:size(Load_file,2)
%     distributionv(i,:) = Load_file(:,i)'/res_matrix;
% end

toc
end