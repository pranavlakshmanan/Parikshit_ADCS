
clear; clc;

%% Define Parameters
E = 25;                 % Incident irradiance (mW/cm^2)(Assuming ideal conditions)
E_ref = 25;             % Reference irradiance (mW/cm^2)
I0 = 135e-6;            % Nominal short-circuit current at E_ref and normal incidence (A)
acceptance_angle = 60;  % Sensor acceptance half-angle (degrees)
error_std = 0.15;       % Standard deviation for sensor error (15% multiplicative noise)

%% Define the True Sun Vector(ground Truth)
% This is the sun direction in the spacecraft's body frame.
sun_true = [0.5, 0.5, 0.7071];  
sun_true = sun_true / norm(sun_true);  % Normalize to obtain a unit vector

%% Sensor Orientations
% Sensors are assumed to be mounted on each of the 6 faces of the CubeSat.
normals = [
    1,  0,  0;   % +X face
   -1,  0,  0;   % -X face
    0,  1,  0;   % +Y face
    0, -1,  0;   % -Y face
    0,  0,  1;   % +Z face
    0,  0, -1;   % -Z face
];

numSensors = size(normals, 1);
measured_currents = zeros(numSensors, 1);

%% Compute Sensor Currents with Error
for i = 1:numSensors
    % cosine of the incidence angle between sensor normal and sun vector
    cos_angle = dot(normals(i,:), sun_true);
    angle_deg = acosd(cos_angle);
    
    % Check if the sensor is within the acceptance angle.
    % If not, assume no current is generated.
    if angle_deg <= acceptance_angle
        % Compute ideal current based on cosine law
        I_ideal = I0 * (E / E_ref) * cosd(angle_deg);
    else
        I_ideal = 0;
    end
    
    % Introduce sensor error (multiplicative noise)
    noise_factor = 1 + error_std * randn;
    measured_currents(i) = I_ideal * noise_factor;
    
    % Ensure that current remains non-negative(sensors cannot produce
    % negative current , which will mean irridance is negative , which is
    % not possible
    if measured_currents(i) < 0
        measured_currents(i) = 0;
    end
end

%% Estimate the Sun Vector from Sensor Measurements
estimated_vector = estimateSunVector(measured_currents, normals);

%% Display vector
disp('True Sun Vector:');
disp(sun_true);
disp('Estimated Sun Vector:');
disp(estimated_vector);
disp('Measured Sensor Currents (in microamps):');
disp(measured_currents * 1e6);
