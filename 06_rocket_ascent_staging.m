%% Multi-Stage Rocket Ascent Simulation
% 1D vertical ascent with variable mass (Tsiolkovsky-based thrust)

clear; clc; close all;

g0 = 9.81;

% Stage data: [m0 mf Isp burnTime]  (kg, kg, s, s)
stages = [
    50000 15000 280 90;   % Stage 1
    12000  3000 320 60;   % Stage 2
];

dt = 0.1;
t = 0; v = 0; h = 0; m = stages(1,1);
T_hist = []; H_hist = []; V_hist = []; M_hist = [];

for i = 1:size(stages,1)
    m0 = stages(i,1); mf = stages(i,2); Isp = stages(i,3); tb = stages(i,4);
    mdot = (m0 - mf) / tb;
    F = mdot * Isp * g0; % thrust (N)

    for tt = 0:dt:tb
        rho = 1.225*exp(-h/8500);
        drag = 0.5*rho*v^2*0.3*1.2*sign(v)*-1; % simplistic drag opposing motion
        a = (F + drag)/m - g0;
        v = v + a*dt;
        h = h + v*dt;
        m = max(m - mdot*dt, mf);
        t = t + dt;

        T_hist(end+1) = t; H_hist(end+1) = h; %#ok<*SAGROW>
        V_hist(end+1) = v; M_hist(end+1) = m;
    end
    if i < size(stages,1)
        m = stages(i+1,1); % staging: new stage starts at its own m0
    end
end

figure;
subplot(3,1,1); plot(T_hist, H_hist/1000); ylabel('Altitude (km)'); grid on;
title('Multi-Stage Rocket Ascent');
subplot(3,1,2); plot(T_hist, V_hist); ylabel('Velocity (m/s)'); grid on;
subplot(3,1,3); plot(T_hist, M_hist); ylabel('Mass (kg)'); xlabel('Time (s)'); grid on;

fprintf('Final altitude: %.1f km, Final velocity: %.1f m/s\n', H_hist(end)/1000, V_hist(end));
