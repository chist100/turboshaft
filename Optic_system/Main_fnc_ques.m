clear
% close all
% clc
% ligth_start_coordX = -63;
ligth_start_coordX = -126 : 0.2540:0; %координаты источника света
ligth_start_coordY = 0;
% ligth_start_coordY = -10:0.1:10;
ligth_start_angle = 10;                 %угол пучка лучей от источника (измеряется от главной оптической оси)
ligth_start_number_ray = 2000;          %количество лучей от источника (ЧЕТНОЕ)
% load('fiber');
% fiber_coord = fiber;
% fiber_coord = 284:(78.3000 / (length(ligth_start_coordX) * length(ligth_start_coordY))):(362.3 - (78.3000 / (length(ligth_start_coordX) * length(ligth_start_coordY))));

%number_coord_fiber = 400;
%fiber_coord = 200:(400-200+1)/number_coord_fiber:400;
fiber_coord = 363;

fiber_size = 0.2;                       % радиус волокна
pic = 0;
tic;
ligth_coord = zeros((length(ligth_start_coordX)-1)+(length(ligth_start_coordY)-1)*length(ligth_start_coordX),2);
for i = 1:length(ligth_start_coordY)
    for j = 1:length(ligth_start_coordX)
        ligth_coord(j + (i-1)*length(ligth_start_coordX),2)=ligth_start_coordY(i);
        ligth_coord(j + (i-1)*length(ligth_start_coordX),1)=ligth_start_coordX(j);
    end
end
ligth_intensity = zeros(size(ligth_coord,1), length(fiber_coord));
for i = 1:size(ligth_coord,1)
    ligth_intensity(i, :)= MAIN_fnc(ligth_coord(i,:), ligth_start_angle, ligth_start_number_ray, fiber_size, fiber_coord);
%     disp(i/length(ligth_coordY)*100);
end
toc
% a = det(ligth_intensity);
% ligth_intensity_inv = inv(ligth_intensity);
%%
Y = 1;
result = zeros(length(ligth_start_coordX),length(ligth_start_coordY),size(ligth_intensity,2));
for i = 1:size(ligth_intensity,1)
    result(i-(Y-1)*length(ligth_start_coordX),Y,:) = ligth_intensity(i,:);
    if rem(i,length(ligth_start_coordX)) == 0
        Y = Y + 1;
    end
end
[X_mech, Y_mech] = meshgrid(ligth_start_coordY, ligth_start_coordX);
mesh(X_mech, Y_mech,result(:,:,98))
ylim([ligth_start_coordX(1) ligth_start_coordX(end)]);
xlim([ligth_start_coordY(1) ligth_start_coordY(end)]);
save('ligth_intensity.mat','ligth_intensity','ligth_start_coordY','ligth_start_coordX','fiber_coord');