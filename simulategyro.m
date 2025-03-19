function gyroOutput = simulategyro(angularRateTrue, fs, simTime)
   
    %Input - 

    % angularRateTrue: vector (or function) of true angular rates in deg/s
    % fs: sampling frequency (Hz)
    % simTime: total simulation time in seconds
    
    %Output-
    %Angular rate visualised
    
    dt = 1/fs;
    t = 0:dt:simTime-dt;
    N = length(t);
    
    
    %  Error Parameters from Datasheet
    % Gyroscope full-scale (FS_SEL=0 for ±250 dps)
    % Sensitivity: 131 LSB/(deg/s) 
    %
    % Bias (Zero Rate Output): Typical ±20 deg/s max variation.
    bias = 5; 
    
    % Scale factor error: ±3% typical (a percentage error on the ideal sensitivity)
    scaleFactorError = 0.03;  
    
    % Noise: from the datasheet, RMS noise is ~0.05 deg/s-rms (for DLPF settings)
    noiseStd = 0.05;  % standard deviation of noise
    
    % Optionally, include cross-axis sensitivity as a small coupling.When
    % simulating more than 1 axis.Cross coupling effects should be studied
    % experimentally and also through the datasheet.

    % Create the true angular rate signal (if not provided as a vector)
    if length(angularRateTrue) == 1
        % Assume constant true angular rate if a single value is given.
        angularRateTrue = angularRateTrue * ones(1, N);
    elseif length(angularRateTrue) ~= N
        error('Length of angularRateTrue must match the simulation time and sampling frequency.');
    end
    
    % Apply scale factor error and add bias
    measuredSignal = (angularRateTrue + bias) .* (1 + scaleFactorError);
    % Add white Gaussian noise
    noise = noiseStd * randn(1, N);
    
    gyroOutput = measuredSignal + noise;
    
    % Plot 
    figure;
    plot(t, angularRateTrue, 'k--', 'LineWidth',1.5); hold on;
    plot(t, gyroOutput, 'b');
    xlabel('Time (s)'); ylabel('Angular Rate (deg/s)');
    legend('True Angular Rate','Simulated Gyro Output');
    title('MPU-6050 Gyroscope Simulation');
    grid on;
end
