clc
clear
close all
load('ligth_intensity.mat')
coordX = 1;
coordY = 1;
intensity = zeros(length(fiber_coord),length(ligth_start_coordX), length(ligth_start_coordY));
for i = 1:length(ligth_intensity)
    intensity(:, coordX, coordY) = ligth_intensity(:,i);
    coordX = coordX +1;
    if coordX > length(ligth_start_coordX)
        coordX = 1;
        coordY = coordY +1;
    end
end

intensity_film = zeros(size(intensity,3),size(intensity,2),size(intensity,1));
for i= 1:size(intensity,1)
    for j= 1:size(intensity,2)
        for k= 1:size(intensity,3)
            intensity_film(k,j,i) = intensity(i,j,k);
        end
    end
end




length_place = (ligth_start_coordX(1) - ligth_start_coordX(end))/length(fiber_coord);
number_place = length(fiber_coord);
Integral_intensity = zeros(number_place);
for j = 1:length(fiber_coord)
    for number = 1:number_place
        fist_Xborder = (number-1)*length_place;
        [~,Index_fist_Xborder] = min(abs(ligth_start_coordX - fist_Xborder));
        second_Xborder = number*length_place;
        [~,Index_second_Xborder] = min(abs(ligth_start_coordX - second_Xborder));
        Integral_intensity(number,j) = sum(intensity(j,Index_second_Xborder:Index_fist_Xborder,:),[1 2 3]);
%         t = intensity(j,Index_second_Xborder:Index_fist_Xborder,:);
%         i(Index_second_Xborder:Index_fist_Xborder, 1:201) = t(1,:,:);
%         mesh(i)
%         disp(Integral_intensity(number,j));
    end
end
mesh(Integral_intensity)

xlabel('fiber coord')
ylabel('namber place')

save('Integral_intensity.mat','Integral_intensity');
%%
figure

axes1 = subplot(2,2,[1,2,3,4]);
hold(axes1,'on');
plot1 = plot(Integral_intensity(1,:,:)./max(Integral_intensity(1,:,:)));
set(plot1(1),'LineWidth',2);
set(axes1,'FontName','Arial','FontSize',14,'FontWeight','bold');
xlabel('Fiber coordinate','FontWeight','bold','FontSize',14,'FontName','Arial');
title('Ñhanging emission intensity');
ylabel('Emission intensity (a.u.)','FontWeight','bold','FontSize',14, 'FontName','Arial');
% xlim([425 750]);
box(axes1,'off');
%grid(axes1,'on');
grid minor;

%%
figure

axes2 = subplot(2,2,[1,2,3,4]);
inten_3_d_plot(:,:) = intensity(31,:,:);
mesh(inten_3_d_plot,'LineWidth',2);
set(axes2,'FontName','Arial','FontSize',14,'FontWeight','bold');
xlabel('Combustion chamber width (mm)','FontWeight','bold','FontSize',14,'FontName','Arial');
title('Ñhanging emission intensity');
ylabel('Combustion chamber depth (mm)','FontWeight','bold','FontSize',14, 'FontName','Arial');
zlabel('Emission intensity (a.u.)','FontWeight','bold','FontSize',14,'FontName','Arial');