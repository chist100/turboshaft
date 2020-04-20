function [result, res_matrix, ligth_start_coordX] = race_tracing(number_nodes, error_position, savingMode, description, mode_flame, matoh)
%% Проверка входных величин.
%number_nodes
mustBePositive(number_nodes)
if (number_nodes - fix(number_nodes))~= 0
    error('number_nodes is not integer. Try change input values');
end
%error_position
if ~isfloat(error_position) && error_position < 0
    error('error_position is not float and positive. Try change input values');
end
%save
if savingMode == 1 && savingMode == 0
    error('savingMode is not boolean. Try change input values');
end
%description
description = convertStringsToChars(description);
if ~ischar(description)
    error('description is not string or char. Try change input values');
end
%mode_flame
mode_flame = convertStringsToChars(mode_flame);
if ~ischar(mode_flame)
    error('description is not string or char. Try change input values');
end
%% Инмциализация компонентов оптической системы
%Все размеры взяты из чертежа
%Соднание обйекта класса
bench = Bench;

%Добавление входной апертуры
%Координаты апертуры
L = [2 0 0];
L1 = [2 1.5 0];
%Создание объекта апертура 
aper = Aperture( [ 2 0 0 ], [3 30] );
%Добавление в структуру
bench.append( aper );

%Координаты апертуры
L_1 = [40.38 0 0];
%Создание объекта апертура 
aper1 = Aperture( L_1, [3.5 30] );
bench.append( aper1 );

%Добавление плоского сапфира
%Использован объект линза с радиусом на много порядков больше размера
%сапфира 
sapphire_in = Lens( [ 65.8 0 0 ], 20.5, 99999999999999, 0, { 'air' 'sapphire' } );
bench.append( sapphire_in ); 
sapphire_out = Lens( [ 72.8 0 0 ], 20.5, 999999999999999, 0, { 'sapphire' 'air' } ); 
bench.append( sapphire_out ); 

shild = Aperture( [ 135 0 0 ], [0 5] );
bench.append( shild ); 

%Добавление плоского сапфира
sapphire1_in = Lens( [ 138.6 0 0 ], 20.5, 99999999999999, 0, { 'air' 'sapphire' } ); 
bench.append( sapphire1_in ); 
sapphire1_out = Lens( [ 140.6 0 0 ], 20.5, 999999999999999, 0, { 'sapphire' 'air' } ); 
bench.append( sapphire1_out ); 

%Добавление дуплета линз
lens1 = Lens( [ 143 0 0 ], 20.5, 312.80, 0, { 'air' 'n-kzfs8' } );
bench.append( lens1 ); 
lens2 = Lens( [ 147 0 0 ], 20.5, 45.88, 0, { 'n-kzfs8' 'air' } );
bench.append( lens2 ); 
lens3 = Lens( [ 148 0 0 ], 20.5, 46.58, 0, { 'air' 'n-ssk2' } ); 
bench.append( lens3 ); 
lens4 = Lens( [ 152 0 0 ], 20.5, -96.25, 0, { 'n-ssk2' 'air' } );
bench.append( lens4 ); 


%Добавление дуплета линз
lens5 = Lens( [ 157.65 0 0 ], 20.5, 211.55, 0, { 'air' 'n-ssk2' } ); 
bench.append( lens5 );
lens6 = Lens( [ 161.65 0 0 ], 20.5, -34.81, 0, { 'n-ssk2' 'air' } );
bench.append( lens6 ); 
lens7 = Lens( [ 162.65 0 0 ], 20.5, -33.69, 0, { 'air' 'n-kzfs5' } ); 
bench.append( lens7 ); 
lens8 = Lens( [ 166.65 0 0 ], 20.5, -199.82, 0, { 'n-kzfs5' 'air' } );
bench.append( lens8 ); 

%Добавление плоского сапфира
sapphire2_in = Lens( [ 169 0 0 ], 20.5, 99999999999999, 0, { 'air' 'sapphire' } ); 
bench.append( sapphire2_in ); 
sapphire2_out = Lens( [ 171 0 0 ], 20.5, 999999999999999, 0, { 'sapphire' 'air' } ); 
bench.append( sapphire2_out );
%Расчет координат волокна
load y1.mat y2
%Диапазон рабочей области 
y_cord = 0:126/(number_nodes-1):126;
fiber_cord = zeros(size(y_cord));
for i = 1:length(y_cord)
    [~, fiber_cord(i)] = min(abs(y2 - y_cord(i)));
end
%Диапазон координат волокна
Result_for_matlab = fiber_cord/length(y2).*(366.5-284)+284;
%Добавление ошибки позиционирования
fiber_coord = Result_for_matlab  - error_position+error_position*rand(length(Result_for_matlab),1)';
number_coord_fiber = length(fiber_coord);
%Создание объекта волокно в общей структуре
scr = 'screen';
for i= 1:number_coord_fiber
    Var_str = [scr,num2str(i)];
    Str1 = ' = Screen( [ ';
    Str2 = ' 0 0 ], 0.2, 0.2, 1025, 1025 );';
    Var1_str = [Str1,num2str(fiber_coord(i)), Str2];
    eval ([Var_str Var1_str]);
    Str3 = 'bench.append(';
    Str4 = ');';
    Var2_str = [Str3,Var_str,Str4];
    eval (Var2_str);
end

%Создание сетки источников излучения
ligth_start_coordY = 10:-0.1:0;
ligth_start_coordX = -y_cord(end:-1:1);

%Моделирование распределения
if mode_flame == "gaus"
    SKO = sqrt(150);
    a = 1/(SKO*sqrt(2*pi));
    c = SKO;
    b = matoh;
    distribution = a * exp(-(ligth_start_coordX - b).^2/(2*c.^2));
elseif mode_flame == "equable"
    distribution = ones(size(ligth_start_coordX)); 
else
    error('alяRм');
end
%Создание матрицы координат узлов для параллельного вычисления
ligth_coord = zeros((length(ligth_start_coordX)-1)+(length(ligth_start_coordY)-1)*length(ligth_start_coordX),2);
sparial = zeros((length(ligth_start_coordX)-1)+(length(ligth_start_coordY)-1)*length(ligth_start_coordX),1);
for i = 1:length(ligth_start_coordY)
    for j = 1:length(ligth_start_coordX)
        ligth_coord(j + (i-1)*length(ligth_start_coordX),2)=ligth_start_coordY(i);
        ligth_coord(j + (i-1)*length(ligth_start_coordX),1)=ligth_start_coordX(j);
        sparial(j + (i-1)*length(ligth_start_coordX))= distribution(j);
    end
end
Coord_ligth = [ ligth_coord(:,1) ligth_coord(:,2) zeros(size(ligth_coord,1),1) ];

%Коэффициент нормирования мощности
N_vector = [L(1)-Coord_ligth(:,1) L(2)-Coord_ligth(:,2) L(3)-Coord_ligth(:,3)];
AL1 = [L1(1)-Coord_ligth(:,1) L1(2)-Coord_ligth(:,2) L1(3)-Coord_ligth(:,3)];
absAL1 = sqrt(AL1(:,1).^2 + AL1(:,2).^2 + AL1(:,3).^2);
L1N = [N_vector -((N_vector(:,1))*L1(1)+(N_vector(:,2))*L1(2)+(N_vector(:,3))*L1(3))];
absLINA = abs(L1N(:,1).*Coord_ligth(:,1) + L1N(:,2).*Coord_ligth(:,2) + L1N(:,3).*Coord_ligth(:,3) + L1N(:,4))./sqrt(L1N(:,1).^2 + L1N(:,2).^2 + L1N(:,3).^2);
NL1 = sqrt(absAL1.^2 - absLINA.^2);
MM = 2*NL1./absLINA;
POWER = (2*atan(MM/2))/6.28319;

%% Параллельное вычисление
tic
for j = 1:size(ligth_coord,1)
    %Количество лучей 
    nrays = 100000;
    %Трассирование лучей
    rays_in = Rays( nrays, 'source', Coord_ligth(j,:), N_vector(j,:), MM(j), 'pentile' );
    bench.trace( rays_in );
    %Подсчет лучей попавших в волокно
    for i = 1:number_coord_fiber
        screen_res = bench.elem(17+i);
        sres(j,i) = sum(screen_res{1,1}.image,'all')*POWER(j)* sparial(j);
    end
end
toc

%% Обработка результатов моделирования
%Преобразование результатов моделирования в вид матрицы
Y = 1;
result = zeros(length(ligth_start_coordY),length(ligth_start_coordX),size(sres,2));
for i = 1:size(sres,1)
    result(Y,i-(Y-1)*length(ligth_start_coordX),:) = sres(i,:);
    if rem(i,length(ligth_start_coordX)) == 0
        Y = Y + 1;
    end
end
%%
Int_result = zeros(size(result));
for i = 1:size(result,1)
    Int_result(i,:,:) = 2*pi*0.1*ligth_start_coordY(i)*result(i,:,:);
end
Int_result_sum = sum(Int_result,1);
res_matrix(:,:) = Int_result_sum(1,:,:);

%Сохранение
if savingMode
    name_file = strcat(description, 'model','.mat');
    save(name_file, 'result', 'res_matrix', 'ligth_start_coordX');
end