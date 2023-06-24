% Connect to ADALM-PLUTO
dev = sdrdev('Pluto');
dev.RadioID = 'usb:0';

% BOC Signal Parameters
f0 = 10e6; % Carrier frequency
T = 1e-3; % Signal duration
fs = 10e6; % Sampling frequency
alpha = 0.5; % BOC modulation index
codeFreq = 1.023e6; % GPS code frequency

% Generate BOC Signal
t = 0:1/fs:T-1/fs; % Time vector
signal = cos(2*pi*f0*t) .* cos(2*pi*codeFreq*t + alpha*sin(2*pi*f0*t));

% Transmit BOC Signal using ADALM-PLUTO
transmitRepeat(dev, signal);

% Disconnect from ADALM-PLUTO
release(dev);
