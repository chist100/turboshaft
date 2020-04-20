function [sres] = FunctionToFPGA(LIGTHCoord,firstScreenCoord)
%FUNCTIONTOFPGA Summary of this function goes here
%   Detailed explanation goes here
bench = Bench;
L = [2 0 0];
L1 = [2 10 0];
%Создание объекта апертура 
aper = Aperture( L, [20 40] );
%Добавление в структуру
bench.append( aper );

%Координаты апертуры
L_1 = [20.5 0 0];
%Создание объекта апертура 
aper1 = Aperture( L_1, [16 40] );
bench.append( aper1 );

%Добавление плоского сапфира
%Использован объект линза с радиусом на много порядков больше размера
%сапфира 
sapphire_in = Lens( [ 95 0 0 ], 18, 99999999999999, 0, { 'air' 'sapphire' } );
bench.append( sapphire_in ); 
sapphire_out = Lens( [ 102 0 0 ], 18, 999999999999999, 0, { 'sapphire' 'air' } ); 
bench.append( sapphire_out ); 

shild = Aperture( [ 160 0 0 ], [0 9] );
bench.append( shild ); 

%Добавление плоского сапфира
sapphire1_in = Lens( [ 161 0 0 ], 25.4, 99999999999999, 0, { 'air' 'sapphire' } ); 
bench.append( sapphire1_in ); 
sapphire1_out = Lens( [ 163 0 0 ], 25.4, 999999999999999, 0, { 'sapphire' 'air' } ); 
bench.append( sapphire1_out ); 

%Добавление дуплета линз
lens1 = Lens( [ 165 0 0 ], 20.5, 199.82, 0, { 'air' 'n-kzfs5' } );
bench.append( lens1 ); 
lens2 = Lens( [ 169 0 0 ], 20.5, 33.69, 0, { 'n-kzfs5' 'air' } );
bench.append( lens2 ); 
lens3 = Lens( [ 170.05 0 0 ], 20.5, 34.81, 0, { 'air' 'n-ssk2' } ); 
bench.append( lens3 ); 
lens4 = Lens( [ 174.05 0 0 ], 20.5, -211.55, 0, { 'n-ssk2' 'air' } );
bench.append( lens4 ); 


%Добавление дуплета линз
lens5 = Lens( [ 181.65 0 0 ], 20.5, 96.25, 0, { 'air' 'n-ssk2' } ); 
bench.append( lens5 );
lens6 = Lens( [ 185.65 0 0 ], 20.5, -46.58, 0, { 'n-ssk2' 'air' } );
bench.append( lens6 ); 
lens7 = Lens( [ 186.67 0 0 ], 20.5, -45.88, 0, { 'air' 'n-kzfs8' } ); 
bench.append( lens7 ); 
lens8 = Lens( [ 190.67 0 0 ], 20.5, -312.80, 0, { 'n-kzfs8' 'air' } );
bench.append( lens8 ); 

%Добавление плоского сапфира
sapphire2_in = Lens( [ 192.67 0 0 ], 25.4, 99999999999999, 0, { 'air' 'sapphire' } ); 
bench.append( sapphire2_in ); 
sapphire2_out = Lens( [ 194.67 0 0 ], 25.4, 999999999999999, 0, { 'sapphire' 'air' } ); 
bench.append( sapphire2_out );

%Расчет координат волокна
screen1 = Screen( [ firstScreenCoord 0 0 ], 0.4, 0.4, 1025, 1025 );
bench.append(screen1);

%Создание сетки источников излучения
ligth_start_coordY = 10:-0.1:0;
ligth_start_coordX = LIGTHCoord;


%Коэффициент нормирования мощности
N_vector = [L(1)-1 L(2)-1 L(3)-0];
AL1 = [L1(1)-1 L1(2)-ligth_start_coordY L1(3)-0];
absAL1 = sqrt(AL1(:,1).^2 + AL1(:,2).^2 + AL1(:,3).^2);
L1N = [N_vector -((N_vector(:,1))*L1(1)+(N_vector(:,2))*L1(2)+(N_vector(:,3))*L1(3))];
absLINA = abs(L1N(:,1).*1 + L1N(:,2).*ligth_start_coordY + L1N(:,3).*0 + L1N(:,4))./sqrt(L1N(:,1).^2 + L1N(:,2).^2 + L1N(:,3).^2);
NL1 = sqrt(absAL1.^2 - absLINA.^2);
MM = 2*NL1./absLINA;
POWER = (2*atan(MM/2))/6.28319;

nrays = 100000;
%Трассирование лучей
rays_in = Rays( nrays, 'source', [ligth_start_coordX ligth_start_coordY 0], N_vector, MM, 'pentile' );
bench.trace( rays_in );
screen_res = bench.elem(18);
%Подсчет лучей попавших в волокно
sres = sum(screen_res{1,1}.image,'all')*POWER;
end

