function [ Temperature_str ] = Plank_radical_series( spec, Wavelength, Attitude_I, plot_num, borders, Step_T, delta_num, delta_denom,type_plot  )
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

    %% Обработка данных
    number_spectrum = 1:borders(2)-borders(1)+1;
    plot_num_internal  = plot_num - borders(1)+1;
    % Индекс нормировкки кривой планка и спектра 
    index_of_normig_wave = size(spec,2);
%     index_of_normig_wave = 1100; 
    spec_internal(number_spectrum,:) = spec(borders(1):borders(2),:)./spec(borders(1):borders(2),index_of_normig_wave);
    Wavenumber_no_rev = 1./(Wavelength.*1e-7);
    Wavenumber = zeros(1, length(Wavenumber_no_rev));
    for i = 1:fix(length(Wavenumber_no_rev)/2)
        Wavenumber(length(Wavenumber_no_rev)-i+1) = Wavenumber_no_rev(i);
        Wavenumber(i) = Wavenumber_no_rev(length(Wavenumber_no_rev)-i+1);
    end
    if rem(size(Wavenumber_no_rev,2),2) ~= 0
        Wavenumber(i+1) = Wavenumber_no_rev(i+1);
    end
    
    era_mean = 30;
    for J = 1:era_mean
        inten = zeros(number_spectrum(end), size(spec_internal,2));
        for i = 1:fix(size(spec_internal,2)/2)
            inten(number_spectrum, length(spec_internal)-i+1) = spec_internal(number_spectrum, i);
            inten(number_spectrum, i) = spec_internal(number_spectrum, length(spec_internal)-i+1);
        end
        if rem(size(spec_internal,2),2) ~= 0
            inten(number_spectrum, i+1) = spec_internal(number_spectrum, i+1);
        end
        %% Прогнозирование линии Планка
        aprox_indexes = [445,450, 480, 485, 524,530, 570,582, 600, 700, 730, 745];

        [~, aprox_idx_size] = size(aprox_indexes);
        vien_indexes = [];
        for i=1:2:aprox_idx_size
             wave_start = aprox_indexes(i);
             wave_end = aprox_indexes(i + 1);
             index_start = find(abs(Wavelength - wave_start) <= 0.2, 1, 'last' );
             index_end = find(abs(Wavelength - wave_end) <= 0.2, 1, 'last' );
             indexes_segment = index_start:index_end;
             vien_indexes = [vien_indexes, indexes_segment];
        end
        
%        vien_indexes = 1100:size(spec_internal,2);
        % Построение пространста Вина
        vienX = 14388./Wavelength(vien_indexes) .* ones(number_spectrum(end), 1);
        vienY(number_spectrum,:) = log((Wavelength(vien_indexes).^5).*spec_internal(number_spectrum,vien_indexes));
        % Аппроксимация спектра прямыми в координатах Вина
        coef_k = zeros(number_spectrum(end), 2);
        for i = number_spectrum
            coef_k(i,:) = polyfit(vienX(i,:), vienY(i,:), 1);
        end
        % Нахождение температуры по наклону приямой
        Temperature_Kelvin_Plank(number_spectrum,1) = (-1000).*(1./ coef_k(number_spectrum, 1));
        [ plankCurve, average_level ] = plankCurve_func( spec_internal, Wavelength, number_spectrum, Temperature_Kelvin_Plank, index_of_normig_wave);
        inten_clear(number_spectrum,:) = inten(number_spectrum,:) - average_level(number_spectrum);
        radical(number_spectrum,:)  = inten_clear(number_spectrum,:) - plankCurve(number_spectrum,:);
        [ Temperature_radical_start, plot_str ] = inten_series( radical, Wavenumber, Attitude_I, number_spectrum, plot_num_internal, Step_T, delta_num, delta_denom );
        mean_lvl = mean(radical(number_spectrum,3350:3400), 2) + mean(radical(number_spectrum,2980:3030), 2) + mean(radical(number_spectrum,1980:2030), 2);
        for i = number_spectrum
            if mean_lvl(i) > 0 
                spec_internal(i, :) = spec_internal(i,:) - 0.1.*mean_lvl(i);
            else
                spec_internal(i, :) = spec_internal(i,:) + 0.1.*mean_lvl(i);
            end
        end
    end
    % Сохранение температур
    Temperature_radical = Temperature_radical_start-273;
    Temperature_Plank = Temperature_Kelvin_Plank-273;
    Temperature_str = struct( 'T_Plank', 0, 'T_radical', 0, 'T_iterational', [] );
    Temperature_str.T_Plank = Temperature_Plank;
    Temperature_str.T_radical = Temperature_radical;
    %% Итерационный алгоритм нахождения поправки к температуре Планка

    % Количество эпох для поиска решения по радикалам
    Temperature_Kelvin_Plank_iterational = Temperature_Kelvin_Plank;
    num_era = 100;
    for era = 1:num_era
        [ plankCurve_iterational, ~ ] = plankCurve_func( spec_internal, Wavelength, number_spectrum, Temperature_Kelvin_Plank_iterational, index_of_normig_wave);
        radical(number_spectrum,:)  = inten_clear(number_spectrum,:) - plankCurve_iterational(number_spectrum,:);
        [ Temperature_rad, plot_str_iterational ] = inten_series( radical, Wavenumber, Attitude_I, number_spectrum, plot_num_internal, Step_T, delta_num, delta_denom );
        delta_Temperature = abs(Temperature_rad - Temperature_Kelvin_Plank_iterational);
        if sum(delta_Temperature(number_spectrum) > ones(number_spectrum(end),1)) ~= 0
            for i = number_spectrum
                if Temperature_Kelvin_Plank_iterational(i) < Temperature_rad(i)
                    Temperature_Kelvin_Plank_iterational(i) = Temperature_Kelvin_Plank_iterational(i) + delta_Temperature(i).*0.002;
                else
                    Temperature_Kelvin_Plank_iterational(i) = Temperature_Kelvin_Plank_iterational(i) - delta_Temperature(i).*0.002;
                end
            end
        else
             break
        end
    end
    Temperature_str(1).T_iterational = Temperature_rad(number_spectrum)-273;
    %%
    figure
    subplot(2, 2, 1),
    plot(1:length(Temperature_rad), Temperature_rad, 1:length(Temperature_rad), Temperature_Plank)
    grid on
    title(' Температурные измерения ')
    xlabel('Номер отсчета измерения')
    ylabel('Температрура, К')
    legend('Температура согласно итерационному алгоритму','Спрогнозированная температура Планка')
    
    subplot(2, 2, 2),
    plot(1:length(Temperature_rad), Temperature_rad, 1:length(Temperature_rad), Temperature_radical_start)
    grid on
    title('Температурные измерения ')
    xlabel('Номер отсчета измерения')
    ylabel('Температрура, К')
    legend('Температура согласно итерационному алгоритму','Температура согласно сериям радикаов, из спрогназированной кривой Планка')
    
    subplot(2, 2, [3,4]),
    hold on
    plot(Step_T:Step_T:(length(Attitude_I)*Step_T), Attitude_I, 'LineWidth',2)
    plot(Temperature_radical_start(plot_num_internal),plot_str(1).I_integrals(plot_num_internal), 'b--o')
    plot(Temperature_rad(plot_num_internal),plot_str_iterational(1).I_integrals(plot_num_internal),'--gs', 'MarkerSize',10,'MarkerEdgeColor','b')
    grid on
    title('Кривая температур ')
    xlabel('Температрура, К')
    ylabel('Отношение, о. е.')
    %%
    figure
    if strcmp(type_plot,'nm')
        hold on
        subplot(2, 2, [1,2]), 
        plot(Wavelength, inten_clear(plot_num_internal,end:-1:1), Wavelength, plankCurve(plot_num_internal,end:-1:1), Wavelength, plankCurve_iterational(plot_num_internal,end:-1:1), 'LineWidth', 1)
        grid on
        xlabel('Длина волны, нм')
        ylabel('Интенсивность, о.е.')
        title('Метод Планка')
        for i = 1:4
            plot_str(i).index_line = 1e7./(plot_str(i).index_line);
        end
        subplot(2, 2, 4),
        hold on
        plot(Wavelength, inten_clear(plot_num_internal,end:-1:1) - plankCurve(plot_num_internal,end:-1:1))
        plot(plot_str(1).index_line ,plot_str(1).power_line)
        plot(plot_str(2).index_line ,plot_str(1).power_line)
        plot(plot_str(3).index_line ,plot_str(1).power_line)
        plot(plot_str(4).index_line ,plot_str(1).power_line)
        grid on
        xlabel('Длина волны, нм')
        ylabel('Интенсивность, о.е.')
        title('Радикалы')
    elseif strcmp(type_plot,'cm')
        hold on
        subplot(2, 2, [1,2]), 
        plot(Wavelength, inten_clear(plot_num_internal,:), Wavelength, plankCurve(plot_num_internal,:), Wavelength, plankCurve_iterational(plot_num_internal,:), 'LineWidth', 1)
        grid on
        xlabel('Волновое число, см^{-1}')
        ylabel('Интенсивность, о.е.')
        title('Метод Планка')

        subplot(2, 2, 4),
        hold on
        plot(Wavenumber, inten_clear(plot_num_internal,:) - plankCurve(plot_num_internal,:))
        plot(plot_str(1).index_line ,plot_str(1).power_line)
        plot(plot_str(2).index_line ,plot_str(1).power_line)
        plot(plot_str(3).index_line ,plot_str(1).power_line)
        plot(plot_str(4).index_line ,plot_str(1).power_line)
        grid on
        xlabel('Волновое число, см^{-1}')
        ylabel('Интенсивность, о.е.')
        title('Радикалы')
    end
    
    
    subplot(2, 2, 3),
    plot(vienX(plot_num_internal,:), vienY(plot_num_internal,:), vienX(plot_num_internal,:), coef_k(plot_num_internal, 1).*vienX(plot_num_internal,:)+  coef_k(plot_num_internal, 2));
    grid on
    xlabel('')
    ylabel('')
    title('Пространство Вина')
end