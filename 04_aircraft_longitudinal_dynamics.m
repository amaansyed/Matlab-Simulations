%% Aircraft Longitudinal Dynamics: Short-Period & Phugoid Modes
% Linearized state-space model, step response to elevator input

clear; clc; close all;

% State: [u(speed) alpha(AoA) q(pitch rate) theta(pitch)]
% Generic mid-size jet longitudinal derivatives (illustrative values)
Xu = -0.02; Xa = 5.0;
Zu = -0.3;  Za = -4.5; Zq = 0;
Mu = 0;     Ma = -8.0; Mq = -2.0;

A = [Xu Xa 0 -9.81;
     Zu/1 Za 1 0;
     Mu Ma Mq 0;
     0 0 1 0];

B = [0; -1.5; -10; 0]; % elevator effect
C = eye(4);
D = zeros(4,1);

sys = ss(A, B, C, D, 'StateName', {'u','alpha','q','theta'}, ...
    'InputName', 'elevator');

figure;
step(sys, 20);
title('Longitudinal Response to Elevator Step Input');
grid on;

% Extract and display natural modes
eigs = eig(A);
fprintf('Eigenvalues (modes):\n');
disp(eigs);

figure;
pzmap(sys);
title('Pole-Zero Map: Short-Period & Phugoid Modes');
grid on;
