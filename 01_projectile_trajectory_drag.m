%% Projectile Trajectory with Quadratic Air Drag
% Simulates 2D motion of a launched body under gravity + drag

clear; clc; close all;

% Parameters
m = 5;              % mass (kg)
Cd = 0.47;           % drag coefficient (sphere)
rho = 1.225;         % air density (kg/m^3)
A = 0.05;            % cross-sectional area (m^2)
g = 9.81;            % gravity (m/s^2)
v0 = 120;            % launch speed (m/s)
theta0 = deg2rad(40);% launch angle

k = 0.5*Cd*rho*A/m;  % drag factor

% State: [x y vx vy]
state0 = [0 0 v0*cos(theta0) v0*sin(theta0)];
tspan = [0 30];

opts = odeset('Events', @(t,s) groundEvent(t,s), 'RelTol',1e-8);
[t, sol] = ode45(@(t,s) dynamics(t,s,k,g), tspan, state0, opts);

figure;
plot(sol(:,1), sol(:,2), 'LineWidth', 1.8);
xlabel('Range (m)'); ylabel('Altitude (m)');
title('Projectile Trajectory with Drag');
grid on;

fprintf('Range: %.1f m, Time of flight: %.2f s, Max altitude: %.1f m\n', ...
    sol(end,1), t(end), max(sol(:,2)));

function ds = dynamics(~, s, k, g)
    v = sqrt(s(3)^2 + s(4)^2);
    ds = zeros(4,1);
    ds(1) = s(3);
    ds(2) = s(4);
    ds(3) = -k*v*s(3);
    ds(4) = -g - k*v*s(4);
end

function [value, isterminal, direction] = groundEvent(~, s)
    value = s(2);
    isterminal = 1;
    direction = -1;
end
