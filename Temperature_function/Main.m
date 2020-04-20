%% �������� � ��������� ������
clc
clear
%����� ��� �������� ������
%pname = 'C:\Chist\Project\Turboshaft\matlab_turbo\AVST\afterburner';
pname = '\\smb.fitos.org\gtd\\!������\��������� 06_06_2019\trials_su_27\AVST\afterburner_mat';
%�������� ������ � ������������ (�����������)
[ spec_input, wavelength_input,  File_name_plot, spec_sizes ] = Download_file( pname );
%% ������ ���������
%���������� ������ ������� � ����� � �������� ������ ����
[ spec, Wavelength ] = Hardware_error( spec_input, wavelength_input );
borders = [1 size(spec,1)];% ��������������� �������
plot_num = 1; % ����� ������� ��� ����������� �� �������

%% ������������ ��������
close all
tic
[ Temperature , spec_C2_plank, plankCurve, spec_CO_plank, spec_internal ] = Iterative_Algorithm( plot_num, spec, Wavelength, borders, spec_sizes );
toc
%%
[Max_CH,~] = max(spec_C2_plank(:,1:400),[],2);
[Max_C2,~] = max(spec_C2_plank(:,800:1200),[],2);
alpha = (Max_C2./Max_CH);

plot(alpha);
for i = 1:length(spec_sizes)
    hold on
    Y = min(alpha):0.01:max(alpha);
    plot((sum(spec_sizes(1:i))+1)*ones(length(Y),1),Y)
end
%%
figure
second_line = 1;
grid on
calorDote = ['r' 'g' 'b' 'y' 'm' 'c'];
NameData = ["����� MIN", "����� 1", "����� 2", "����� 3" ,"����� MAX"];
NumberDote = 10;
firstX = 2050;
endX = 2350;
Xlabelscetter = firstX:(endX-firstX)/(NumberDote):endX;
firstY = 3150;
endY = 4050;
Ylabelscetter = firstY:(endY-firstY)/(NumberDote-1):endY;
firstZ = 0.35;
endZ = 0.65;
Zlabelscetter = firstZ:(endZ-firstZ)/(NumberDote-1):endZ;
for i = 1:length(spec_sizes)
    hold on
    first_line = sum(spec_sizes(1:i));
    h = scatter3(smooth(Temperature(second_line:first_line,2),7),smooth(Temperature(second_line:first_line,4),7),smooth(alpha(second_line:first_line),7),'.');
    
    xText = mean(Temperature(second_line:first_line,2));
    yText = mean(Temperature(second_line:first_line,4));
    zText = mean(alpha(second_line:first_line))+0.03;
    if i <= 5
        h.MarkerEdgeColor = calorDote(i);
        t = textscatter3(xText,yText,zText,NameData(i));
    elseif i > 5
        h.MarkerEdgeColor = calorDote(length(spec_sizes)+1-i);
        t = textscatter3(xText,yText,zText,NameData(length(spec_sizes)+1-i));
    end
    h.MarkerFaceColor = 'k';
    second_line = first_line;
    t.FontSize = 15;
    t.FontWeight = 'bold';
    
    xlabel('������� �����������, �','FontSize',25,'FontWeight','bold')
    ylabel('������������� ����������� ��������� �_2, �','FontSize',25,'FontWeight','bold')
    zlabel({'��������� ������������� �����';' �_2(0,0) � CH, ���. ��.'},'FontSize',25,'FontWeight','bold')
    
    h.Parent.XLabel.Parent.FontSize = 25;
    h.Parent.YLabel.Parent.FontSize = 25;
    h.Parent.ZLabel.Parent.FontSize = 25;
    
    h.Parent.XLabel.Parent.XTick = Xlabelscetter;
    h.Parent.YLabel.Parent.YTick = Ylabelscetter;
    h.Parent.ZLabel.Parent.ZTick = Zlabelscetter;
    
    
end
