function plotPressureAirfoil(ax, params, transformData, potentialData, ~)

    % Instead of directly contouring the filtered mesh, a regrid of the pressure
    % field is applied using scatteredInterpolant. In addition, extreme
    % values that are above a high percentile of the pressure data are clipped.
    
    cla(ax, 'reset');
    hold(ax, 'on');

    mask_existing = ~isnan(transformData.Z_KT);
    X_scattered = real(transformData.Z_KT(mask_existing));
    Y_scattered = imag(transformData.Z_KT(mask_existing));
    P_scattered = potentialData.pressure_magnitude(mask_existing);
    
    % Clip extreme pressure values
    P_threshold = prctile(P_scattered, 98.402);
    validMask = P_scattered <= P_threshold;
    X_scattered = X_scattered(validMask);
    Y_scattered = Y_scattered(validMask);
    P_scattered = P_scattered(validMask);
    
    % Create a scattered interpolant
    F = scatteredInterpolant(X_scattered, Y_scattered, P_scattered, 'natural', 'none');
    
    % Define a uniform grid
    rangeMin = -4.5*params.MM;
    rangeMax = 4.5*params.MM;
    xi = linspace(rangeMin, rangeMax, 200);
    yi = linspace(rangeMin, rangeMax, 200);
    [Xi, Yi] = meshgrid(xi, yi);
    P_interp = F(Xi, Yi);
    
    % Plot the interpolated pressure field
    % contourf(Xi, Yi, P_interp, 200, 'LineStyle', 'none');
    pcolor(ax, Xi, Yi, P_interp), shading(ax, 'interp');
    colormap(ax, 'turbo'); 
    c = colorbar(ax, 'southoutside');
    c.Label.String = 'Pa';
    c.Ticks = linspace(c.Limits(1), c.Limits(2), 5);
    c.TickLabels = compose('%.3e', c.Ticks);
    plot(ax, real(transformData.z_profile_KT), imag(transformData.z_profile_KT), '-k', 'LineWidth', 3);

    if params.fill_bool
        fill(ax, real(transformData.z_profile_KT), imag(transformData.z_profile_KT), 'k');
    else
        fill(ax, real(transformData.z_profile_KT), imag(transformData.z_profile_KT), 'w');
    end

    xlabel(ax, 'x'); ylabel(ax, 'iy');
    xlim(ax, [rangeMin, rangeMax]); ylim(ax, [rangeMin, rangeMax]);
    axis(ax, 'square');
    axis(ax, 'off');
    hold(ax, 'off');

end