%% Hohmann Transfer Orbit Between Two Circular Orbits
% Computes delta-v budget and plots the transfer ellipse

clear; clc; close all;

mu = 398600.4418; % km^3/s^2
Re = 6378;

r1 = Re + 300;   % initial circular orbit altitude 300 km
r2 = Re + 35786;  % target: GEO altitude

v1 = sqrt(mu/r1);
v2 = sqrt(mu/r2);

a_t = (r1 + r2)/2; % transfer ellipse semi-major axis
vp_t = sqrt(mu*(2/r1 - 1/a_t));
va_t = sqrt(mu*(2/r2 - 1/a_t));

dv1 = vp_t - v1;
dv2 = v2 - va_t;
dv_total = abs(dv1) + abs(dv2);

t_transfer = pi * sqrt(a_t^3/mu); % seconds

fprintf('Delta-v1 (departure burn): %.3f km/s\n', dv1);
fprintf('Delta-v2 (arrival burn):   %.3f km/s\n', dv2);
fprintf('Total delta-v:             %.3f km/s\n', dv_total);
fprintf('Transfer time:             %.2f hours\n', t_transfer/3600);

% Plot orbits
theta = linspace(0, 2*pi, 300);
figure; hold on; axis equal; grid on;

plot(r1*cos(theta), r1*sin(theta), 'b', 'LineWidth', 1.2);
plot(r2*cos(theta), r2*sin(theta), 'g', 'LineWidth', 1.2);

e_t = (r2 - r1)/(r2 + r1);
th_t = linspace(0, pi, 150);
r_t = a_t*(1 - e_t^2) ./ (1 + e_t*cos(th_t - pi));
plot(r_t.*cos(th_t), r_t.*sin(th_t), 'r--', 'LineWidth', 1.5);

legend('Initial Orbit', 'Target Orbit', 'Transfer Ellipse');
title('Hohmann Transfer Orbit');
xlabel('X (km)'); ylabel('Y (km)');
