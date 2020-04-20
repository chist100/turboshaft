function [I_num_I_denom] = Temperature_Dependence(Start_T, Stop_T, Step_T, delta_num, delta_denom)
% Функция осуществляет расчет кривой зависимости температур от отношения интегральных интенсивностей серий. 
%{
Вход функции:
Start_T - загруженный спектр;
Stop_T - длинны волн, указанные в файле;
Step_T - название файла;
delta_num - серия числителя отношения;
delta_denom - серия знаменателя отношения.
Выход функции:
I_num_I_denom - кривая температур.
%}
    %% Описание констант
    % Коэффициенты Франка-Кондона.
    Frank_Kondan = [7.21e-1 2.221e-1 4.76e-2 8.80e-3 1.50e-3;
        2.51e-1 3.370e-1 2.80e-1 9.99e-2 2.54e-2;
        2.72e-2 3.740e-1 1.38e-1 2.62e-1 1.38e-1;
        8.00e-4 6.590e-2 4.25e-1 4.77e-2 2.11e-1;
        0000000 2.200e-3 1.05e-1 4.45e-1 1.43e-2];
    % Частоты (энергии) переходов.
    % номер столба - уровень на который совершается переход плюс один
    % номер строки - уровень с которого совершается переход плюс один
    Frequency = [19354.781 17739.749 0         0         0;
                 21104.144 19490.226 17898.573 0         0;
                 0         21201.680 19611.372 18043.263 0;
                 0         0         21281.549 19714.855 18170.342;
                 0         0         0         21338.909 0];
        
    % Equilibrium Constants
    Equilibrium_const = [1641.341 11.6580;
        1789.094 17.367];
    % Расчетные переменные
    Start_N = Start_T/Step_T;
    Stop_N = Stop_T/Step_T;
    % Инициализация некоторых матриц
    snum = zeros(1,4);
    sdenom = zeros(1,4);
    num = zeros(1, Stop_N);
    denom = zeros(1, Stop_N);
    %% Расчет
    if delta_num == +1
        num_excited_lvl = 1;
        num_calm_lvl = 0;
    elseif delta_num == -1
        num_excited_lvl = 0;
        num_calm_lvl = 1;
    elseif delta_num == 0
        num_excited_lvl = 0;
        num_calm_lvl = 0;
    else
        disp('Ошибка формата diff_num')
        disp('допустимые форматы: 0, +1, -1')
        return
    end
    if delta_denom == +1
        denom_excited_lvl = 1;
        denom_calm_lvl = 0;
    elseif delta_denom == -1
        denom_excited_lvl = 0;
        denom_calm_lvl = 1;
    elseif delta_denom == 0
        denom_excited_lvl = 0;
        denom_calm_lvl = 0;
    else
        disp('Ошибка формата diff_denom')
        disp('допустимые форматы: 0, +1, -1')
        return
    end
    for N = Start_N:1:Stop_N
        T = N * Step_T;
        %Расчет уравнений интенсивности для трех переходов каждой серии
        for state = 0:1:3
            number_table = state +1;
            factor_exp_num = (Frequency(number_table + num_excited_lvl, number_table + num_calm_lvl))^4 * (Frank_Kondan(number_table + num_excited_lvl, number_table + num_calm_lvl));
            exp_num = exp(-1.4388*((Equilibrium_const(2, 1))*(state + num_excited_lvl)-(Equilibrium_const(2, 2))*(state + num_excited_lvl)^2-(Equilibrium_const(2, 2))*(state + num_excited_lvl))/(T));
            snum(number_table) = factor_exp_num * exp_num;
            
            factor_exp_denom = (Frequency(number_table + denom_excited_lvl, number_table + denom_calm_lvl))^4 * (Frank_Kondan(number_table + denom_excited_lvl, number_table + denom_calm_lvl));
            exp_denom = exp(-1.4388*((Equilibrium_const(2, 1))*(state + denom_excited_lvl)-(Equilibrium_const(2, 2))*(state + denom_excited_lvl)^2-(Equilibrium_const(2, 2))*(state + denom_excited_lvl))/(T));
            sdenom(number_table) = factor_exp_denom * exp_denom;
        end
        denom(N) = sum(sdenom);
        num(N) = sum(snum);
        % Пояснения по алгоритму находятся в файле "temperature_function_notation"
    end
    % Отношение интенсивности двух серий
    I_num_I_denom = (num./denom);
end
