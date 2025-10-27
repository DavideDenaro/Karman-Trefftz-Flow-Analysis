function plotVelocityAirfoil(ax, params, transformData, potentialData)

    cla(ax, 'reset');
    hold(ax, 'on');

    contourf(ax, real(transformData.Z_KT), imag(transformData.Z_KT), potentialData.velocity_magnitude, 200, 'LineColor', 'none');
    colormap(ax, 'turbo');
    c = colorbar(ax, 'southoutside');
    c.Label.String = 'm/s';
    c.Ticks = linspace(c.Limits(1), c.Limits(2), 5);
    c.TickLabels = compose('%.2f', c.Ticks);
    plot(ax, real(transformData.z_profile_KT), imag(transformData.z_profile_KT), 'k', 'LineWidth', 5);

    if params.fill_bool
        fill(ax, real(transformData.z_profile_KT), imag(transformData.z_profile_KT), 'k');
    else
        fill(ax, real(transformData.z_profile_KT), imag(transformData.z_profile_KT), 'w');
    end

    xlabel(ax, 'x'); ylabel(ax, 'iy');
    xlim(ax, [-4.5*params.MM 4.5*params.MM]); ylim(ax, [-4.5*params.MM 4.5*params.MM]);
    axis(ax, 'square');
    axis(ax, 'off');
    hold(ax, 'off');
    
end