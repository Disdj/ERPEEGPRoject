%% clear all
clearvars
close all
clc

%% data import
[~,data]                = edfread('24_sg_2.edf');
data                    = data(2,:);

%% spectrum
fs                      = 512;
Y                       = fft(data);
Y                       = fftshift(Y);
n                       = length(data);
vect_f                  = (-n/2:n/2-1)*(fs/n);
pw                      = abs(Y).^2/n;


Spectrum                = figure('name','Spectrum');
hold on;    grid on;
plot(vect_f,pw,'LineWidth',2);
xlim([45 55]);