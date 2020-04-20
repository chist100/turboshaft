function [ cXY ] = crossing( ligth_inlens, X0, R )
% Находит пересечение линзы с лучом
    %%
    cXY = zeros(size(ligth_inlens,1),2);
    if R > 0
        cXY(:,1) = (-(2*ligth_inlens(:,1).*ligth_inlens(:,2)-2.*X0)-sqrt((2*ligth_inlens(:,2).*ligth_inlens(:,1)-2.*X0).^2-4*(1+ligth_inlens(:,1).^2).*(ligth_inlens(:,2).^2-R^2+X0^2)))./(2*(1+ligth_inlens(:,1).^2));
    else
        cXY(:,1) = (-(2*ligth_inlens(:,1).*ligth_inlens(:,2)-2.*X0)+sqrt((2*ligth_inlens(:,2).*ligth_inlens(:,1)-2.*X0).^2-4*(1+ligth_inlens(:,1).^2).*(ligth_inlens(:,2).^2-R^2+X0^2)))./(2*(1+ligth_inlens(:,1).^2));
    end
    cXY(:,2) = cXY(:,1) .* ligth_inlens(:,1) + ligth_inlens(:,2);
end


