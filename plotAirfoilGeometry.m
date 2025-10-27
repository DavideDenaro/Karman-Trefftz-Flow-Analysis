function plotAirfoilGeometry(ax, params, transformData, meshData)

    % Clear and prepare the axes
    cla(ax);
    hold(ax, 'on');
    grid(ax, 'on');
    axis(ax, 'equal');
    
    % Plot reference lines and circles
    plot(ax, [-2.5*params.MM 2.5*params.MM], [0 0], 'k', 'LineWidth', 0.5);
    plot(ax, [0 0], [-2.5*params.MM 2.5*params.MM], 'k', 'LineWidth', 0.5);
    plot(ax, real(transformData.z_circle), imag(transformData.z_circle), '-k', 'LineWidth', 1);
    plot(ax, real(transformData.z_profile_KT), imag(transformData.z_profile_KT), '-k', 'LineWidth', 3);
    plot(ax, real(params.z_center), imag(params.z_center), 'k+', 'LineWidth', 2);
    
    if params.center_x ~= 0
        m = params.center_y/(params.center_x - params.c);
        if params.c >= 0
            xx = linspace(-2.5*params.MM, params.c, 100);
        else
            xx = linspace(params.c, 2.5*params.MM, 100);
        end
        
        zz_center = 1i*(params.center_y - m*params.center_x);
        r1 = sqrt(params.c^2 + abs(zz_center)^2);
        theta_vec = transformData.theta_vec;
        zz_circle = zz_center + r1 * exp(1i*theta_vec);
        common_den = (zz_circle + params.c);
        zz_1 = (zz_circle - params.c) ./ common_den;
        zz_2 = zz_1.^params.k;
        zz_profile = ((1+zz_2)./(1-zz_2)) * params.k * params.c;
        
        % Average camber line
        x_c = real(zz_profile);
        y_c = imag(zz_profile);
        n_split = round(numel(x_c)/2);
        x_upper = x_c(1:n_split);
        y_upper = y_c(1:n_split);
        x_lower = x_c(n_split+1:end);
        y_lower = y_c(n_split+1:end);
        y_lower_interp = interp1(x_lower, y_lower, x_upper, 'linear', 'extrap');
        camber_x = [params.c*params.k, x_upper, -params.c*params.k];
        camber_y = [0, (y_upper+y_lower_interp)/2, 0];
        
        asse_L0 = m*xx + (params.center_y - m*params.center_x);
        
        plot(ax, real(zz_circle), imag(zz_circle), '--b', 'LineWidth', 1);
        plot(ax, real(zz_profile), imag(zz_profile), '--b', 'LineWidth', 1);
        plot(ax, camber_x, camber_y, '--m', 'LineWidth', 1);
        plot(ax, xx, asse_L0, '--r', 'LineWidth', 1);
        plot(ax, real(zz_center), imag(zz_center), 'b+', 'LineWidth', 2);
        plot(ax, params.c, 0, 'rd', 'LineWidth', 1);
        legend(ax, '', '', 'Original Circle', 'Kármán-Trefftz Airfoil', '', ...
               'Camber Line Skeleton', '', 'Camber Line', 'Zero-Lift Axis', ...
               'FontSize', 12, 'FontName', 'Times New Roman', 'Location', 'southeast');
    end
    xlabel(ax, 'x'); ylabel(ax, 'iy');
    xlim(ax, [-2.5*params.MM 2.5*params.MM]); ylim(ax, [-1.5*params.MM 1.5*params.MM]);
    hold(ax, 'off');
    
end
