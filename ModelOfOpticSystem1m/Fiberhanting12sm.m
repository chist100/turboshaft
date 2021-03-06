function [LossPosition,REALSHITLOSS, firstScreenCoord,step_coord,rays] = Fiberhanting12sm(LIGTHCoord, maxEra)
%FIBER HANTING  Summary of this function goes here
%   Detailed explanation goes here

bench = Bench;

%���������� ������� ��������
%���������� ��������
L = [2 0 0];
L1 = [2 1.5 0];
%�������� ������� �������� 
aper = Aperture( L, [3 30] );
%���������� � ���������
bench.append( aper );

%���������� ��������
L_1 = [40.38 0 0];
%�������� ������� �������� 
aper1 = Aperture( L_1, [3.5 30] );
bench.append( aper1 );

%���������� �������� �������
%����������� ������ ����� � �������� �� ����� �������� ������ �������
%������� 
sapphire_in = Lens( [ 65.8 0 0 ], 20.5, 99999999999999, 0, { 'air' 'sapphire' } );
bench.append( sapphire_in ); 
sapphire_out = Lens( [ 72.8 0 0 ], 20.5, 999999999999999, 0, { 'sapphire' 'air' } ); 
bench.append( sapphire_out ); 

shild = Aperture( [ 135 0 0 ], [0 5] );
bench.append( shild ); 

%���������� �������� �������
sapphire1_in = Lens( [ 138.6 0 0 ], 20.5, 99999999999999, 0, { 'air' 'sapphire' } ); 
bench.append( sapphire1_in ); 
sapphire1_out = Lens( [ 140.6 0 0 ], 20.5, 999999999999999, 0, { 'sapphire' 'air' } ); 
bench.append( sapphire1_out ); 

%���������� ������� ����
lens1 = Lens( [ 143 0 0 ], 20.5, 312.80, 0, { 'air' 'n-kzfs8' } );
bench.append( lens1 ); 
lens2 = Lens( [ 147 0 0 ], 20.5, 45.88, 0, { 'n-kzfs8' 'air' } );
bench.append( lens2 ); 
lens3 = Lens( [ 148 0 0 ], 20.5, 46.58, 0, { 'air' 'n-ssk2' } ); 
bench.append( lens3 ); 
lens4 = Lens( [ 152 0 0 ], 20.5, -96.25, 0, { 'n-ssk2' 'air' } );
bench.append( lens4 ); 


%���������� ������� ����
lens5 = Lens( [ 157.65 0 0 ], 20.5, 211.55, 0, { 'air' 'n-ssk2' } ); 
bench.append( lens5 );
lens6 = Lens( [ 161.65 0 0 ], 20.5, -34.81, 0, { 'n-ssk2' 'air' } );
bench.append( lens6 ); 
lens7 = Lens( [ 162.65 0 0 ], 20.5, -33.69, 0, { 'air' 'n-kzfs5' } ); 
bench.append( lens7 ); 
lens8 = Lens( [ 166.65 0 0 ], 20.5, -199.82, 0, { 'n-kzfs5' 'air' } );
bench.append( lens8 ); 

%���������� �������� �������
sapphire2_in = Lens( [ 169 0 0 ], 20.5, 99999999999999, 0, { 'air' 'sapphire' } ); 
bench.append( sapphire2_in ); 
sapphire2_out = Lens( [ 171 0 0 ], 20.5, 999999999999999, 0, { 'sapphire' 'air' } ); 
bench.append( sapphire2_out );


firstScreenCoord = 180;
step_coord = 1;
for i = 1:step_coord:maxEra
    screen1 = Aperture( [ (firstScreenCoord+i) 0 0 ], [0, 2]);
    bench.append(screen1);
end
% screen1 = Screen( [ firstScreenCoord 0 0 ], 0.2, 0.2, 1025, 1025 );
% bench.append(screen1);

%�������� ����� ���������� ���������
ligth_start_coordY = 10:-0.1:0;
% ligth_start_coordY = 0.1;
ligth_start_coordX = LIGTHCoord;


%����������� ������������ ��������

ligth_coord = zeros((length(ligth_start_coordX)-1)+(length(ligth_start_coordY)-1)*length(ligth_start_coordX),2);
for i = 1:length(ligth_start_coordY)
    for j = 1:length(ligth_start_coordX)
        ligth_coord(j + (i-1)*length(ligth_start_coordX),2)=ligth_start_coordY(i);
        ligth_coord(j + (i-1)*length(ligth_start_coordX),1)=ligth_start_coordX(j);
    end
end
Coord_ligth = [ ligth_coord(:,1) ligth_coord(:,2) zeros(size(ligth_coord,1),1) ];

%����������� ������������ ��������
N_vector = [L(1)-Coord_ligth(:,1) L(2)-Coord_ligth(:,2) L(3)-Coord_ligth(:,3)];
AL1 = [L1(1)-Coord_ligth(:,1) L1(2)-Coord_ligth(:,2) L1(3)-Coord_ligth(:,3)];
absAL1 = sqrt(AL1(:,1).^2 + AL1(:,2).^2 + AL1(:,3).^2);
L1N = [N_vector -((N_vector(:,1))*L1(1)+(N_vector(:,2))*L1(2)+(N_vector(:,3))*L1(3))];
absLINA = abs(L1N(1)*Coord_ligth(:,1) + L1N(2)*Coord_ligth(:,2) + L1N(3)*Coord_ligth(:,3) + L1N(4))/sqrt(L1N(1)^2 + L1N(2)^2 + L1N(3)^2);
NL1 = sqrt(absAL1.^2 - absLINA.^2);
MM = 2*NL1./absLINA;
POWER = (2*atan(MM/2))/6.28319;
%% ������������ ����������
LossPosition = zeros(size(ligth_start_coordY,1),maxEra);
for j = 1:length(ligth_start_coordY)
    nrays = 100000;
    %������������� �����
    
    rays_in = Rays( nrays, 'source', Coord_ligth(j,:), N_vector(j,:), MM(j), 'pentile' );
    rays = bench.trace( rays_in );
    %������� ����� �������� � �������
    for i = 1:1:maxEra
        LossPosition(j,i) = (length(rays(1, 18+i).miss) - sum(rays(1, 18+i).miss))*POWER(j);
    end
end
REALSHITLOSS = sum(LossPosition,1);
%% create some rays
% nrays = 400;
% Coord_ligth = [-30 0 0];
% 
% N_vector = [L(1)-Coord_ligth(1) L(2)-Coord_ligth(2) L(3)-Coord_ligth(3)];
% AL1 = [L1(1)-Coord_ligth(1) L1(2)-Coord_ligth(2) L1(3)-Coord_ligth(3)];
% absAL1 = sqrt(AL1(:,1).^2 + AL1(:,2).^2 + AL1(:,3).^2);
% L1N = [N_vector -((N_vector(:,1))*L1(1)+(N_vector(:,2))*L1(2)+(N_vector(:,3))*L1(3))];
% absLINA = abs(L1N(1)*Coord_ligth(1) + L1N(2)*Coord_ligth(2) + L1N(3)*Coord_ligth(3) + L1N(4))/sqrt(L1N(1)^2 + L1N(2)^2 + L1N(3)^2);
% NL1 = sqrt(absAL1.^2 - absLINA.^2);
% MM = 2*NL1./absLINA;
% rays_in = Rays( nrays, 'source', Coord_ligth, N_vector, MM, 'pentile' );
% rays_through = bench.trace( rays_in );
% bench.draw( rays_through, 'lines' );
end
