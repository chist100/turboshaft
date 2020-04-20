function [vienX,vienY, coef_k, vien_indexes, Temperature_Kelvin_Plank_Vine] = VIEN(Wavelength, number_spectrum, inten_wavelength)
%Нахождение температуры в прастранстве вина.
    aprox_wavelength = [570:585, 600:700, 730:745];
    vien_indexes = zeros(length(aprox_wavelength),1);
    for i = 1:length(aprox_wavelength)
        [~,vien_indexes(i)] = min(abs(Wavelength-aprox_wavelength(i)));
    end
    % Построение пространста Вина
    vienX = 14388./Wavelength(vien_indexes) .* ones(number_spectrum(end), 1);
    vienY(number_spectrum,:) = log((Wavelength(vien_indexes).^5).*inten_wavelength(number_spectrum,vien_indexes));
    % Аппроксимация спектра прямыми в координатах Вина
    coef_k = zeros(number_spectrum(end), 2);
    for i = number_spectrum
        coef_k(i,:) = polyfit(vienX(i,:), vienY(i,:), 1);
    end
    % Нахождение температуры по наклону приямой
    Temperature_Kelvin_Plank_Vine(number_spectrum,1) = (-1000).*(1./ coef_k(number_spectrum, 1));
end

