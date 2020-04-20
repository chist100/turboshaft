function [ligth_source_lens] = refraction(N, ligth_inlens, cXY, X0, lens_radius)
    perpK = (cXY(:,2))./(cXY(:,1) - X0);
    omega1 = atan(abs((perpK - ligth_inlens(:,1))./(1 + ligth_inlens(:,1) .* perpK)));
    omega2 = zeros(size(cXY,1),1);
    omega2(cXY(:,2) > 0,1) = sign(lens_radius)*(-asin(N(1)/N(2)*sin(omega1(cXY(:,2) > 0))));
    omega2(cXY(:,2) <= 0,1) = sign(lens_radius)* asin(N(1)/N(2)*sin(omega1(cXY(:,2) <= 0)));
    ligth_source_lens = zeros(size(cXY,1),2);
    ligth_source_lens(:,1) = tan(atan(perpK) - omega2);
    ligth_source_lens(:,2) = cXY(:,2) - ligth_source_lens(:,1) .* cXY(:,1);
end