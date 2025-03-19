fs = 1000;          % 1 kHz sampling frequency
simTime = 5;        % simulate for 5 seconds
trueRate = 50;      % assume a constant 50 deg/s rotation

simulatedOutput = simulategyro(trueRate, fs, simTime);
