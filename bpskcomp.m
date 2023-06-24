% Connect to ADALM-Pluto
dev = 'Pluto';  % Device name
uri = 'ip:192.168.2.1';  % IP address of ADALM-Pluto
sdr = adi.AD936x('uri', uri, 'EnableTunerAGC', true);

% Set sample rate and center frequency
Fs = 10e6;         % Sample rate
Fc = 1e9;          % Center frequency
sdr.SampleRate = Fs;
sdr.CenterFrequency = Fc;

% Generate BPSK signal
numSamples = 1024;  % Number of samples
data = randi([0 1], numSamples, 1);  % Generate random data
modulatedData = pskmod(data, 2, pi/2);  % Modulate data using BPSK

% Transmit the modulated data
sdr(transpose(real(modulatedData)));

% Receive the transmitted signal
numCaptureSamples = numSamples;  % Number of samples to capture
receivedSignal = sdr();  % Receive the signal
receivedSignal = receivedSignal(1:numCaptureSamples);  % Extract the captured samples

% Calculate the autocorrelation of the received signal
autocorrSignal = xcorr(receivedSignal, 'coeff');  % Calculate autocorrelation

% Plot the autocorrelation result
lags = -numCaptureSamples+1:numCaptureSamples-1;  % Lags corresponding to the autocorrelation
plot(lags, autocorrSignal);
title('Autocorrelation of BPSK Signal (ADALM-Pluto)');
xlabel('Lag');
ylabel('Autocorrelation');