function filterData = filterTransformedMesh(params, transformData, potentialData)
    
    % This function is necessary to exclude rogue points

    % Masking the range
    rangeMin = -7*params.MM;
    rangeMax = 7*params.MM;
    Z_KT_real = real(transformData.Z_KT);
    Z_KT_imag = imag(transformData.Z_KT);
    mask_range = (Z_KT_real >= rangeMin) & (Z_KT_real <= rangeMax) & ...
                 (Z_KT_imag >= rangeMin) & (Z_KT_imag <= rangeMax);
    
    mask_final = mask_range;
    
    filterData.Z_KT_Filtered = transformData.Z_KT;
    filterData.Z_KT_Filtered(~mask_final) = NaN;
    filterData.pressure_magnitude_filtered = potentialData.pressure_magnitude;
    filterData.pressure_magnitude_filtered(~mask_final) = NaN;
    
end
