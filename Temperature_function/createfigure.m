function createfigure(Temperature, Step_T,number_spectrum,spec,Wavelength, Wavenumber,vienX_plot,inten,plankCurve,radical_plank,spec_CO_plank,vienY_plot,coef_k,spec_C2_plank,plot_num_internal, Attitude_I, TK, index_of_normig_wave, radical_min_index, spec_sizes)


%%Белый фон на всех графиках
set(0,'defaultfigurecolor',[1 1 1])

%% Температура по Планку
figure
axes1 = axes();
Temperature_Plank = Temperature(:,1);
plot((1:length(Temperature_Plank)), Temperature_Plank,'LineWidth',1);
hold on;
grid minor;
set(axes1,'FontName','Arial','FontSize',20,'FontWeight','bold');
xlabel('Номер измерения','FontWeight','bold','FontSize',20,'FontName','Arial');
ylabel('Температура, К','FontWeight','bold','FontSize',20, 'FontName','Arial');
ylim([2200 2700]);
    
for i = 1:size(spec_sizes, 1)-1
    x_line_position = sum(spec_sizes(1:i));
    y_line_position = mean(Temperature_Plank(x_line_position-10:x_line_position+10));
    line([x_line_position x_line_position], [y_line_position-100 y_line_position+100],'LineWidth', 2, 'LineStyle', '--', 'Color', [237/255 33/255 36/255]);
    if i <= 5
        th = text(x_line_position - fix(spec_sizes(i)/2),y_line_position+100, strcat('Mode ', {' '}, num2str(i)), 'FontSize', 18, 'FontWeight', 'bold');
        set(th,'visible','on','HorizontalAlignment','center','VerticalAlignment','middle')
    end
end 

%%
figure
axes1 = axes();
Temperature_radical_start = Temperature(:,4);
plot((1:length(Temperature_radical_start)), smooth(Temperature_radical_start,8),'LineWidth',1);
hold on;
grid minor;
set(axes1,'FontName','Arial','FontSize',14,'FontWeight','bold');
xlabel('Sample number','FontWeight','bold','FontSize',14,'FontName','Arial');
ylabel('Temperature (K)','FontWeight','bold','FontSize',14, 'FontName','Arial');
% ylim([1800 3500]);
    
for i = 1:size(spec_sizes, 1)-1
    x_line_position = sum(spec_sizes(1:i));
    y_line_position = mean(Temperature_radical_start(x_line_position-10:x_line_position+10));
    line([x_line_position x_line_position], [y_line_position-100 y_line_position+100],'LineWidth', 2, 'LineStyle', '--', 'Color', [237/255 33/255 36/255]);
    if i <= 5
        th = text(x_line_position - fix(spec_sizes(i)/2),y_line_position+200, strcat('Mode ', {' '}, num2str(i)), 'FontSize', 18, 'FontWeight', 'bold');
        set(th,'visible','on','HorizontalAlignment','center','VerticalAlignment','middle')
    end
end 
    
%     figure
%     axes1=axes();
%     hold on
%     plot1 = plot(Step_T:Step_T:(length(Attitude_I)*Step_T), Attitude_I, 'LineWidth',2);
%     grid minor
%     set(plot1(1),'LineWidth',2)
%     set(axes1,'FontName','Arial','FontSize',14,'FontWeight','bold');
%     ylabel('Intensities ratio C_2^*(\Delta\nu=-1)/C_2^*(\Delta\nu=0)','FontWeight','bold','FontSize',14,'FontName','Arial');
%     xlabel('Temperature (K)','FontWeight','bold','FontSize',14, 'FontName','Arial');
%     box off
%     


%% Спектр излучения пламени (целиком), кривая Планка и кривая CO2
figure2 = figure;
axes5 = axes();
hold(axes5,'on');
plot(Wavelength,inten(plot_num_internal,:),'LineWidth',1);
plot(Wavelength,spec_CO_plank(plot_num_internal,end:-1:1),'LineWidth',2);
plot(Wavelength,plankCurve(plot_num_internal,end:-1:1),'LineWidth',2);
set(axes5,'FontSize',14,'FontWeight','bold','FontName','Arial');
xlabel('Wavelength (nm)','FontWeight','bold','FontSize',14,'FontName','Arial');
ylabel('Emission intensity (a.u.)','FontWeight','bold','FontSize',14, 'FontName','Arial');
legend('Flame emission spectrum','CO_2^* emission','Planck curve', 'Location', 'northeast');
xlim([430 750]);
text(428,1.3,'CH^*','FontSize',16,'FontWeight','bold','FontName','Arial');
text(465,0.47,'C_2^*(\Delta\nu=1)','FontSize',16,'FontWeight','bold','FontName','Arial');
text(514,0.85,'C_2^*(\Delta\nu=0)','FontSize',16,'FontWeight','bold','FontName','Arial');
text(554,0.56,'C_2^*(\Delta\nu=-1)','FontSize',16,'FontWeight','bold','FontName','Arial');
text(630,1,'Soot emission','FontSize',16,'FontWeight','bold','FontName','Arial');
grid minor;
box(axes5,'off');


%% Выделение спектра излучения С2* из общего спектра пламени
figure1 = figure;
axes1 = subplot(2,2,[1,2]);
hold(axes1,'on');
YMatrix1 = [inten(plot_num_internal,:); plankCurve(plot_num_internal,end:-1:1)];
plot1 = plot(Wavelength,YMatrix1);
set(plot1(2),'LineWidth',2);
set(axes1,'FontName','Arial','FontSize',14,'FontWeight','bold');
xlabel('Wavelength (nm)','FontWeight','bold','FontSize',14,'FontName','Arial');
title('(a)');
ylabel('Emission intensity (a.u.)','FontWeight','bold','FontSize',14, 'FontName','Arial');
xlim([425 750]);
box(axes1,'off');
%grid(axes1,'on');
grid minor;
legend('Flame emission spectrum','Planck curve', 'Location', 'northwest');

% axes3 = subplot(2,1,2);
% hold(axes3,'on');
% YMatrix3 = [vienY_plot(plot_num_internal,:);coef_k(plot_num_internal, 1).*vienX_plot(plot_num_internal,:)+  coef_k(plot_num_internal, 2)];
% plot3 = plot(vienX_plot(plot_num_internal,:),YMatrix3);
% set(plot3(2),'LineWidth',2);
% % Create xlabel
% xlabel('C_2/\lambda','FontWeight','bold','FontSize',12,'FontName','Arial');
% title('(c)','FontSize',12);
% ylabel('ln(\lambda^5I)','FontWeight','bold','FontSize',12,'FontName','Arial');
% box(axes3,'on');
% grid(axes3,'on');
% set(axes3,'FontName','Arial','FontSize',12,'FontWeight','bold');

axes2 = subplot(2,2,3);
hold(axes2,'on');
YMatrix2 = [radical_plank(plot_num_internal,end:-1:1); spec_CO_plank(plot_num_internal,end:-1:1)];
plot2 = plot(Wavelength,YMatrix2);
set(plot2(2),'LineWidth',2,'Color',[0 0 0]);
set(axes2,'FontName','Arial','FontSize',14,'FontWeight','bold');
xlabel('Wavelength (nm)','FontWeight','bold','FontSize',14,'FontName','Arial');
title('(b)');
ylabel('Emission intensity (a.u.)','FontWeight','bold','FontSize',14, 'FontName','Arial');
xlim([425 575]);
ylim([0 0.8]);
box(axes2,'off');
%grid(axes2,'on');
grid minor;
legend('Flame emission spectrum','CO_2^* emission', 'Location', 'northeast');

axes4 = subplot(2,2,4);
hold(axes4,'on');
YMatrix4 = spec_C2_plank(plot_num_internal,end:-1:1);
plot4 = plot(Wavelength,YMatrix4);
set(plot4(1),'LineWidth',1);
set(axes4,'FontName','Arial','FontSize',14,'FontWeight','bold');
xlabel('Wavelength (nm)','FontWeight','bold','FontSize',14,'FontName','Arial');
title('(c)');
ylabel('Emission intensity (a.u.)','FontWeight','bold','FontSize',14, 'FontName','Arial');
xlim([450 575]);
ylim([0 0.8]);
%grid(axes4,'on');
grid minor;
box(axes4,'off');


%% Спектр излучения пламени (целиком) и кривые Планка
% figure3 = figure;
% axes6 = subplot(2,2,[1 2 3 4]);
% hold(axes6,'on');
% YMatrix6 = [inten(:,end:-1:1); plankCurve(:,end:-1:1)];
% plot6 = plot(Wavelength,YMatrix6);
% set(plot6(1),'LineWidth',1);
% set(axes6,'FontName','Arial','FontSize',14,'FontWeight','bold');
% xlabel('Wavelength (nm)','FontWeight','bold','FontSize',14,'FontName','Arial');
% ylabel('Emission intensity (a.u.)','FontWeight','bold','FontSize',14, 'FontName','Arial');
% xlim([425 750]);
% ylim([-0.001 1.5]);
% grid(axes6,'on');
% box(axes6,'off');


%% Спектр излучения пламени (целиком) в зависимости от режима работы двигателя
figure4 = figure;
axes4 = axes();
hold on;
for i = 1:1:size(spec,1)
      spec_smooth(i,:) = smooth(spec(i,:),10);
end
plot(Wavelength, spec_smooth(1,:),'LineWidth',1.5)
plot(Wavelength, 1700+spec_smooth(2,:),'LineWidth',1.5)
plot(Wavelength, 3900+spec_smooth(3,:),'LineWidth',1.5)
plot(Wavelength, 10200 + spec_smooth(4,:),'LineWidth',1.5)
plot(Wavelength, 16000 + spec_smooth(5,:),'LineWidth',1.5)
set(axes4,'FontName','Arial','FontSize',14,'FontWeight','bold');
xlabel('Wavelength (nm)','FontWeight','bold','FontSize',14,'FontName','Arial');
ylabel('Emission intensity (a.u.)','FontWeight','bold','FontSize',14, 'FontName','Arial');
legend('Mode 1','Mode 2','Mode 3', 'Mode 4', 'Mode 5', 'Orientation', 'horizontal', 'Location', 'best');
xlim([425 750]);
grid minor;
box(axes4,'off');


%% Кривые Планка в зависимости от режима работы двигателя
% Продлить до 3-4 мкм
Wavelength_plank = 425:0.1:4000;
plankCurve_out = Planck_Curve_Recovery(Wavelength_plank, number_spectrum, TK,spec, index_of_normig_wave );
figure4 = figure;
axes7 = axes();
hold(axes7,'on');
for i = 1:size(plankCurve_out,1)
    YMatrix7 = plankCurve_out(i,end:-1:1);
    plot7= plot(Wavelength_plank,YMatrix7,'LineWidth',1.5);
end
set(plot7(1),'LineWidth',1);
set(axes7,'FontName','Arial','FontSize',14,'FontWeight','bold');
xlabel('Wavelength (nm)','FontWeight','bold','FontSize',14,'FontName','Arial');
ylabel('Emission intensity (a.u.)','FontWeight','bold','FontSize',14, 'FontName','Arial');
legend('Mode 1','Mode 2','Mode 3', 'Mode 4', 'Mode 5', 'Orientation', 'horizontal', 'Location', 'best');
grid minor;
box(axes7,'off');


%% Изменение количества CO2 в зависимости от режима работы двигателя
% Добавить нормировку
figure5 = figure;
axes7 = axes();
hold(axes7,'on');
for i = 1:size(spec_CO_plank,1)
    spec_CO_plank_sum(i) = sum(spec_CO_plank(i,end:-1:1)*spec(i,radical_min_index));
end
plot7= plot(spec_CO_plank_sum,'LineWidth',1.5);
set(plot7(1),'LineWidth',1);
set(axes7,'FontName','Arial','FontSize',14,'FontWeight','bold');
title('Sum of CO2 emission spectrum');
xlabel('Number spectrum','FontWeight','bold','FontSize',14,'FontName','Arial');
ylabel('Emission intensity (a.u.)','FontWeight','bold','FontSize',14, 'FontName','Arial');
grid minor;
box(axes7,'off');


%% Спектр излучения пламени (С2*) в зависимости от режима работы двигателя
figure6 = figure;
axes7 = subplot(2,2,[1 2 3 4]);
hold(axes7,'on');
for i = 1:size(spec_C2_plank(:,end:-1:1),1)
    YMatrix7 = spec_C2_plank(i,end:-1:1)+(i-1);
    plot7= plot(Wavelength,YMatrix7);
end
set(plot7(1),'LineWidth',1);
set(axes7,'FontName','Arial','FontSize',14,'FontWeight','bold');
xlabel('Wavelength (nm)','FontWeight','bold','FontSize',14,'FontName','Arial');
ylabel('Emission intensity (a.u.)','FontWeight','bold','FontSize',14, 'FontName','Arial');
legend('Mode 1','Mode 2','Mode 3', 'Mode 4', 'Mode 5', 'Orientation', 'horizontal', 'Location', 'best');
xlim([425 575]);
ylim([0 5]);
grid minor;
box(axes7,'off');

%% Соотношение полос (С2*0)/(С2*-1) в зависимости от режима работы двигателя
% не для усреднеенных данных!
diff_num = -1;
diff_denom = 0;
[ ~, ~, I_integrals ] = Transition_Series_Integral( spec_C2_plank, Wavenumber, Attitude_I, number_spectrum, plot_num_internal, Step_T, diff_num, diff_denom );

figure7 = figure;
axes8 = subplot(2,2,[1 2 3 4]);
hold(axes8,'on');
plot8= plot(I_integrals);
set(plot8(1),'LineWidth',1);
set(axes8,'FontName','Arial','FontSize',14,'FontWeight','bold');
xlabel('Number spectrum','FontWeight','bold','FontSize',14,'FontName','Arial');
ylabel('Intensities ratio C_2^*(\Delta\nu=-1)/C_2^*(\Delta\nu=0)','FontWeight','bold','FontSize',14, 'FontName','Arial');
grid minor;
box(axes8,'off');

%% Спектр излучения пламени (С2*1)/(С2*-1) в зависимости от режима работы двигателя
% не для усреднеенных данных!
diff_num = 1;
diff_denom = -1;
[ ~, ~, I_integrals ] = Transition_Series_Integral( spec_C2_plank, Wavenumber, Attitude_I, number_spectrum, plot_num_internal, Step_T, diff_num, diff_denom );

figure8 = figure;
axes8 = subplot(2,2,[1 2 3 4]);
hold(axes8,'on');
plot8= plot(I_integrals);
set(plot8(1),'LineWidth',1);
set(axes8,'FontName','Arial','FontSize',14,'FontWeight','bold');
xlabel('Number spectrum','FontWeight','bold','FontSize',14,'FontName','Arial');
ylabel('Intensities ratio C_2^*(\Delta\nu=1)/C_2^*(\Delta\nu=-1)','FontWeight','bold','FontSize',14, 'FontName','Arial');
grid minor;
box(axes8,'off');

%% Спектр излучения пламени (С2*0)/(С2*1) в зависимости от режима работы двигателя
% не для усреднеенных данных!
diff_num = 0;
diff_denom = 1;
[ ~, ~, I_integrals ] = Transition_Series_Integral( spec_C2_plank, Wavenumber, Attitude_I, number_spectrum, plot_num_internal, Step_T, diff_num, diff_denom );

figure9 = figure;
axes8 = subplot(2,2,[1 2 3 4]);
hold(axes8,'on');
plot8= plot(I_integrals);
set(plot8(1),'LineWidth',1);
set(axes8,'FontName','Arial','FontSize',14,'FontWeight','bold');
xlabel('Number spectrum','FontWeight','bold','FontSize',14,'FontName','Arial');
ylabel('Intensities ratio C_2^*(\Delta\nu=0)/C_2^*(\Delta\nu=1)','FontWeight','bold','FontSize',14, 'FontName','Arial');
grid minor;
box(axes8,'off');

%%
% % ./mean(spec_smooth(:,1100:1150),2)
% mesh(Wavelength(:), 1:size(spec_smooth,1), spec_smooth(:,:))
% xlabel('Wavelength (nm)','FontWeight','bold','FontSize',14,'FontName','Arial');
% zlabel('Emission intensity (a.u.)','FontWeight','bold','FontSize',14, 'FontName','Arial');
% ylabel('Number spectrum','FontWeight','bold','FontSize',14, 'FontName','Arial');