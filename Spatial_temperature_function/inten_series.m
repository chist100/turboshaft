function [ Temp_rad, plot_str ] = inten_series( radical, Wavenumber, Attitude_I, number_spectrum, plot_num_internal, Step_T, diff_num, diff_denom )
 % Функция находит интеграл интенсивностей серий.
%{
Вход функции:
inten_input - интегрируемый спектр;
Wavenumber - волновое число;
diff_num - серия числителя отношения;
diff_denom - серия знаменателя отношения.
Выход функции:
I_integrals - отношение интегралов интенсивностей серий;
plot_str - Структура для графика.
%}
    %% Нахождение интегралов.
    radical_internal = radical;
    radical_internal(radical_internal < 0) = 0;
    
    Wavenumber_index_denum_start = 19000;
    Wavenumber_index_denum_end = 20000;
    Wavenumber_index_num_start = 17500;
    Wavenumber_index_num_end = 18500;
    
    Index_num_end = find(abs(Wavenumber - Wavenumber_index_num_end) <= 2, 1, 'last' );
    Index_num_start = find(abs(Wavenumber - Wavenumber_index_num_start) <= 2, 1, 'last' );
    Index_denum_end = find(abs(Wavenumber - Wavenumber_index_denum_end) <= 2, 1, 'last' );
    Index_denum_start = find(abs(Wavenumber - Wavenumber_index_denum_start) <= 2, 1, 'last' );
    % Расчет
    Diff_num = abs(Index_num_end - Index_num_start);
    I_nums = zeros(1, Diff_num);
    for W = Index_num_start:Index_num_end
        I_nums(number_spectrum,W-Index_num_start+1) = (radical_internal(number_spectrum,W) + radical_internal(number_spectrum,W+1))/2 * (Wavenumber(W+1)- Wavenumber(W));
    end
    I_num(number_spectrum) = sum(I_nums, 2);
    
    Diff_denum = abs(Index_denum_end - Index_denum_start);
    I_denums = zeros(1, Diff_denum);
    for W = Index_denum_start:1:Index_denum_end
       I_denums(number_spectrum,W-Index_denum_start+1) = (radical_internal(number_spectrum,W) + radical_internal(number_spectrum,W+1))/2 * (Wavenumber(W+1)- Wavenumber(W));
    end
    I_denum(number_spectrum)= sum(I_denums, 2);
    
    I_integrals(number_spectrum) = I_num(number_spectrum)./I_denum(number_spectrum);
    [~, Temp_rad_iternal] = min(abs(Attitude_I(:) - I_integrals(number_spectrum)), [], 1, 'omitnan');
    Temp_rad = (Temp_rad_iternal .* Step_T)';
    plot_str = struct('index_line',[],'power_line',0 , 'I_integrals', 0 );
    power_line_diff = max(radical_internal(plot_num_internal, :))- min(radical_internal(plot_num_internal, :));
    power_line = min(radical_internal(plot_num_internal, :)):power_line_diff/10:max(radical_internal(plot_num_internal, :));
    Wavenumber_line = ones(length(power_line),1);
    plot_str(1).index_line = Wavenumber_line * Wavenumber_index_num_start; 
    plot_str(2).index_line = Wavenumber_line * Wavenumber_index_num_end;
    plot_str(3).index_line = Wavenumber_line * Wavenumber_index_denum_start; 
    plot_str(4).index_line = Wavenumber_line * Wavenumber_index_denum_end;
    plot_str(1).power_line = power_line;
    plot_str(1).I_integrals = I_integrals;
end
