% Set up parameters
messageFreq = 100e3;  % 100 kHz message signal frequency
messageDuration = 1; % Signal duration in seconds
carrierFreq = 3.5e9;  % 3.5 GHz carrier frequency

% Generate message signal
Fs = 2 * messageFreq; % Sampling frequency
t = 0:1/Fs:messageDuration-1/Fs;
messageSignal = cos(2*pi*messageFreq*t);

% Get input text from the user
textToTransmit = input('Enter the text to transmit: ', 's');

% Convert text to ASCII values
asciiValues = double(textToTransmit);

% Convert ASCII values to binary
binaryData = dec2bin(asciiValues, 8);
binaryData = reshape(binaryData', 1, []);

% Convert binary data to logical type
binaryDataLogical = logical(str2num(binaryData')');

% Perform QPSK modulation
qpskModulator = comm.QPSKModulator('BitInput', true);
modulatedSignal = qpskModulator(binaryDataLogical');

% Upsample modulated signal to match the message signal frequency
upsampledSignal = upsample(modulatedSignal, Fs/messageFreq);

% Create complex carrier signal
carrierSignal = exp(1j*2*pi*carrierFreq*t);

% Multiply modulated signal with carrier signal
txSignal = carrierSignal .* upsampledSignal;

% Add AWGN to simulate channel noise
SNR = 10; % Signal-to-Noise Ratio in dB
rxSignal = awgn(txSignal, SNR);

% Reshape the received signal to a column vector
rxSignal = rxSignal(:);

% Perform QPSK demodulation
qpskDemodulator = comm.QPSKDemodulator('BitOutput', true);
demodulatedSignal = qpskDemodulator(rxSignal);

% Convert binary data to ASCII values
binaryDataRx = reshape(de2bi(demodulatedSignal)', 1, []);
asciiValuesRx = bi2de(reshape(binaryDataRx, 8, [])');

% Convert ASCII values to characters
receivedText = char(asciiValuesRx);

% Display transmitted and received text
disp('Transmitted Text:');
disp(textToTransmit);
disp('Received Text:');
disp(receivedText);
