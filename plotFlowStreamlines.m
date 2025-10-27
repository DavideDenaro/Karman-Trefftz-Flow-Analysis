function plotFlowStreamlines(ax, params, transformData, potentialData)

    % Clear and prepare axes
    cla(ax, 'reset');
    hold(ax, 'on');
    grid(ax, 'off');
    axis(ax, 'square');

    % Plot contour streamlines
    levels = 55;
    [C1_KT,~] = contour(ax, real(transformData.Z_KT), imag(transformData.Z_KT), imag(potentialData.Wmesh), levels, 'b', 'LineWidth', 1);
    
    % Fix aspect ratio
    set(ax, 'DataAspectRatio', [1 1 1], 'PlotBoxAspectRatio', [1 1 1]);

    % Get arrow contour line data
    contourLines = getContourLineCoordinates(C1_KT);
    groupsAll = contourLines.Group;
    Xdata = contourLines.X;
    Ydata = contourLines.Y;

    % Increase parameters for performance (reduce number of arrows)
    n = 4;
    groups_with_arrows = 1:n:levels;    % one every n levels
    arrow_spacing = 250;                % one arrow every arrow_spacing steps

    z_null = 0;  % For 2D arrow plotting

    % Loop through precomputed arrow data to plot arrows
    nLines = height(contourLines);
    for j = 1:arrow_spacing : nLines - 1
        if ismember(groupsAll(j), groups_with_arrows)
            % Get start point from pre-converted arrays
            x_start = Xdata(j);
            y_start = Ydata(j);
            x_end   = Xdata(j+1);
            y_end   = Ydata(j+1);
            p1 = [x_start, y_start, z_null];
            p2 = [x_end,   y_end,   z_null];

            arrow3(p1, p2, 'b', 0.3, 0.9);
        end
    end
    
    % Stagnation points
    if params.aux == 0
        contour(ax, real(transformData.Z_KT), imag(transformData.Z_KT), imag(potentialData.Wmesh), [params.v_psi0 params.v_psi0], 'b', 'LineWidth', 3);
        sp1 = plot(ax, real(transformData.Z_KTA), imag(transformData.Z_KTA), 'r*', 'LineWidth', 2);
        if isfield(transformData, 'Z_KTB')
            sp2 = plot(ax, real(transformData.Z_KTB), imag(transformData.Z_KTB), 'r*', 'LineWidth', 2);
        end
    elseif params.aux == 1
        contour(ax, real(transformData.Z_KT), imag(transformData.Z_KT), imag(potentialData.Wmesh), [params.v_psi0 params.v_psi0], 'b', 'LineWidth', 3);
        plot(ax, real(transformData.Z_KTA), imag(transformData.Z_KTA), 'r*', 'LineWidth', 2);
    elseif params.aux == 2
        contour(ax, real(transformData.Z_KT), imag(transformData.Z_KT), imag(potentialData.Wmesh), [params.psi_cappio params.psi_cappio], 'b', 'LineWidth', 3);
        plot(ax, real(transformData.Z_KTA), imag(transformData.Z_KTA), 'r*', 'LineWidth', 2);
    end
    plot(ax, real(transformData.z_profile_KT), imag(transformData.z_profile_KT), '-k', 'LineWidth', 4);
    if params.fill_bool
        fill(ax, real(transformData.z_profile_KT), imag(transformData.z_profile_KT), 'k');
    else
        fill(ax, real(transformData.z_profile_KT), imag(transformData.z_profile_KT), 'w');    
    end
    if params.aux == 0
        uistack([sp1, sp2], 'top')
    else
    end

    xlabel(ax, 'x'); ylabel(ax, 'iy');
    xlim(ax, [-6*params.MM 6*params.MM]); ylim(ax, [-6*params.MM 6*params.MM]);
    hold(ax, 'off');
    
end