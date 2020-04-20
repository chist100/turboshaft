function [ ligth_intensity ] = MAIN_fnc(ligth_start_coord, ligth_start_angle, ligth_start_number_ray, fiber_size, fiber_coord)
% Расчет оптической схемы
% Все координаты и размеры в миллиметрах
[ligth_source] = ligth_source_fnc(ligth_start_coord, ligth_start_angle, ligth_start_number_ray);

%% Щиток
visor_coord = 2;                      %координаты внутренней стенки камеры (координата считается как центр отверстия)
visor_slot = 3;                         %ридиус отверстия
[ligth_source_visor] = visor_transit_fnc(visor_coord, visor_slot, ligth_source, true);
if isempty(ligth_source_visor)
    ligth_intensity = zeros(length(fiber_coord),1);
    return
end

%% Щиток1
visor_coord1 = 40.38;                      %координаты внутренней стенки камеры (координата считается как центр отверстия)
visor_slot1 = 3.5;                         %ридиус отверстия
[ligth_source_visor1] = visor_transit_fnc(visor_coord1, visor_slot1, ligth_source_visor, true);
if isempty(ligth_source_visor)
    ligth_intensity = zeros(length(fiber_coord),1);
    return
end

%% Cапфир
saphir_coord = 65.8;
saphir_thickness = 7;
saphir_sizes = 20.5;
N_s = 1.754;
[ligth_source_saphir] = saphir_transit_fnc(saphir_coord, saphir_thickness, N_s, saphir_sizes, ligth_source_visor1);
if isempty(ligth_source_saphir)
    ligth_intensity = zeros(length(fiber_coord),1);
    return
end
%% Экран

shield_coord = 135;                      %координаты экрана (координата считается как серидина экрана)
shield_slot = 5;                         %ридиус экрана

[ligth_source_shield] = visor_transit_fnc(shield_coord, shield_slot, ligth_source_saphir, false);
if isempty(ligth_source_shield)
    ligth_intensity = zeros(length(fiber_coord),1);
    return
end

%% 1 сапфир

saphir_coord1 = 138.6;
saphir_thickness1 = 2;
saphir_sizes1 = 20.5;
N_s1 = 1.754;

[ligth_source_saphir1] = saphir_transit_fnc(saphir_coord1, saphir_thickness1, N_s1, saphir_sizes1, ligth_source_shield);
if isempty(ligth_source_saphir1)
    ligth_intensity = zeros(length(fiber_coord),1);
    return
end

%% Линзы
% ---- тут даные линзы ----
lens_fist_radius = [312.80 45.88 46.58 -96.25];
lens_fist_sizes = [4.00 20.5 1];
lens_fist_coord = 143;
N = [1 1.6223 1.7205];

j = 1;
X0 = lens_fist_coord + lens_fist_radius(1);
[ligth_source_lens1, ~] = lens_part_transit_fnc([N(1) N(3)], ligth_source_saphir1, lens_fist_radius(j), lens_fist_sizes(2)/2, X0);
if isempty(ligth_source_lens1)
    ligth_intensity = zeros(length(fiber_coord),1);
    return
end
j = 2;
X0 = lens_fist_coord + lens_fist_sizes(1) + lens_fist_radius(j);
[ligth_source_lens2, ~] = lens_part_transit_fnc([N(3) N(1)], ligth_source_lens1, lens_fist_radius(j), lens_fist_sizes(2)/2, X0);
if isempty(ligth_source_lens2)
    ligth_intensity = zeros(length(fiber_coord),1);
    return
end

j = 3;
X0 = lens_fist_coord + lens_fist_sizes(1) + lens_fist_sizes(3) + lens_fist_radius(j);
[ligth_source_lens3, ~] = lens_part_transit_fnc([N(1) N(2)], ligth_source_lens2, lens_fist_radius(j), lens_fist_sizes(2)/2, X0);
if isempty(ligth_source_lens3)
    ligth_intensity = zeros(length(fiber_coord),1);
    return
end

j = 4;
X0 = lens_fist_coord + lens_fist_sizes(1) + lens_fist_sizes(3) + lens_fist_sizes(1) + lens_fist_radius(j);
[ligth_source_lens4, ~] = lens_part_transit_fnc([N(2) N(1)], ligth_source_lens3, lens_fist_radius(j), lens_fist_sizes(2)/2, X0);
if isempty(ligth_source_lens4)
    ligth_intensity = zeros(length(fiber_coord),1);
    return
end

%% ---- тут второй линзы ----
lens_second_radius = [211.55 -34.81 -33.69 -199.82];
lens_second_sizes = [4.00 20.5 1];
lens_second_coord = [157.65];
N = [1 1.6223 1.6541];


j = 1;
X0 = lens_second_coord + lens_second_radius(1);
[ligth_source_lens5, ~] = lens_part_transit_fnc([N(1) N(2)], ligth_source_lens4, lens_second_radius(j), lens_second_sizes(2)/2, X0);
if isempty(ligth_source_lens5)
    ligth_intensity = zeros(length(fiber_coord),1);
    return
end

j = 2;
X0 = lens_second_coord + lens_second_sizes(1) + lens_second_radius(j);
[ligth_source_lens6, ~] = lens_part_transit_fnc([N(2) N(1)], ligth_source_lens5, lens_second_radius(j), lens_second_sizes(2)/2, X0);
if isempty(ligth_source_lens6)
    ligth_intensity = zeros(length(fiber_coord),1);
    return
end

j = 3;
X0 = lens_second_coord + lens_second_sizes(1) + lens_second_sizes(3) + lens_second_radius(j);
[ligth_source_lens7, ~] = lens_part_transit_fnc([N(1) N(3)], ligth_source_lens6, lens_second_radius(j), lens_second_sizes(2)/2, X0);
if isempty(ligth_source_lens7)
    ligth_intensity = zeros(length(fiber_coord),1);
    return
end

j = 4;
X0 = lens_second_coord + lens_second_sizes(1) + lens_second_sizes(3) + lens_second_sizes(1) + lens_second_radius(j);
[ligth_source_lens8, ~] = lens_part_transit_fnc([N(3) N(1)], ligth_source_lens7, lens_second_radius(j), lens_second_sizes(2)/2, X0);
if isempty(ligth_source_lens8)
    ligth_intensity = zeros(length(fiber_coord),1);
    return
end

%% 2 сапфир
saphir_coord2 = 169;
saphir_thickness2 = 2;
saphir_sizes2 = 20.5;
N_s2 = 1.754;

[ligth_source_saphir2] = saphir_transit_fnc(saphir_coord2, saphir_thickness2, N_s2, saphir_sizes2, ligth_source_lens8);
if isempty(ligth_source_saphir2)
    ligth_intensity = zeros(length(fiber_coord),1);
    return
end

%% Волокно
[ligth_intensity] = fiber_transit_fnc(fiber_coord, fiber_size, ligth_source_saphir2);

%%
figure
grid on
for i = 1:length(ligth_source(:,1))
hold on
plot(ligth_start_coord(1):visor_coord,ligth_source(i,1).*(ligth_start_coord(1):visor_coord) + ligth_source(i,2))
end

for i = 1:length(ligth_source_visor(:,1))
hold on
plot(visor_coord:visor_coord1,ligth_source_visor(i,1).*(visor_coord:visor_coord1) + ligth_source_visor(i,2))
end

for i = 1:length(ligth_source_visor1(:,1))
hold on
plot(visor_coord1:saphir_coord,ligth_source_visor1(i,1).*(visor_coord1:saphir_coord) + ligth_source_visor1(i,2))
end

for i = 1:length(ligth_source_saphir(:,1))
hold on
plot((saphir_coord+saphir_thickness):shield_coord,ligth_source_saphir(i,1).*((saphir_coord+saphir_thickness):shield_coord) + ligth_source_saphir(i,2))
end

for i = 1:length(ligth_source_shield(:,1))
hold on
plot(shield_coord:saphir_coord1,ligth_source_shield(i,1).*(shield_coord:saphir_coord1) + ligth_source_shield(i,2))
end

for i = 1:length(ligth_source_saphir1(:,1))
hold on
plot(saphir_coord1:lens_fist_coord,ligth_source_saphir1(i,1).*(saphir_coord1:lens_fist_coord) + ligth_source_saphir1(i,2))
end


for i = 1:length(ligth_source_saphir1(:,1))
hold on
plot(saphir_coord1:lens_fist_coord,ligth_source_saphir1(i,1).*(saphir_coord1:lens_fist_coord) + ligth_source_saphir1(i,2))
end
for i = 1:length(ligth_source_saphir1(:,1))
hold on
plot(saphir_coord1:lens_fist_coord,ligth_source_saphir1(i,1).*(saphir_coord1:lens_fist_coord) + ligth_source_saphir1(i,2))
end
for i = 1:length(ligth_source_saphir1(:,1))
hold on
plot(saphir_coord1:lens_fist_coord,ligth_source_saphir1(i,1).*(saphir_coord1:lens_fist_coord) + ligth_source_saphir1(i,2))
end

end