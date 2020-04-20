%%
clc 
clear all
close all
%% Загрузка аппаратной функции системы
saphire = load('D:\VGuryev\Work\ГТД\Experimetns LULKA\Отчет по Люльке\ГП\3пуск\models\shift_spec_radicals.mat');
saphire = saphire.saphire_ratio_shifted;
%% Загрузка длин волн
wavelength = load('D:\VGuryev\Work\ГТД\Experimetns LULKA\Отчет по Люльке\ГП\3пуск\models\waves.mat');
wavelength = wavelength.waves;
%% Загрузка спектров
% spec_inten = load('D:\VGuryev\Work\ГТД\Experimetns LULKA\Отчет по Люльке\ГП\1пуск\models\spec_inten.mat');
spec_inten = load('D:\VGuryev\Work\ГТД\Experimetns LULKA\Отчет по Люльке\ГП\3пуск\models\spec_intenses.mat');
% spec_inten = spec_inten.spec_inten;
spec_inten = spec_inten.spec_inten_shifted;

%% Учет аппаратной функции системы
for J = 1:5
    spec_inten_norm(J,:) = spec_inten(J,:)./saphire;
end
%% проверка визуализацией
figure; hold on;
for i=1:5
    plot(wavelength, spec_inten_norm(i,:));
    plot(wavelength, spec_inten(i,:));
end

%% Выбор окон для Вина
% ud = get(gco);
% base = ud.YData;

i = 5; %номер графика из загруженных для анализа
 spec_Wine = spec_inten_norm(i, :);
%  spec_Wine = smooth(base, 20)';
vien_indexes = [];
 aprox_indexes = [440,442, 477, 478, 520,521, 567,568];
% aprox_indexes = [520,710];
[unused_var, aprox_idx_size] = size(aprox_indexes);
for i=1:2:aprox_idx_size
     wave_start = aprox_indexes(i);
     wave_end = aprox_indexes(i + 1);
     index_start = find(abs(wavelength - wave_start) <= 0.2, 1, 'last' );
     index_end = find(abs(wavelength - wave_end) <= 0.2, 1, 'last' );
     indexes_segment = index_start:index_end;
     vien_indexes = [vien_indexes, indexes_segment];
end

%% Нормировка спектра
norming_wave = 745;
index_of_normig_wave = find(abs(wavelength(:) - norming_wave) <= 0.1, 1, 'last' );

spec_Wine_plot = spec_Wine;
spec_Wine_plot = spec_Wine./spec_Wine(index_of_normig_wave);

%% Пересчет в координаты Вина тех окон, которые были выбраны оператором ЭВМ
vienX = 14388./wavelength(vien_indexes(:));
vienY = log((wavelength(vien_indexes(:)).^5).*spec_Wine_plot(vien_indexes(:)));

% figure; hold on;
% plot(vienX, vienY);
% vienY = smooth(vienY, 1500)';
%% Аппроксимируем спектры прямыми в координатах Вина
coef_k = polyfit(vienX, vienY, 1);
%по полученным коэффициентам прямых k находим температуры cо спектров
TK = (-1000)*(1/ coef_k(1)); %% degrees Kelvin
TC = TK - 273;
% Отрисовка графика
figure
plot(vienX, vienY, vienX, (vienX* coef_k(1) + coef_k(2)));
grid on

%% Создание модели Планка
figure;grid on; hold on;
plot(wavelength, 4*spec_Wine_plot .* spec_Wine(index_of_normig_wave) ./ 1000,'LineWidth',1);

b = TK;
for i =1:10
    TK = b - i * 0.05e+03;
    expPlank = exp(-(6.63*3/1.38).*(10^6).*(1./(wavelength.*TK)));
    plankCurve = (1./wavelength.^5).*(expPlank./(1-expPlank));
    plankCurve = plankCurve./ plankCurve(index_of_normig_wave);

    %% Отрисовка графика
    plot(wavelength, plankCurve .* spec_Wine(index_of_normig_wave) ./ 1000 - 0.01,'LineWidth',1);

    p(1).LineWidth = 2;
    xlabel('Длина волны, нм')
    ylabel('Интенсивность, о.е.')
    legend('Эксперимент','Модель');
end



