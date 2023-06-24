%Clearing Everything
close all
clc



%Constants
f =1;
fs = 10000;
t = 0:1/fs:1-1/fs;
% t1 = 0:1/fs1:1-1/fs1;



%Sine-Wave
x = sin(2*pi*f*t);
% x1 = sin(2pif1t);
% x2 = x + x1;
% y = filter(H,1,x2)% add this statement



%time domian
figure
plot(t,x)
% hold
% plot(t,y)



% frequeny domain
x_dft = fft(x2,1024)
% y_dft = fft(y,1024) %Add this statement



figure
stem(abs(x_dft))
% hold
% stem(abs(y_dft),'r')