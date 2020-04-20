%% ўиток

load('Test_bench')
visor_slot = visor_slot* ones(size(ligth,1),1);
[ligth_source_visor] = visor_transit_fnc(visor_coord, visor_slot, ligth, true);
