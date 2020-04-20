function [ spec_out, wavelength_out ] = hardware_error( spec, wavelength )
% Определение аппаратного смещения
%{
Вход функции:
spec - спектр с аппаратными ошибкамиы;
wavelength - длинны волн с аппаратными ошибками.
Выход функции:
spec_out - спектр без аппаратных ошибок;
wavelength_out - длинны волн без аппаратных ошибкок.
%}
    %% Определение ошибки относительно пика 00 малекулы С2.
    devi_spec = zeros(1, length(spec));
    wavelength_00 = 516.6682071990379;
    index_00r = find(abs(wavelength - wavelength_00) <= 0.2, 1, 'last' );
    for J = 1:size(spec,1)
        devi_spec(J,:) = smooth(spec(J,:), 7);
    end
    devi_spec = mean(devi_spec(:,:),1);
    index_00 = find(abs(devi_spec(700:1200) - max(devi_spec(700:1200))) <= 0.2,1, 'last' ) + 700;
    devi_diff = index_00r - index_00;
    % Сдвиг графика относительно ошибки devi_diff.
    if devi_diff > 0
        spec_internal = spec(:,devi_diff:end);
        wavelength_out = wavelength(1:end+devi_diff+1);
    else
        spec_internal = spec(:,1:end-abs(devi_diff)+1);
        wavelength_out = wavelength(:,abs(devi_diff):end);
    end

    %% Учет аппаратной функции
    without_saphir = load('3_bez.DAT');
    without_saphir = without_saphir';
    with_saphir = load('4_s.DAT');
    with_saphir = with_saphir';
    saphir_koef = with_saphir(2,:)./without_saphir(2,:);
    if devi_diff > 0
        saphir_koef_devi = saphir_koef(:,devi_diff:end);
    else
        saphir_koef_devi = saphir_koef(:,1:end-abs(devi_diff)+1);
    end
    spec_out = zeros(size(spec_internal));
    for i = 1:size(spec_internal,1)
        spec_out(i,:) = spec_internal(i,:)./saphir_koef_devi;
    end
end

