function [ Temperature, spec_C2_plank, plankCurve, spec_CO_plank, inten_wavelength ] = Iterative_Algorithm( plot_num,spec, Wavelength, borders , spec_sizes )
% Функция реализует востановление кривой Планка, а также итерационный метод основанный на отношении интегральных интенсивностей серий
%{
Вход функции:
spec - обрабатываемый спектр;
Wavelength - длинны волн;
Attitude_I - кривая температур;
plot_num - номер отображаемого графика;
borders - границы работы;
Step_T - шаг кривой температур;
delta_num - серия числителя отношения;
delta_denom - серия знаменателя отношения.
Выход функции:
Temperature_str - Структура с измеренными температрами.
%}
    %% Теоретические кривые
    %Границы и шаг расчета кривой температур
    Start_T = 0.1;
    Stop_T = 8000;
    Step_T = 0.1;
    %Расчет кривых различных соотношений
    delta_num_first = 0;
    delta_denom_first = -1;
    [Attitude_I(1,:)] = Temperature_Dependence(Start_T, Stop_T, Step_T, delta_num_first, delta_denom_first );
    delta_num_second = 0;
    delta_denom_second = +1;
    [Attitude_I(2,:)] = Temperature_Dependence(Start_T, Stop_T, Step_T, delta_num_second, delta_denom_second );
    delta_num_third = -1;
    delta_denom_third = +1;
    [Attitude_I(3,:)] = Temperature_Dependence(Start_T, Stop_T, Step_T, delta_num_third, delta_denom_third );

    %% Обработка данных
    number_spectrum = 1:borders(2)-borders(1)+1;
    % Область нормировкки кривой планка и спектра 
    index_of_normig_wave = (size(spec,2)- 50):size(spec,2);
    %Нормировка
    inten_wavelength(number_spectrum,:) = spec(borders(1):borders(2),:)./min(spec(borders(1):borders(2),index_of_normig_wave),[],2);
    Wavenumber = 1./(Wavelength(end:-1:1).*1e-7);
    %% VIEN
    [vienX,vienY, coef_k, vien_indexes, Temperature_Kelvin_Plank_Vine] = VIEN(Wavelength, number_spectrum, inten_wavelength);
    Temperature_Kelvin_Plank = Temperature_Kelvin_Plank_Vine;
    %% Итерационный алгоритм
    %Итерационный алгоритм подбирающий такую температуру Планка, чтобы
    %температура радикалов разных серий сравнялась
    radical_plank = zeros(size(inten_wavelength));
    era = 0;
    figure;
    %Старт итерации
    while era <= 30
        %Востановление кривой Планка
        [ plankCurve ] = Planck_Curve_Recovery( Wavelength, number_spectrum, Temperature_Kelvin_Plank, inten_wavelength, vien_indexes);
        radical_plank(number_spectrum,:)  = inten_wavelength(number_spectrum,:) - plankCurve(number_spectrum,:);
        %Востановление спектра эмиссии СО2
        [spec_CO_plank, radical_min_index] = CO_Emission(radical_plank,Wavelength);
        spec_C2_plank = radical_plank - spec_CO_plank;
        %Поиск температур
        [ Temperature_radical_first, ~ , ~ ] = Transition_Series_Integral( spec_C2_plank, Wavenumber, Attitude_I(1,:), number_spectrum, 1, Step_T, delta_num_first, delta_denom_first );
        [ Temperature_radical_second, ~ , ~ ] = Transition_Series_Integral( spec_C2_plank, Wavenumber, Attitude_I(2,:), number_spectrum, 1, Step_T, delta_num_second, delta_denom_second );
        [ Temperature_radical_third, ~ , ~ ] = Transition_Series_Integral( spec_C2_plank, Wavenumber, Attitude_I(3,:), number_spectrum, 1, Step_T, delta_num_third, delta_denom_third );
        %Ошибка работы итерации
        diff = Temperature_radical_first - Temperature_radical_second;
        %Предел работы алгоритма
        %Предел точности аллгоритма
        diff(abs(diff) < 1.5) = 0;
        %Коэффициент усиления LOSS функции sign(diff)
%         if diff>0
%             LOSS = 0.01.*diff ./ exp(0.0002.*-diff);
%         else
%             LOSS = 0.01.*diff ./ exp(0.0002.*diff);
%         end
        
        LOSS = 0.01.*diff ./ exp(0.0001.*sign(-diff).*diff);
        
        if sum(abs(diff) > 1.5)
            %LOSS функция
            Temperature_Kelvin_Plank = Temperature_Kelvin_Plank + LOSS;
        else
            %Предел работы алгоритма
            disp('drop');
            disp(era);
            break
        end
        era = era + 1;
        %Отображение процесса отработки LOSS функции
        hold on
        plot(diff)
        drawnow
    end
    %Вывод температуры
    Temperature = [Temperature_Kelvin_Plank_Vine Temperature_Kelvin_Plank diff Temperature_radical_first Temperature_radical_second Temperature_radical_third];
    %Построение графиков
%     createfigure(Temperature,Step_T,number_spectrum,spec,Wavelength, Wavenumber,vienX,inten_wavelength,plankCurve,radical_plank,spec_CO_plank,vienY,coef_k,spec_C2_plank,plot_num, Attitude_I, Temperature_Kelvin_Plank, index_of_normig_wave, radical_min_index, spec_sizes)
end
