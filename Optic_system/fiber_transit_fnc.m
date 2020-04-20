function [ligth_intensity] = fiber_transit_fnc(fiber_coord, fiber_size, ligth)

    Y_coord = ligth(:,1) * fiber_coord + ligth(:,2);
    ligth_intensity = sum(fiber_size >= abs(Y_coord),1);
%     ligth_intensity = zeros(length(fiber_coord),1);
%     for i = 1:length(fiber_coord)
%         ligth_intensity(i) = size(visor_transit_fnc(fiber_coord(i), fiber_size, ligth, true),1);
%     end
end
