function plankCurve_out = Planck_Curve_Recovery(Wavelength, number_spectrum, TK, spec, vien_indexes)
% ������� ������������ ������������� ��������������� ������ ������, �� �����������.
%{
���� �������:
spec - ������ � ����������� ��������;
wavelength - ������ ���� � ����������� ��������;
TK - �����������;
index_of_normig_wave - ������, �� �������� ���������� ������������.
����� �������:
plankCurve_out - ������ ������;
%}
    %������� ���� ����
    wavelength_internal = Wavelength .* ones(number_spectrum(end), 1);
    %���������� �������� � ��������
    C = 6.625176*2.99792458e6/1.380662;
    %������������� ������
    plankCurve_internal(number_spectrum, :) = 1e18./(wavelength_internal(number_spectrum,:)).^5.*exp(-C./(wavelength_internal(number_spectrum,:).*TK(number_spectrum)))./(1 - exp(-C./(wavelength_internal(number_spectrum,:).*TK(number_spectrum))));
    %����� ��������� ������
    A =  mean(spec(:,vien_indexes) ./ plankCurve_internal(:,vien_indexes),2);
    %����������
    plankCurve_out = plankCurve_internal .* A;
end