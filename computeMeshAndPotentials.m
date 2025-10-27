function [meshData, potentialData] = computeMeshAndPotentials(params)

    % Mesh
    x = linspace(-params.plotRange, params.plotRange, round(400*params.resFactor));
    y = linspace(-params.plotRange, params.plotRange, round(400*params.resFactor));
    [X, Y] = meshgrid(x, y);
    Z = X + 1i*Y;
    
    % Potential functions
    W  = @(z) (abs(z) > params.r0) .* (params.v_inf*z*exp(-1i*params.alfa) + ...
             (params.v_inf*params.r0^2)./z*exp(1i*params.alfa) - 1i*params.Gamma/(2*pi)*log(z));
    dW = @(z) (abs(z) > params.r0) .* (params.v_inf*exp(-1i*params.alfa) - ...
             (params.v_inf*params.r0^2)./(z.^2)*exp(1i*params.alfa) - 1i*params.Gamma/(2*pi)./z);
    
    % Compute potential and velocity
    Wmesh = W(Z - params.z_center);
    Vmesh = dW(Z - params.z_center);
    velocity_magnitude = abs(Vmesh);
    pressure_magnitude = params.p_inf + 0.5*params.rho*(params.v_inf^2 - velocity_magnitude.^2);
    
    meshData.X = X;
    meshData.Y = Y;
    meshData.Z = Z;
    
    potentialData.Wmesh = Wmesh;
    potentialData.Vmesh = Vmesh;
    potentialData.velocity_magnitude = velocity_magnitude;
    potentialData.pressure_magnitude = pressure_magnitude;
    
end
