function [spec_CO, radical_min_index] = CO_Emission(radical,Wavelength)
% ������������� ������� ������� ��2
    spec_CO = zeros(size(radical));
    for J = 1:size(radical,1)
        %���������� ������������� ������� CO
        %����� ����� ��������� �������������
        Wavenumber_max = 330;
        %�������� �������� (������� ����������� ������� � ������� �����
        %����� ��������� �������������
        W = 70;
        %������������� �������
        spec_CO_local(:) = exp(-exp(((-Wavelength+Wavenumber_max))/W)-(Wavelength-Wavenumber_max)/W+1);
        %����� ������� � ��������� ����� ����������
        [radical_min, radical_min_index] = min(radical(J,220:240));
        radical_min_index = radical_min_index + 220;
        %����������
        spec_CO(J,:) = spec_CO_local(:)./spec_CO_local(radical_min_index).*radical_min;
    end
end