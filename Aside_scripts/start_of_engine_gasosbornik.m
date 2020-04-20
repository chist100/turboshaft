clc
clear all
close all

% открываем файл с данными от Сатурна
[fname, pname] = uigetfile({'*.xlsx*'},'File Selector', 'MultiSelect', 'off');
filename = strcat(pname,fname);
datetime.setDefaultFormats('default','hh:mm:ss');
opts = detectImportOptions(filename);
opts = setvartype(opts,'srvtime','datetime');
saturnData = readtable(filename, opts);

%забираем нужные данные от Сатурна
%------------------time-------------ak
%------------------t_19_1-----------t_19_2-----------t_19_3-------------t_19_4------------t_19_5------ 
%------------------t_20_1-----------t_20_2-----------t_20_3-------------t_20_4------------t_20_5------
%------------------t_21_1-----------t_21_2-----------t_21_3-------------t_21_4------------t_21_5------
%------------------t_22_1-----------t_22_2-----------t_22_3-------------t_22_4------------t_22_5------ 
%------------------t_23_1-----------t_23_2-----------t_23_3-------------t_23_4------------t_23_5------
mergedData = [saturnData(:,2), saturnData(:,175),...
              saturnData(:,80), saturnData(:,85), saturnData(:,90), saturnData(:,95), saturnData(:,100),...
              saturnData(:,78), saturnData(:,83), saturnData(:,88), saturnData(:,93), saturnData(:,98),...
              saturnData(:,76), saturnData(:,81), saturnData(:,86), saturnData(:,91), saturnData(:,96),...
              saturnData(:,99), saturnData(:,94), saturnData(:,89), saturnData(:,84), saturnData(:,79),...
              saturnData(:,97), saturnData(:,92), saturnData(:,87), saturnData(:,82), saturnData(:,77)];
mergedDataArray = table2cell(mergedData);
          
%открываем сразу все файлы спектров
[fname, pname] = uigetfile({'*.dat*'},'File Selector', 'MultiSelect', 'on');
[A,numberOfAvestaFiles] = size(fname);

for i = 1:numberOfAvestaFiles
    filename = strcat(pname,char(fname(i)));
    avestaFileName = char(fname(i));
    avestaTime = datetime(avestaFileName(12:19),'Format','hh.mm.ss');
    % различие по времени между сервером и ноутбуком 5 минут и 52 секунды
    avestaTimeShiftedToSaturnTime = avestaTime - seconds(352);
    avestaData = importdata(filename);
    wavelengthAvesta = avestaData(1, :);
    [row, col] = find(hour(mergedData.srvtime) == hour(avestaTimeShiftedToSaturnTime) &...
                      minute(mergedData.srvtime) == minute(avestaTimeShiftedToSaturnTime) &...
                      second(mergedData.srvtime) == second(avestaTimeShiftedToSaturnTime));
    [avestaDataRow, avestaDataCol] = size(avestaData);
    for j = 0:avestaDataRow-2
       for k = 1:avestaDataCol
            mergedDataArray{row+j,27+k} = avestaData(j+2,k); 
       end
    end 
end

[mergedDataArrayRow,mergedDataArrayCol] = size(mergedDataArray);
finalDataCounter = 0;
for i = 1:mergedDataArrayRow
    emptyFlag = isempty(mergedDataArray{i,28});
    if emptyFlag == 0 
        finalDataCounter = finalDataCounter + 1;
        for k = 1:mergedDataArrayCol
            finalDataArray{finalDataCounter,k} = mergedDataArray{i,k};
        end
    end 
end

plotedData = cell2mat(finalDataArray(:,2:3675));
avestaDataClear = plotedData(:, 27:end);

%окно сглаживания
app_index = 20;

%подгружаем файл спектральной кривой attenuation, вычисленной в скрипте coef_of_osnastka
p = load('D:\VGuryev\Work\ГТД\Кривая пропускания сапфира\attenuation.txt');
p = p';
norming_wave = 700;
index_of_normig_wave = max(find(abs(wavelengthAvesta(:) - norming_wave) <= 0.1));

%% Работа с 800 спектрами
[m n] = size(avestaDataClear);
for i=1:m
    %сглаживаем все спектры
    avestaDataClear(i, :) = smooth(avestaDataClear(i, :), app_index);
    %нормируем сатурновские спектры относительно norming_wave
    avestaDataClear(i, :) = avestaDataClear (i, :) ./ avestaDataClear (i, index_of_normig_wave);
    for j=1:n
        %делим все спектры на поправочный коэффициент оснастки
        avestaDataClear(i, j) = avestaDataClear (i, j) ./ p (j);
        %находим координаты Вина для наших спектров
        vienX(j) = 14388/wavelengthAvesta(j);
        vienY(i,j) = log((wavelengthAvesta(j)^5).*avestaDataClear(i,j));
    end
end
 plot(vienX,vienY(230,:));

%% Аппроксимируем 800 спектров прямыми в координатах Вина
approx_start = 1; 
approx_end = 3500;
for i = 1:m
    coef_k(i, :) = polyfit(vienX(1,approx_start:approx_end), vienY(i,approx_start:approx_end), 1);
end

%по полученным коэффициентам прямых k находим температуры cо спектров
for i=1:m
    T(i) = (-1000)*(1/ coef_k(i, 1)); %% degrees Kelvin
end

for i=1:m
    for j= 1:n
        expPlank(i,j) = exp(-(6.63*3/1.38)*(10^6)*(1/(wavelengthAvesta(j)*T(i))));
        plankCurve(i,j) = (1/wavelengthAvesta(j)^5)*(expPlank(i,j)/(1-expPlank(i,j)));
    end
end
for i=1:m
    plankCurve(i,:) = plankCurve(i,:) ./ plankCurve(i,index_of_normig_wave);
end
t = 200;
 plot(plankCurve(t,:)); hold on;
 plot(avestaDataClear(t,:)); plotedData(t, 27:end) = plotedData(t, 27:end) ./ plotedData(t, 27 + index_of_normig_wave);
 plot(plotedData(t, 27:end));

figure; hold on;
xlabel('Номер отсчета', 'FontSize', 20);
ylabel('Температура, C', 'FontSize',20);
plot(plotedData(150:end,7));
plot(T(1,150:end) - 1450);





 