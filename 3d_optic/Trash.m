
% [X_mech, Y_mech] = meshgrid(ligth_start_coordY, ligth_start_coordX);
% mesh(X_mech, Y_mech,result(:,:,1))
% ylim([ligth_start_coordX(1) ligth_start_coordX(end)]);
% xlim([ligth_start_coordY(1) ligth_start_coordY(end)]);

% plot(res);
% figure( 'Name', 'Image on the screen', 'NumberTitle', 'Off' );
% imshow( screen.image, [] );

% number_of_frame = 5;
% vres = res(:,:,(sres>0))./max(res(:,:,(sres>0)),[],'all');
% map = ones(256,3);
% map(:,3) = 1/256:1/256:1;
% map(:,2) = 1:-1/256:1/256;
% map(1,:) = [0,0,0];
% Video = VideoWriter('FILM.avi','Indexed AVI');
% Video.Colormap  = map;
% open(Video)
% vres = vres./max(vres,[],'all')*255;
% vres = fix(vres);
% for i = number_of_frame:(size(vres,3)*number_of_frame)
%     writeVideo(Video,vres(:,:,idivide(int32(i),int32(number_of_frame))))
% end
% close(Video)


%% create some rays
% nrays = 200;
% Coord_ligth = [0 0 0 ];
% N_vector = [L(1)-Coord_ligth(1) L(2)-Coord_ligth(2) L(3)-Coord_ligth(3)];
% AL1 = [L1(1)-Coord_ligth(1) L1(2)-Coord_ligth(2) L1(3)-Coord_ligth(3)];
% absAL1 = sqrt(AL1(1)^2 + AL1(2)^2 + AL1(3)^2);
% L1N = [N_vector -((N_vector(1))*L1(1)+(N_vector(2))*L1(2)+(N_vector(3))*L1(3))];
% absLINA = abs(L1N(1)*Coord_ligth(1) + L1N(2)*Coord_ligth(2) + L1N(3)*Coord_ligth(3) + L1N(4))/sqrt(L1N(1)^2 + L1N(2)^2 + L1N(3)^2);
% NL1 = sqrt(absAL1^2 - absLINA^2);
% MM = 2*NL1/absLINA;
% rays_in = Rays( nrays, 'source', Coord_ligth, N_vector, MM, 'pentile' );
% rays_through = bench.trace( rays_in );
% bench.draw( rays_through, 'lines' );
