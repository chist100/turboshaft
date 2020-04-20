function plankCurve_out = Planck_Curve_Recovery(Wavelength, number_spectrum, TK, spec, vien_indexes)
% Функция осуществляет востановление нормализованной кривой Планка, по температуре.
%{
Вход функции:
spec - спектр с аппаратными ошибками;
wavelength - длинны волн с аппаратными ошибками;
TK - температура;
index_of_normig_wave - индекс, по которому происходит нормирование.
Выход функции:
plankCurve_out - спектр Планка;
%}
    %Матрица длин волн
    wavelength_internal = Wavelength .* ones(number_spectrum(end), 1);
    %Коэфициент перевода в Кельвины
    C = 6.625176*2.99792458e6/1.380662;
    %Востановление Планка
    plankCurve_internal(number_spectrum, :) = 1e18./(wavelength_internal(number_spectrum,:)).^5.*exp(-C./(wavelength_internal(number_spectrum,:).*TK(number_spectrum)))./(1 - exp(-C./(wavelength_internal(number_spectrum,:).*TK(number_spectrum))));
    %Поиск амплитуды Планка
    A =  mean(spec(:,vien_indexes) ./ plankCurve_internal(:,vien_indexes),2);
    %Нормировка
    plankCurve_out = plankCurve_internal .* A;
end