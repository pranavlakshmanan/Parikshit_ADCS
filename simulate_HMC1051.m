function Vout = simulate_HMC1051(B_in, params)

   
%   for an applied magnetic field B_in (in gauss). The simulation includes
%   nominal sensitivity, offset error, non-linearity, hysteresis, repeatability,
%   and additive noise.

%Output= Vout 

% Inputs - 
%   FS = Full scale reading 
%   B_in: input magnetic field (gauss)
%   params: structure with the following fields (default values assumed):
%     .Vbridge        - Bridge supply voltage [V] (e.g., 5 V)
%     .sensitivity    - Nominal sensitivity [mV/V/gauss] (typical = 1.0)
%     .offset_bias    - Bridge offset error [mV/V] (typical ±1.25, here set to 1.25)
%     .nonlin_pctFS   - Linearity error as percentage of full scale (typical 0.5% FS)
%     .hysteresis_pctFS - Hysteresis error (% FS, typical 0.06% FS)
%     .repeat_pctFS   - Repeatability error (% FS, typical 0.05% FS)
%     .noise_density  - Noise density [nV/sqrtHz] (50 nV/sqrtHz)
%     .bandwidth      - Measurement bandwidth [Hz] (e.g., 10 Hz)

    % Assumed paramaters 
    if nargin < 2
        params.Vbridge = 5;              % Supply voltage in volts
        params.sensitivity = 1.0;        % mV/V/gauss
        params.offset_bias = 1.25;       % mV/V (nominal offset)
        params.nonlin_pctFS = 0.5;       % % of full-scale (FS = 6 gauss)
        params.hysteresis_pctFS = 0.06;  % % of full-scale
        params.repeat_pctFS = 0.05;      % % of full-scale
        params.noise_density = 50;       % nV/sqrt(Hz)
        params.bandwidth = 10;           % Hz
    end

    FS = 6; % Full-scale magnetic field in gauss (±6 gauss range)

    % Nominal sensitivity voltage (mV output per gauss)
    nominal_sensitivity = params.sensitivity * params.Vbridge; % in mV/gauss

    % Calculate nominal sensor output (in mV) without errors
    V_nominal = nominal_sensitivity * B_in;
    
    % Include offset error (converted to mV) – assume a constant bias
    offset_voltage = params.offset_bias * params.Vbridge; % mV offset at 0 gauss

    % Non-linearity error: modeled as a small additional error proportional to B_in^3.
    % The non-linearity error magnitude (in gauss) is given by:
    nonlin_error_gauss = (params.nonlin_pctFS/100) * FS * sign(B_in) * (abs(B_in)/FS)^2;
    V_nonlin = nominal_sensitivity * nonlin_error_gauss;
    
    % Hysteresis error: modeled as a small fixed error (in gauss)
    hysteresis_error_gauss = (params.hysteresis_pctFS/100) * FS * sign(B_in);
    V_hyst = nominal_sensitivity * hysteresis_error_gauss;
    
    % Repeatability error: random error drawn from a uniform distribution 
    repeat_error_gauss = ((params.repeat_pctFS/100) * FS) * (2*rand()-1);
    V_repeat = nominal_sensitivity * repeat_error_gauss;
    
    % Noise: RMS noise voltage (in mV) calculated from noise density and bandwidth
    noise_rms = (params.noise_density * 1e-6) * sqrt(params.bandwidth) * 1e3; % convert nV to mV
    V_noise = noise_rms * randn();
    
    % Combine all error contributions
    Vout = V_nominal + offset_voltage + V_nonlin + V_hyst + V_repeat + V_noise;
    
    % Optionally, convert output to volts if needed:
    % Vout = Vout / 1e3;
end

