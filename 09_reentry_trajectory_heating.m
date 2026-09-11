%% Atmospheric Reentry Trajectory and Stagnation Heating
% Ballistic reentry with exponential atmosphere and Sutton-Graves heating

clear; clc; close all;

Re = 6378e3;      % m
g0 = 9.81;
beta = 7200;       % ballistic coefficient m/s^2 equivalent (m/(Cd*A))... simplified as scalar
Rn = 0.3;          % nose radius (m)

% State: [altitude, velocity, flight path angle]
h0 = 120e3; v0 = 7800; gamma0 = deg2rad(-1.5);
state0 = [h0; v0; gamma0];

tspan = [0 400];
opts = odeset('Events', @groundHit, 'RelTol', 1e-8);
[t, sol] = ode45(@(t,s) reentryEOM(s, g0, Re, beta), tspan, state0, opts);

h = sol(:,1); v = sol(:,2);
rho = 1.225 * exp(-h/8500);

% Sutton-Graves stagnation-point heating correlation
qdot = 1.7415e-4 * sqrt(rho./Rn) .* v.^3; % W/m^2 (approx constant, illustrative)

figure;
subplot(3,1,1); plot(t, h/1000); ylabel('Altitude (km)'); grid on;
title('Reentry Trajectory and Heating');
subplot(3,1,2); plot(t, v); ylabel('Velocity (m/s)'); grid on;
subplot(3,1,3); plot(t, qdot/1e4); ylabel('Heat flux (W/cm^2)'); xlabel('Time (s)'); grid on;

[qmax, idx] = max(qdot);
fprintf('Peak heat flux: %.1f W/cm^2 at t = %.1f s, altitude = %.1f km\n', ...
    qmax/1e4, t(idx), h(idx)/1000);

function ds = reentryEOM(s, g0, Re, beta)
    h = s(1); v = s(2); gamma = s(3);
    rho = 1.225 * exp(-h/8500);
    g = g0 * (Re/(Re+h))^2;
    D = rho * v^2 / (2*beta); % deceleration due to drag

    ds = zeros(3,1);
    ds(1) = -v*sin(gamma);
    ds(2) = -D + g*sin(gamma);
    ds(3) = (g*cos(gamma)/v) - (v*cos(gamma)/(Re+h));
end

function [value, isterminal, direction] = groundHit(~, s)
    value = s(1);
    isterminal = 1;
    direction = -1;
end
