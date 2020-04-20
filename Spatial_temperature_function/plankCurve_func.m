function [ plankCurve_out, average_level ] = plankCurve_func( spec, Wavelength, number_spectrum, TK, index_of_normig_wave )
% Функция осуществляет востановление нормализованной кривой Планка, по температуре.
%{
Вход функции:
spec - спектр с аппаратными ошибками;
wavelength - длинны волн с аппаратными ошибками;
TK - температура;
index_of_normig_wave - индекс, по которому происходит нормирование.
Выход функции:
plankCurve_out - спектр Планка;
average_level - средний уровень засветки спектра.
%}
    %% Востановление кривой Планка
    wavelength_internal = Wavelength .* ones(number_spectrum(end), 1);
    wavelength_average_start = 442;
    wavelength_average_end = 448;
    index_average_start = find(abs(Wavelength - wavelength_average_start) <= 0.2, 1, 'last' );
    index_average_end = find(abs(Wavelength - wavelength_average_end) <= 0.2, 1, 'last' );
    average_level = mean(spec(number_spectrum,index_average_start:index_average_end), 2);
    C = 6.625176*2.99792458e6/1.380662;
    average_level = zeros(size(average_level));
    plankCurve_internal(number_spectrum, :) = 1e18./(wavelength_internal(number_spectrum,:)).^5.*exp(-C./(wavelength_internal(number_spectrum,:).*TK(number_spectrum)))./(1 - exp(-C./(wavelength_internal(number_spectrum,:).*TK(number_spectrum))));
    plankCurve_internal_norm(number_spectrum,1) = 1e18./(wavelength_internal(number_spectrum ,index_of_normig_wave)).^5.*exp(-C./(wavelength_internal(number_spectrum ,index_of_normig_wave).*TK(number_spectrum)))./(1 - exp(-C./(wavelength_internal(index_of_normig_wave).*TK(number_spectrum))));    
    plankCurve_internal(number_spectrum,:) = plankCurve_internal(number_spectrum,:)./ plankCurve_internal_norm(number_spectrum);
    
    plankCurve_internal(number_spectrum,:) = plankCurve_internal(number_spectrum,:) - average_level(number_spectrum);
    plankCurve_internal(plankCurve_internal < 0) = 0;
    plankCurve_out = zeros(number_spectrum(end), length(plankCurve_internal));
    for i = 1:fix(size(plankCurve_internal,2)/2)
        plankCurve_out(number_spectrum, length(plankCurve_internal)-i+1) = plankCurve_internal(number_spectrum, i);
        plankCurve_out(number_spectrum, i) = plankCurve_internal(number_spectrum, length(plankCurve_internal)-i+1);
    end
    if rem(size(plankCurve_internal,2),2) ~= 0
        plankCurve_out(number_spectrum, i+1) = plankCurve_internal(number_spectrum, i+1);
    end
end
