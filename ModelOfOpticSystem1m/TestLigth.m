clc
clear all
% close all
bench = Bench;

L = [2 0 0];
L1 = [2 10 0];

aper = Aperture( L, [0 10] );
%Добавление в структуру
bench.append( aper );

aper = Aperture( [5 0 0], [0 70] );
%Добавление в структуру
bench.append( aper );


nrays = 1000;
ligth_start_coordY = 0;
Coord_ligth = [0 0 0];

N_vector = [L(1)-Coord_ligth(1) L(2)-Coord_ligth(2) L(3)-Coord_ligth(3)];
AL1 = [L1(1)-Coord_ligth(1) L1(2)-Coord_ligth(2) L1(3)-Coord_ligth(3)];
absAL1 = sqrt(AL1(:,1).^2 + AL1(:,2).^2 + AL1(:,3).^2);
L1N = [N_vector -((N_vector(:,1))*L1(1)+(N_vector(:,2))*L1(2)+(N_vector(:,3))*L1(3))];
absLINA = abs(L1N(1)*Coord_ligth(1) + L1N(2)*Coord_ligth(2) + L1N(3)*Coord_ligth(3) + L1N(4))/sqrt(L1N(1)^2 + L1N(2)^2 + L1N(3)^2);
NL1 = sqrt(absAL1.^2 - absLINA.^2);
MM = 2*NL1./absLINA;
rays_in = Rays( nrays, 'source', Coord_ligth, N_vector, MM, 'pentile' );
rays_through = bench.trace( rays_in );
bench.draw( rays_through, 'lines' );
rays = bench.trace( rays_in );
LossPosition = sum(rays(1, 1).I);