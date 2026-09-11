%% PID Control of Aircraft Pitch Attitude
% Closed-loop tracking of a commanded pitch angle

clear; clc; close all;

% Simplified pitch dynamics: theta_ddot = Ma*alpha + Mq*qdot ... 
% Reduced 2nd order transfer function from elevator to pitch angle
num = [-10 -8];
den = [1 2.5 6 0];
G = tf(num, den);

% PID gains (tuned manually for reasonable response)
Kp = 2.0; Ki = 0.5; Kd = 0.8;
C = pid(Kp, Ki, Kd);

sys_cl = feedback(C*G, 1);

t = 0:0.01:15;
[y, tout] = step(sys_cl, t);
y = y * 10; % scale unit step response to 10 deg command

figure;
plot(tout, y, 'LineWidth', 1.8); hold on;
yline(10, '--r');
xlabel('Time (s)'); ylabel('Pitch angle (deg)');
title('PID-Controlled Pitch Attitude Response');
legend('Response','Command');
grid on;

info = stepinfo(sys_cl);
fprintf('Rise time: %.2f s, Overshoot: %.1f%%, Settling time: %.2f s\n', ...
    info.RiseTime, info.Overshoot, info.SettlingTime);
