%% Загрузка и обработка данных
clc 
clear
close all
pname = '\\smb.fitos.org\gtd\\!Люлька\Испытания 06_06_2019\trials_su_27\AVST\afterburner';
[ spec_input, wavelength_input,  File_name_plot ] = download_file( pname );
[ spec, Wavelength ] = hardware_error( spec_input, wavelength_input );
%% Расчет кривой температур для соотношения интенсивностей серий переходов
% Отношение каких серий рассматриваем
delta_num = -1;
delta_denom = 0;
% Параметры построения кривой температур 
Start_T = 0.1;
Stop_T = 6000;
Step_T = 0.1;
[Attitude_I] = temperature_function(Start_T, Stop_T, Step_T, delta_num, delta_denom );
%% Радикал Планк
% Номер отображаемого графика
borders = [1 size(spec,1)];
type_plot = 'nm'; % nm cm
plot_num = 2;
[ Temperature_str ] = Plank_radical_series( spec, Wavelength, Attitude_I, plot_num, borders, Step_T, delta_num, delta_denom,type_plot );