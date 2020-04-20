function [ligth_source_lens, cXY] = lens_part_transit_fnc(N, ligth_source, lens_radius, lens_sizes, X0)
if lens_radius > 0
    visor_coord = X0 - sqrt((lens_radius)^2 - (lens_sizes)^2);
else
    visor_coord = X0 + sqrt((lens_radius)^2 - (lens_sizes)^2);
end
[ligth_inlens] = visor_transit_fnc(visor_coord, lens_sizes, ligth_source, true);
if isempty(ligth_inlens)
    ligth_source_lens = [];
    cXY = [];
    return
end
[cXY] = crossing(ligth_inlens, X0, lens_radius); 
[ligth_source_lens] = refraction(N, ligth_inlens, cXY, X0, lens_radius);
end