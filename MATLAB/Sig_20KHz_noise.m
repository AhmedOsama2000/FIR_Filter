%% Generate a signal to test the FIR Filter 
%% Generate a sine wave then add some noise to it
% Set the parameters
clear;
clc;
close all;
f = 20e3; % Frequency of 20 kHz
fs = 10*f; % Sampling frequency, at least 10 times the signal frequency
t = 0:1/fs:1; % Time vector

% Generate the sine wave
sine_wave = sin(1*2*pi*f*t);

% Plot the sine wave
plot(t, sine_wave);
title('Sine Wave of 20 kHz');
xlabel('Time (s)');
ylabel('Amplitude');


%% Now Generate a noise with a high frequency to test LPF Functionality
% Add a noise
noise = rand(1,length(sine_wave));
sine_with_noise = noise + sine_wave;
figure();plot(sine_with_noise);
grid on;
xlabel('Time');
ylabel('Amplitude');
title('Sine wave + Noise');

% Convert from real to integers
sample_length = 16;
scaling = 7;
sine_noise_integers = round(sine_with_noise.*(2^scaling));
figure();plot(1:length(sine_noise_integers), sine_noise_integers);
grid on;
xlabel('\bf Time');
ylabel('\bf Amplitude');
title('\bf Sine wave + Noise : Scaled Signal');

%% Convert from integers to hexa to capture the sample test in a text file
sine_noise_in_hex = dec2hex(mod((sine_noise_integers),2^sample_length),sample_length);
yy = cellstr(sine_noise_in_hex);
fid = fopen('signal_20KHz+noise.txt', 'wt');
fprintf(fid, '%s \n', yy{:});
