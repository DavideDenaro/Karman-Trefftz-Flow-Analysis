function transformData = computeKTTransformation(params, meshData)

    % Generating circle
    theta_vec = linspace(0, 2*pi, 200);
    z_circle = params.z_center + params.r0*exp(1i*theta_vec);
    
    % 1. Moebius Transformation
    z1_circle = (z_circle - params.c)./(z_circle + params.c);
    Z1 = (meshData.Z - params.c)./(meshData.Z + params.c);
    % 2. Power Transformation
    z2_circle = z1_circle.^params.k;
    Z2 = Z1.^params.k;
    % 3. Final KT
    z_profile_KT = ((1+z2_circle)./(1-z2_circle)) * params.k * params.c;
    Z_KT = ((1+Z2)./(1-Z2)) * params.k * params.c;
    
    % Compute stagnation points
    if params.aux == 0
        Z1A = ((params.z_center + params.r0*exp(1i*params.theta_A)) - params.c)./((params.z_center + params.r0*exp(1i*params.theta_A)) + params.c);
        Z2A = Z1A.^params.k;
        Z_KTA = ((1+Z2A)./(1-Z2A)) * params.k * params.c;
        
        Z1B = ((params.z_center + params.r0*exp(1i*params.theta_B)) - params.c)./((params.z_center + params.r0*exp(1i*params.theta_B)) + params.c);
        Z2B = Z1B.^params.k;
        Z_KTB = ((1+Z2B)./(1-Z2B)) * params.k * params.c;
        transformData.Z_KTA = Z_KTA;
        transformData.Z_KTB = Z_KTB;
    elseif params.aux == 1
        Z1A = ((params.z_center + params.r0*exp(1i*params.theta_A)) - params.c)./((params.z_center + params.r0*exp(1i*params.theta_A)) + params.c);
        Z2A = Z1A.^params.k;
        Z_KTA = ((1+Z2A)./(1-Z2A)) * params.k * params.c;
        transformData.Z_KTA = Z_KTA;
    elseif params.aux == 2
        Z1A = ((params.z_center + params.r_cappio*exp(1i*params.theta_A)) - params.c)./((params.z_center + params.r_cappio*exp(1i*params.theta_A)) + params.c);
        Z2A = Z1A.^params.k;
        Z_KTA = ((1+Z2A)./(1-Z2A)) * params.k * params.c;
        transformData.Z_KTA = Z_KTA;
    end
    
    transformData.z_circle = z_circle;
    transformData.z_profile_KT = z_profile_KT;
    transformData.Z_KT = Z_KT;
    transformData.Z2 = Z2;
    transformData.theta_vec = theta_vec;

end
