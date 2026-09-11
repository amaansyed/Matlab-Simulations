%% Two-Body Orbital Propagation (Earth-centered)
% Numerically integrates the two-body equations of motion

clear; clc; close all;

mu = 398600.4418; % Earth gravitational parameter (km^3/s^2)

% Initial state (position km, velocity km/s) - elliptical LEO-ish orbit
r0 = [7000; 0; 0];
v0 = [0; 6.5; 3.0];
state0 = [r0; v0];

T_guess = 2*pi*sqrt(norm(r0)^3/mu); % rough period estimate
tspan = [0 2*T_guess];

opts = odeset('RelTol',1e-10,'AbsTol',1e-10);
[t, sol] = ode45(@(t,s) twoBodyEOM(s, mu), tspan, state0, opts);

figure;
plot3(sol(:,1), sol(:,2), sol(:,3), 'b'); hold on;
[xe,ye,ze] = sphere(30);
Re = 6378;
surf(Re*xe, Re*ye, Re*ze, 'FaceColor', [0.2 0.5 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.6);
axis equal; grid on;
xlabel('X (km)'); ylabel('Y (km)'); zlabel('Z (km)');
title('Two-Body Orbit Propagation');

function ds = twoBodyEOM(s, mu)
    r = s(1:3);
    v = s(4:6);
    rnorm = norm(r);
    a = -mu * r / rnorm^3;
    ds = [v; a];
end
