function [ spec_out, wavelength_out ] = Hardware_Error( spec, wavelength )
% Определение аппаратного смещения
% {
% Вход функции:
% spec - спектр с аппаратными ошибкамиы;
% wavelength - длинны волн с аппаратными ошибками.
% Выход функции:
% spec_out - спектр без аппаратных ошибок;
% wavelength_out - длинны волн без аппаратных ошибкок.
% }
    % Определение ошибки относительно пика 00 малекулы С2.
    spec_smooth = zeros(size(spec));
    %Длина волны пика N2
    wavelength_N = 589.3;
    %Индекс пика N2
    index_00r = find(abs(wavelength - wavelength_N) <= 0.2, 1, 'last' );
    %Усреднение по 7 точкам
    for J = 1:size(spec,1)
        spec_smooth(J,:) = smooth(spec(J,:), 7);
    end
    %Среднее среди всех загруженных спектров
    devi_spec1 = mean(spec_smooth(:,:),1);
    %Поиск пика N2
    [~, index_00] = max(devi_spec1(1800:1940));
    diff_s = -index_00r + (index_00+1800);
    %Сдвиг графика относительно ошибки местонахождения пика N2.
    if diff_s > 0
        spec_internal = spec(:,diff_s:end);
    else
        spec_internal = spec(:,1:end-abs(diff_s)+1);
    end

    % Учет аппаратной функции
    without_saphir = load('3_bez.DAT');
    without_saphir = without_saphir';
    with_saphir = load('4_s.DAT');
    with_saphir = with_saphir';
    saphir_koef = with_saphir(2,:)./without_saphir(2,:);
    %Усреднение по 7 точкам
    saphir_koef_sm(:) = smooth(saphir_koef(:), 7);
    %Поиск сдвига сапфира
    [~,index_saph] = min(saphir_koef_sm(3200:3500));
    devi_spec_internal = zeros(size(spec_internal,1),size(spec_internal,2) - 3250+1);
    for J = 1:size(spec_internal,1)
        devi_spec_internal(J,:) = smooth(spec_internal(J,3250:end), 7);
    end
    devi_spec_internal1 = mean(devi_spec_internal(:,:),1);
    [~,index_spec_internal] = min(devi_spec_internal1);
    
    
    diff_c = index_saph+3200 - (index_spec_internal + 3250);
    %Сдвиг сафира
    if diff_c > 0
        saphir_koef_devi = saphir_koef(:,diff_c:end);
        wavelength_devi = wavelength(1:end-diff_c+1);
    else
        saphir_koef_devi = saphir_koef(:,1:end-abs(diff_c)+1);
        wavelength_devi = wavelength(:,abs(diff_c):end);
    end
    %Согласование вектора сапфира и матрицы спектра
    if diff_c > 0 && diff_s > 0
        if abs(diff_s)<abs(diff_c)
            spec_internal = spec_internal(:,(diff_s-diff_c+1):end);
        else
            saphir_koef_devi_out = saphir_koef_devi(:,(diff_s-diff_c+1):end);
            wavelength_devi = wavelength_devi(:,1:end-abs(diff_s-diff_c));
        end
    elseif diff_c < 0 && diff_s < 0
        if abs(diff_s)<abs(diff_c)
            spec_internal = spec_internal(:,1:end-abs(diff_c-diff_s+1));
        else
            saphir_koef_devi_out = saphir_koef_devi(:,1:end-abs(diff_s-diff_c)+1);
            wavelength_devi = wavelength_devi(:,(diff_c-diff_s):end);
        end
    elseif diff_c < 0 && diff_s > 0
        saphir_koef_devi_out = saphir_koef_devi(:,diff_s:end);
        wavelength_devi = wavelength_devi(:,diff_s:end);
        spec_internal = spec_internal(:,1:end-abs(diff_c)+1);
    elseif diff_c > 0 && diff_s < 0
        saphir_koef_devi_out = saphir_koef_devi(:,1:end-abs(diff_s)+1);
        wavelength_devi = wavelength_devi(:,1:end-abs(diff_s)+1);
        spec_internal = spec_internal(:,diff_c:end);
    end
    %Учет аппаратной функции
    wavelength_out = wavelength_devi;
    spec_out = zeros(size(spec_internal));
    for i = 1:size(spec_internal,1)
        spec_out(i,:) = spec_internal(i,:)./saphir_koef_devi_out;
    end
end