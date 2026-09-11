%% Simplified Satellite Orbital Decay due to Atmospheric Drag
% Uses averaged energy-loss model on a near-circular LEO orbit

clear; clc; close all;

mu = 398600.4418;   % km^3/s^2
Re = 6378;           % km
Cd = 2.2;
A = 10e-6;            % km^2 (10 m^2)
m = 500;              % kg

alt0 = 300;           % km initial altitude
r0 = Re + alt0;

tspan = [0 60*60*24*30]; % 30 days in seconds
opts = odeset('RelTol',1e-8);
[t, r] = ode45(@(t,r) decayRate(r, mu, Re, Cd, A, m), tspan, r0, opts);

alt = r - Re;

figure;
plot(t/86400, alt, 'LineWidth', 1.8);
xlabel('Time (days)'); ylabel('Altitude (km)');
title('Orbital Altitude Decay from Atmospheric Drag');
grid on;

function drdt = decayRate(r, mu, Re, Cd, A, m)
    alt = r - Re;
    rho = atmosDensity(alt); % kg/km^3 after conversion inside function
    v = sqrt(mu/r);
    % Energy loss rate converted to altitude loss rate (simplified model)
    drdt = -(Cd*A/m) * rho * v * r;
end

function rho = atmosDensity(alt_km)
    % Simple exponential atmosphere model, returns kg/km^3
    rho0 = 1.225e9; % kg/km^3 at sea level (1.225 kg/m^3 * 1e9)
    H = 50;         % scale height (km), tuned for illustrative decay
    rho = rho0 * exp(-alt_km/H);
end
