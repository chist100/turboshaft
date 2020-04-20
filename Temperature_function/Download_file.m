function [ spec_out, wavelength_st,  File_name , spec_sizes ] = Download_File( pname )
% Функция осуществляет загрузку файла спектра, а также опционально усреднение всех спектров в файле. 
%{
Вход функции:
pname - папка где необходимо искать файл.
Выход функции:
spec_input - загруженный спектр;
wavelength_st - длинны волн, указанные в файле;
File_name_plot - название файла.
%}
    %% Загрузка спектра
    % Смена папки
    oldFolder = cd(pname);
    % Инициализация переменных
    answer_1 = 'Да, двайте';
    answer_2 = 'Да, двайте';
    spec_inten = [];
    spec_inten_sizes = [];
    prompt = {'Первый спектр:','Последний спектр:'};
    dlgtitle = 'Номера спектров для обработки';
    dims = [1 35];
    % Выбор спектров и их предобработка
    while strcmp(answer_1,'Да, двайте') % Выполняется пока не откажетесь от загрузки спектра
        answer_1 = questdlg('Загрузить спектр?', ... % Диалоговое окно
            'Спектр горения', ...
            'Да, двайте','Нет, не надо','Да, двайте');
            switch answer_1 
                case 'Да, двайте'
                    disp('Выберите файл спектра')
                    [File_name,pname] = uigetfile({'*.DAT*'},'File Selector', 'MultiSelect', 'on'); %выбор файлов для закрузки
                    cd(pname); %Переход в папку выбранных фыйлов
                    spec_inten_load = load(File_name); % Загрузка выбранных файлов
                    spec_inten_n = spec_inten_load(2:end,:); % Отделение спектров от длинны волны
                    disp(['Выбран :'  File_name])
                    disp(['размером :'  string(size(spec_inten_n,1))])
                    
                    definput = {'1',num2str(size(spec_inten_n,1))}; % Границы выбора спектров
                    answer = inputdlg(prompt,dlgtitle,dims,definput); % Диалоговое окно
                    spec_inten_w = spec_inten_n(str2double(answer(1)):str2double(answer(2)),:); % Запись выбранных спектров
                    
                    if isempty(spec_inten_sizes) % Запись матррицы выбранных спектров
                        spec_inten_sizes = str2double(answer(2)) - str2double(answer(1));
                    else
                        spec_inten_sizes = [spec_inten_sizes; str2double(answer(2)) - str2double(answer(1))];
                    end
                    
                    answer_2 = questdlg('Усреднить?', ...  % Диалоговое окно
                        'Усреднение', ...
                        'Да, двайте','Нет, не надо','Да, двайте');
                        switch answer_2
                            case 'Да, двайте'
                                spec_inten_w = mean(spec_inten_w(:,:),1); % в случае усреднения возвращает только длины волн и один усредненный спектр от каждого файла
                            case 'Нет, не надо'
                        end
                    if isempty(spec_inten) % Запись матррицы-результата
                        spec_inten = spec_inten_w;
                    else
                        spec_inten = [spec_inten; spec_inten_w];
                    end
                case 'Нет, не надо'
                    cd(oldFolder); % Переход в изначальную папку
            end
    end


    
wavelength_st = spec_inten_load(1,:);
spec_out = spec_inten;
spec_sizes = spec_inten_sizes;

    %% Замена в имени
    % необходимо для корректной записи названия последующий файлов
    File_name = strrep(File_name, '.dat', '');
    File_name = strrep(File_name, '_', '');
end

