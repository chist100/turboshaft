function [ spec_out, wavelength_st,  File_name , spec_sizes ] = Download_File( pname )
% ������� ������������ �������� ����� �������, � ����� ����������� ���������� ���� �������� � �����. 
%{
���� �������:
pname - ����� ��� ���������� ������ ����.
����� �������:
spec_input - ����������� ������;
wavelength_st - ������ ����, ��������� � �����;
File_name_plot - �������� �����.
%}
    %% �������� �������
    % ����� �����
    oldFolder = cd(pname);
    % ������������� ����������
    answer_1 = '��, ������';
    answer_2 = '��, ������';
    spec_inten = [];
    spec_inten_sizes = [];
    prompt = {'������ ������:','��������� ������:'};
    dlgtitle = '������ �������� ��� ���������';
    dims = [1 35];
    % ����� �������� � �� �������������
    while strcmp(answer_1,'��, ������') % ����������� ���� �� ���������� �� �������� �������
        answer_1 = questdlg('��������� ������?', ... % ���������� ����
            '������ �������', ...
            '��, ������','���, �� ����','��, ������');
            switch answer_1 
                case '��, ������'
                    disp('�������� ���� �������')
                    [File_name,pname] = uigetfile({'*.DAT*'},'File Selector', 'MultiSelect', 'on'); %����� ������ ��� ��������
                    cd(pname); %������� � ����� ��������� ������
                    spec_inten_load = load(File_name); % �������� ��������� ������
                    spec_inten_n = spec_inten_load(2:end,:); % ��������� �������� �� ������ �����
                    disp(['������ :'  File_name])
                    disp(['�������� :'  string(size(spec_inten_n,1))])
                    
                    definput = {'1',num2str(size(spec_inten_n,1))}; % ������� ������ ��������
                    answer = inputdlg(prompt,dlgtitle,dims,definput); % ���������� ����
                    spec_inten_w = spec_inten_n(str2double(answer(1)):str2double(answer(2)),:); % ������ ��������� ��������
                    
                    if isempty(spec_inten_sizes) % ������ �������� ��������� ��������
                        spec_inten_sizes = str2double(answer(2)) - str2double(answer(1));
                    else
                        spec_inten_sizes = [spec_inten_sizes; str2double(answer(2)) - str2double(answer(1))];
                    end
                    
                    answer_2 = questdlg('���������?', ...  % ���������� ����
                        '����������', ...
                        '��, ������','���, �� ����','��, ������');
                        switch answer_2
                            case '��, ������'
                                spec_inten_w = mean(spec_inten_w(:,:),1); % � ������ ���������� ���������� ������ ����� ���� � ���� ����������� ������ �� ������� �����
                            case '���, �� ����'
                        end
                    if isempty(spec_inten) % ������ ��������-����������
                        spec_inten = spec_inten_w;
                    else
                        spec_inten = [spec_inten; spec_inten_w];
                    end
                case '���, �� ����'
                    cd(oldFolder); % ������� � ����������� �����
            end
    end


    
wavelength_st = spec_inten_load(1,:);
spec_out = spec_inten;
spec_sizes = spec_inten_sizes;

    %% ������ � �����
    % ���������� ��� ���������� ������ �������� ����������� ������
    File_name = strrep(File_name, '.dat', '');
    File_name = strrep(File_name, '_', '');
end

