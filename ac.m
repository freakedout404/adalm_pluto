% Set the BOC parameters
chipDuration = 1e-6;    % Chip duration in seconds
chipRate = 1e6;         % Chip rate in chips per second
dataRate = 100e3;       % Data rate in bits per second
codeLength = round(chipDuration * chipRate);
dataLength = round(chipDuration * dataRate);
dataBits = randi([0 1], 1, dataLength);  % Generate random data bits

% Generate BOC signal
bocSignal = zeros(1, codeLength);
for i = 1:dataLength
    chipIndex = round((i-1) * (chipRate/dataRate)) + 1;
    bocSignal(chipIndex) = 2 * dataBits(i) - 1;
end

% Scale the BOC signal to have unit amplitude
bocSignal = bocSignal / max(abs(bocSignal));

% Convert BOC signal to a complex signal
complexSignal = complex(bocSignal, zeros(size(bocSignal)));

% Text message to transmit
message = 'Hello, ADALM-PLUTO SDR!';

% Convert text message to binary representation
binaryMessage = dec2bin(message, 8);  % Convert each character to 8-bit binary

% Modulate text message onto the BOC signal
modulatedSignal = zeros(1, length(binaryMessage));
for i = 1:length(binaryMessage)
    chipIndex = round((i-1) * (chipRate/dataRate)) + 1;
    if binaryMessage(i) == '1' && chipIndex <= length(complexSignal)
        modulatedSignal(chipIndex) = complexSignal(chipIndex);
    elseif binaryMessage(i) == '0' && chipIndex <= length(complexSignal)
        modulatedSignal(chipIndex) = -complexSignal(chipIndex);
    end
end

% Convert the real-valued modulated signal to a complex signal
complexModulatedSignal = complex(modulatedSignal, zeros(size(modulatedSignal)));

% Release any existing ADALM-PLUTO radio object
if exist('transmitter', 'var') && isa(transmitter, 'comm.SDRTxPluto')
    release(transmitter);
end

% Transmit the complex modulated signal using ADALM-PLUTO SDR
transmitter = comm.SDRTxPluto('RadioID', 'usb:0', 'CenterFrequency', 1e9);
transmitter(complexModulatedSignal.');

% Receive the signal using ADALM-PLUTO SDR
numSamplesToReceive = 2 * length(complexModulatedSignal); % Ensure even number of samples per frame
receiver = comm.SDRRxPluto('RadioID', 'usb:0', 'CenterFrequency', 1e9, 'SamplesPerFrame', numSamplesToReceive);
receivedSignal = receiver();

% Plot the transmitted and received signals
figure;
subplot(2, 1, 1);
stem(real(complexModulatedSignal));
title('Transmitted Signal');
xlabel('Sample Index');
ylabel('Amplitude');

subplot(2, 1, 2);
stem(real(receivedSignal));
title('Received Signal');
xlabel('Sample Index');
ylabel('Amplitude');

% Calculate autocorrelation of received BOC signal
autocorrBOC = xcorr(receivedSignal);

% Plot the autocorrelation graph
figure;
plot(autocorrBOC);
title('Autocorrelation of Received Signal');
xlabel('Delay');
ylabel('Autocorrelation');
