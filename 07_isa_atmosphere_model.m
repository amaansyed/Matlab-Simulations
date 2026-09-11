%% International Standard Atmosphere (ISA) Model
% Computes temperature, pressure, and density up to 25 km

clear; clc; close all;

alt = 0:100:25000; % m
[T, P, rho] = deal(zeros(size(alt)));

T0 = 288.15; P0 = 101325; R = 287.05; g0 = 9.80665;
L = 0.0065; % lapse rate K/m (troposphere)
h_trop = 11000;

for i = 1:length(alt)
    h = alt(i);
    if h <= h_trop
        T(i) = T0 - L*h;
        P(i) = P0 * (T(i)/T0)^(g0/(R*L));
    else
        T11 = T0 - L*h_trop;
        P11 = P0 * (T11/T0)^(g0/(R*L));
        T(i) = T11;
        P(i) = P11 * exp(-g0*(h-h_trop)/(R*T11));
    end
    rho(i) = P(i)/(R*T(i));
end

figure;
subplot(1,3,1); plot(T, alt/1000); xlabel('Temp (K)'); ylabel('Altitude (km)'); grid on;
subplot(1,3,2); plot(P/1000, alt/1000); xlabel('Pressure (kPa)'); grid on;
subplot(1,3,3); plot(rho, alt/1000); xlabel('Density (kg/m^3)'); grid on;
sgtitle('International Standard Atmosphere (0-25 km)');
