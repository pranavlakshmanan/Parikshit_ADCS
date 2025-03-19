
clear; clc;

%% Parameters
% Satellite dimensions
Lx = 10; Ly = 10; Lz = 20; % cm

% Sensor field-of-view parameters from the datasheet (SLCD-61N8)
fov_half_angle_deg = 60;         % acceptance half-angle in degrees
fov_half_angle_rad = deg2rad(fov_half_angle_deg);
cos_threshold = cos(fov_half_angle_rad);%This cos(0.5 rad) is the constraint beyond which sensor output=0,acts as checking condition 

% Number of Monte Carlo samples for sun directions
N_samples = 10000;

%% Generate Random Sun Directions (Uniformly on a Hemisphere)
% Generate random points on a sphere
sunDirs = randn(N_samples, 3);%Uses gaussian distribution to randomly generate a N_sample x 3 matrix of 3D points 
sunDirs = sunDirs ./ vecnorm(sunDirs, 2, 2);
% Restrict to one hemisphere (e.g., z >= 0) for 2π steradian coverage
sunDirs = sunDirs(sunDirs(:,3) >= 0, :);
N = size(sunDirs,1);

%% Define CubeSat Face Normals (Assuming sensors are mounted at face centers)
% For a rectangular prism, faces have normals:
faceNormals = [
    1, 0, 0;   % +x face
   -1, 0, 0;   % -x face
    0, 1, 0;   % +y face
    0,-1, 0;   % -y face
    0, 0, 1;   % +z face
    0, 0,-1];  % -z face

%% Evaluate Coverage for a Fixed Sensor Configuration
nSensors = 6;
sensorNormals = faceNormals;  %Assuming each sensor oriented along the face normal(can be changed and needs STMS updation)

% Check coverage for each sun direction
coverage = false(N, 1);
for i = 1:nSensors
    % Calculate dot product between sun directions and sensor normal
    dp = sunDirs * sensorNormals(i,:)';
    % A sun direction is covered if the angle is within the fov (i.e., dp >= cos_threshold)
    coverage = coverage | (dp >= cos_threshold);
end

%Our goal is to maximise this term as it deontes the amount of coverage
%of the sun vector hemisphere each sensor is seeing
coverageFraction = sum(coverage) / N;

fprintf('Coverage with %d sensors: %.2f%%\n', nSensors, coverageFraction*100);

%% Monte Carlo: Evaluate Varying Sensor Counts with Random Face Selections
sensorCounts = 1:6;
trials = 1000;
coverageResults = zeros(length(sensorCounts), trials);

for idx = 1:length(sensorCounts)
    nSensors = sensorCounts(idx);
    for t = 1:trials
        % Randomly choose nSensors faces (with replacement or without, as needed)
      
        selectedFaces = randi(6, nSensors, 1);
        sensorNormalsTrial = faceNormals(selectedFaces, :);
        covered = false(N,1);
        for j = 1:nSensors
            dp = sunDirs * sensorNormalsTrial(j,:)';
            covered = covered | (dp >= cos_threshold);
        end
        coverageResults(idx, t) = sum(covered) / N;
    end
end

% Compute average coverage for each sensor count
meanCoverage = mean(coverageResults, 2);
fprintf('\nMean Coverage for Different Sensor Counts:\n');
for idx = 1:length(sensorCounts)
    fprintf('%d sensor(s): %.2f%%\n', sensorCounts(idx), meanCoverage(idx)*100);
end

%% Visualization 
% Visualize the sun directions and the sensor cone for one sensor on the +z face.
figure; hold on; grid on; axis equal;
% Plot a subset of sun directions
quiver3(zeros(100,1), zeros(100,1), zeros(100,1), sunDirs(1:100,1), sunDirs(1:100,2), sunDirs(1:100,3), 0, 'b');
xlabel('X'); ylabel('Y'); zlabel('Z');
title('Random Sun Directions and Sensor Field-of-View');

% Plot the sensor's normal vector
sensor_normal = [0 0 1];
quiver3(0, 0, 0, sensor_normal(1), sensor_normal(2), sensor_normal(3), 0, 'r','LineWidth',2);

% Plot the sensor's field-of-view cone
[coneX, coneY, coneZ] = cylinder([0, tan(fov_half_angle_rad)], 50);
coneZ = coneZ * 2; 
surf(coneX, coneY, coneZ, 'FaceAlpha', 0.5, 'EdgeColor', 'none');

view(3);
hold off;
