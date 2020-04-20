function [spec_CO, radical_min_index] = CO_Emission(radical,Wavelength)
% Моделирование спеткра эмиссии СО2
    spec_CO = zeros(size(radical));
    for J = 1:size(radical,1)
        %Переменные моделирования спектра CO
        %Длина волны максимума интенсивности
        Wavenumber_max = 330;
        %Параметр экстенты (степень концетрации энергии в области длины
        %волны максимума интенсивности
        W = 70;
        %Моделирование спектра
        spec_CO_local(:) = exp(-exp(((-Wavelength+Wavenumber_max))/W)-(Wavelength-Wavenumber_max)/W+1);
        %Поиск индекса и амплитуды точки нормировки
        [radical_min, radical_min_index] = min(radical(J,220:240));
        radical_min_index = radical_min_index + 220;
        %Нормировка
        spec_CO(J,:) = spec_CO_local(:)./spec_CO_local(radical_min_index).*radical_min;
    end
end