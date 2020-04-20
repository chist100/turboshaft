function [ligth_visor] = visor_transit_fnc(visor_coord, visor_slot, ligth, bool_v_s)
%visor_transit_fnc - возвращает структуру прошедших через щиток лучей
Y_coord = ligth(:,1) .* visor_coord + ligth(:,2);
if bool_v_s
    ligth(visor_slot < abs(Y_coord)) = NaN;
else 
    ligth(visor_slot > abs(Y_coord)) = NaN;
end
ligth_visor = ligth(isnan(ligth(:, 1)), :);
end