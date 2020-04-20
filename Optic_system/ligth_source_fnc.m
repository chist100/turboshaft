function [ligth_source] = ligth_source_fnc(ligth_coord, ligth_start_angle, ligth_start_number_ray)
%ligth_source_fnc - возвращает матрицу из лучей от точечного  источника света
    k  = zeros(ligth_start_number_ray/2,1);
    delta_angle = ligth_start_angle/(ligth_start_number_ray/2);
    k(1:(ligth_start_number_ray/2),1) = tan((ligth_start_angle - delta_angle*(1:1:(ligth_start_number_ray/2)))*pi/180);
    k((ligth_start_number_ray/2+1):1:(ligth_start_number_ray),1) = -k(ligth_start_number_ray+1-((ligth_start_number_ray/2 +1):1:(ligth_start_number_ray)));
    b = ligth_coord(2) - k(1:ligth_start_number_ray) * ligth_coord(1);
    ligth_source = [k b];
end