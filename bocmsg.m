% Transmitter

% Text message to transmit
message = 'Hello, World!';

% Modulation parameters
codeLength = 1023; % Length of spreading code
subcarrierFrequency = 1e6; % Subcarrier frequency in Hz
chipRate = 1e6; % Chip rate in Hz
modulationIndex = 0.5; % Modulation index

% Generate spreading code
spreadingCode = 2 * randi([0, 1], 1, codeLength) - 1;

% Convert text message to binary
binaryMessage = dec2bin(message, 8); % Convert each character to 8-bit binary

% Reshape binary message to match the length of the spreading code
reshapedMessage = reshape(binaryMessage', 1, []);

% Spread the message with the spreading code
spreadMessage = modulationIndex * spreadingCode .* repmat(reshapedMessage, 1, length(spreadingCode));

% Modulate the spread message with the subcarrier
t = (0:1/chipRate:(length(spreadingCode)*length(binaryMessage))/chipRate - 1/chipRate);
modulatedSignal = spreadMessage .* cos(2 * pi * subcarrierFrequency * t);

% Receiver

% Demodulate the received signal
demodulatedSignal = modulatedSignal .* cos(2 * pi * subcarrierFrequency * t);

% Integrate and dump to recover the spread message
recoveredMessage = zeros(1, length(binaryMessage));
for i = 1:length(binaryMessage)
    integratedValue = sum(demodulatedSignal((i-1)*codeLength+1:i*codeLength)) / chipRate;
    if integratedValue > 0
        recoveredMessage(i) = 1;
    else
        recoveredMessage(i) = 0;
    end
end

% Convert the recovered binary message to characters
recoveredText = char(bin2dec(reshape(num2str(recoveredMessage), 8, []).'));

% Display the transmitted and received messages
disp('Transmitted Message:');
disp(message);
disp('Received Message:');
disp(recoveredText);
