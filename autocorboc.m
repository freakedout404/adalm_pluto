% BPSK Modulation
bitsPerSymbol = 1; % Number of bits per symbol for BPSK
bpskSignal = 2*double(message) - 1; % BPSK modulation

% Transmit BPSK signal
plutoTx(bpskSignal.');

% Receiver Setup
plutoRx = sdrrx('Pluto'); % Create ADALM-PLUTO receiver object
plutoRx.RadioID = 'usb:1'; % Set radio ID
plutoRx.CenterFrequency = 2.45e9; % Set center frequency

% Receive BPSK signal
receivedSignal = plutoRx(); % Receive signal

% Demodulation of received signal
demodSignal = double(real(receivedSignal)) > 0; % BPSK demodulation

% Convert binary signal to characters
receivedMessage = reshape(char(bin2dec(reshape(num2str(demodSignal),[],8))),1,[]);
disp('Received Message:');
disp(receivedMessage);
