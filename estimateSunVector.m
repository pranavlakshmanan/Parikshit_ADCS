
function sun_vector = estimateSunVector(currents, normals)
    % Inputs:
    %   currents - Nx1 array of measured sensor currents (in Amperes)
    %   normals  - Nx3 matrix of sensor normal vectors (each row is a unit vector)
    %
    % Output:
    %   sun_vector - 1x3 unit vector representing the estimated sun direction
   
  
    
    % Multiply each sensor normal by its corresponding measured current
    weighted_normals = normals .* currents;
    
    % Sum the weighted normals
    v = sum(weighted_normals, 1);
    
    % Normalize to obtain the unit sun vector (handle the zero vector case)
    if norm(v) == 0
        sun_vector = [0, 0, 0];
    else
        sun_vector = v / norm(v);
    end
end
