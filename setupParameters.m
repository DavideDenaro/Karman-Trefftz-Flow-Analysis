function params = setupParameters(newKutta, newFill, newVelocity, newPressure, newDensity, newAngleOfAttack, newJoukowski, newKrmnTrefftz, newThickness, newCamber)

    % Default values are given in input via the app

    % User parameters                                   % Default values:
    params.kutta       = newKutta;                      % true
    params.fill_bool   = newFill;                       % true
    params.v_inf       = newVelocity;                   % 1
    params.p_inf       = newPressure;                   % 101325
    params.rho         = newDensity;                    % 1.225
    params.alfa_grad   = newAngleOfAttack;              % 20
    params.alfa        = deg2rad(params.alfa_grad);
    params.c           = newJoukowski;                  % 1
    params.k           = newKrmnTrefftz;                % 1.95
    params.center_x    = newThickness;                  % -0.05
    params.center_y    = newCamber;                     % 0.15
    
    % Derived parameters
    params.z_center = params.center_x + 1i*params.center_y;    
    params.r0 = sqrt(((-params.center_x+params.c)^2) + params.center_y^2);
    params.MM = max(params.r0, abs(params.c));
    params.A  = 4*pi*params.v_inf*params.r0;
    
    % Kutta condition and circulation
    cos_alfa0 = (params.c - params.center_x)/params.r0;
    sin_alfa0 = -params.center_y/params.r0;
    alfa0 = angle(cos_alfa0 + 1i*sin_alfa0);
    Gamma_Kutta = -4*pi*params.r0*params.v_inf*sin(params.alfa - alfa0);
    if params.kutta
        params.Gamma = Gamma_Kutta;
    else
        params.Gamma = 0;
    end
    params.v_psi0 = -params.Gamma/(2*pi)*log(params.r0);
    
    % Stagnation point analysis
    params.aux = -1;
    if params.Gamma == 0
        params.theta_A = pi + params.alfa;
        params.theta_B = params.alfa;
        params.aux = 0;
    elseif abs(params.Gamma) < params.A
        params.theta_B = asin(params.Gamma/params.A) + params.alfa;
        params.theta_A = pi - asin(params.Gamma/params.A) + params.alfa;
        params.aux = 0;
    elseif params.Gamma == params.A
        params.theta_A = pi/2 + params.alfa;
        params.aux = 1;
    elseif params.Gamma == -params.A
        params.theta_A = 3*pi/2 + params.alfa;
        params.aux = 1;
    elseif params.Gamma/params.A < -1
        params.theta_A = params.alfa + 3*pi/2;
        p = [1, params.Gamma/(2*pi*params.v_inf), params.r0^2];
        radici = roots(p);
        params.r_cappio = max(radici);
        params.psi_cappio = (params.v_inf*params.r_cappio - params.v_inf*params.r0^2/params.r_cappio)*sin(3*pi/2) - params.Gamma/(2*pi)*log(params.r_cappio);
        params.aux = 2;
    elseif params.Gamma/params.A > 1
        params.theta_A = params.alfa + pi/2;
        p = [1, -params.Gamma/(2*pi*params.v_inf), params.r0^2];
        radici = roots(p);
        params.r_cappio = max(radici);
        params.psi_cappio = (params.v_inf*params.r_cappio - params.v_inf*params.r0^2/params.r_cappio)*sin(pi/2) - params.Gamma/(2*pi)*log(params.r_cappio);
        params.aux = 2;
    end
    
    % Mesh resolution and plotting range
    params.resFactor = 1;  
    params.plotRange = 7 * params.MM;
    
end
