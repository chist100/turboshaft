function [ligth_source_saphir] = saphir_transit_fnc(saphir_coord, saphir_thickness, N_s, saphir_sizes, ligth_source)
[ligth_visor] = visor_transit_fnc(saphir_coord, saphir_sizes, ligth_source, true);
if isempty(ligth_visor)
    ligth_source_saphir = [];
    return
end
cY = ligth_visor(:,1)* saphir_coord + ligth_visor(:,2);
omega1 = atan(ligth_visor(:,1));
omega2 = asin(1/N_s*sin(omega1(:)));
res = zeros(size(omega2,1),2);
res(:,1) = tan(omega2);
res(:,2) = cY - res(:,1) * saphir_coord;
[ligth_visor1] = visor_transit_fnc(saphir_coord + saphir_thickness, saphir_sizes, res, true);
if isempty(ligth_visor1)
    ligth_source_saphir = [];
    return
end
cY = ligth_visor1(:,1)* (saphir_coord + saphir_thickness) + ligth_visor1(:,2);
omega3 = atan(ligth_visor1(:,1));
omega4 = asin(N_s/1*sin(omega3));
ligth_source_saphir = zeros(size(omega4,1),2);
ligth_source_saphir(:,1) = tan(omega4);
ligth_source_saphir(:,2) = cY - ligth_source_saphir(:,1)* (saphir_coord + saphir_thickness);
end