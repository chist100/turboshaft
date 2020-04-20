function [ optic_spec, wavelength ] = download_file( pname )
% Функция осуществляет загрузку файлов спектра
%{
Вход функции:
pname - папка где необходимо искать файл.
Выход функции:
spec_input - загруженный спектр;
wavelength_st - длинны волн, указанные в файле;
File_name_plot - название файла.
%}
    %% Загрузка спектра
    oldFolder = cd(pname);
    [filename(:)] = uigetfile( ...
{  '*.mat','MAT-files (*.mat)'; ...
   '*.*',  'All Files (*.*)'}, ...
   '30 файлов загрузки', ...
   'MultiSelect', 'on');
    if size(filename,2) ~= 31
        disp('Кoличество файлов не равно 31')
        return
    end
    spec_inten = zeros(31,3648);
    for i = 1:size(filename,2)
        load_inten = load(filename(i));
        spec_inten(i,:) = mean(load_inten(3,:));
    end
    Integral_intensity = load('Integral_intensity.mat');
    optic_spec = zeros(31,3648);
    spec = zeros(31,3648);
    for i = 1:length(Integral_intensity,2)
        for j = 1:length(Integral_intensity,1)
            spec(j,:) = spec_inten(j,:).*Integral_intensity(j,i);
        end
        optic_spec(i,:) = sum(spec(:,:))/(sum(Integral_intensity(:,i)));
    end
    wavelength = load_inten(1,:);
    cd(oldFolder);
end
